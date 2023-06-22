import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/biometric_auth.dart';
import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/services/shared_prefs.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/utilities/routes.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Dialogs _dialogs = Dialogs();
  String avatarLetter =
      AuthUser.getCurrentUser().username.substring(0, 1).toUpperCase();
  late TextEditingController _email;
  late TextEditingController _username;
  late TextEditingController _notesPin;
  final NoteService _noteService = NoteService();
  late TextEditingController _password;
  bool _obscureText = true;
  bool _fieldsChanged = false;
  bool stateKeeper = true;
  @override
  void initState() {
    _username = TextEditingController();
    _notesPin = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    initializeFields();
    super.initState();
  }

  void initializeFields() {
    _username.text = AuthUser.getCurrentUser().username;
    _notesPin.text = AuthUser.getCurrentUser().notesPin;
    _email.text = AuthUser.getCurrentUser().email;
  }

  void changed() {
    if (_username.text != AuthUser.getCurrentUser().username ||
        _notesPin.text != AuthUser.getCurrentUser().notesPin) {
      setState(() {
        _fieldsChanged = true;
      });
    } else {
      setState(() {
        _fieldsChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Account',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                bool isSure = await Dialogs.showConfirmationDialog(
                    context: context,
                    type: 'delete',
                    text: 'Are you sure you want to delete your account?',
                    button: 'Delete');

                if (isSure) {
                  UserService().deleteUser();
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Palette.redTodo,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Palette.primaryColor,
                child: Text(
                  avatarLetter,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Palette.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _username,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (value) {
                  changed();
                },
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
                autocorrect: false,
                enableSuggestions: false,
                onSubmitted: (_) {},
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _notesPin,
                keyboardType: TextInputType.phone,
                obscureText: _obscureText,
                autocorrect: false,
                enableSuggestions: false,
                onSubmitted: (_) {},
                decoration: InputDecoration(
                  hintText: 'Notes Pin',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 35),
              FutureBuilder(
                future: BiometricAuth().canAuthenticate(),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.done) {
                    return FutureBuilder(
                        future: SharedPrefs.readFromPrefs(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final isThere = snapshot.data as String?;

                            if (isThere == null) {
                              if (snapshot1.data as bool) {
                                return Column(children: [
                                  const Text(
                                      'Your device supports biometric authentication',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Palette.textColorVariant,
                                        fontSize: 14,
                                      )),
                                  const SizedBox(height: 5),
                                  GradientButton(
                                    onPressed: () {
                                      setState(() {
                                        stateKeeper = !stateKeeper;
                                      });
                                      showAuthDialogForAccounts(
                                          context: context);
                                    },
                                    child: const Text('Enable Biometrics'),
                                  ),
                                  const SizedBox(height: 15),
                                ]);
                              } else {
                                return Container();
                              }
                            } else {
                              if (snapshot1.data as bool) {
                                return Column(children: [
                                  const Text(
                                      'Use PIN for unlocking notes instead?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Palette.textColorVariant,
                                        fontSize: 14,
                                      )),
                                  const SizedBox(height: 5),
                                  GradientButton(
                                    onPressed: () async {
                                      await SharedPrefs.delFromPrefs();
                                      setState(() {
                                        stateKeeper = !stateKeeper;
                                      });
                                    },
                                    child: const Text('Disable Biometrics'),
                                  ),
                                  const SizedBox(height: 15),
                                ]);
                              } else {
                                return Container();
                              }
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const Text('Request a change of password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Palette.textColorVariant,
                    fontSize: 14,
                  )),
              const SizedBox(height: 5),
              GradientButton(
                onPressed: () {
                  UserService().changePassword();
                },
                child: const Text('Change Password'),
              ),
              _fieldsChanged
                  ? Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Container(
                        height: 44,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.success,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () async {
                            await UserService().puUser(
                                username: _username.text, pin: _notesPin.text);
                            await UserService().logOut();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    signInRoute, (route) => false);
                              }
                            });
                          },
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void showAuthDialogForAccounts({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Palette.backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: 300,
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              TextField(
                                autofocus: true,
                                maxLength: 4,
                                controller: _password,
                                autocorrect: false,
                                enableSuggestions: false,
                                obscureText: true,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_person),
                                  hintText: 'Pin',
                                  counterText: '',
                                ),
                              ),
                              const SizedBox(height: 10),
                              GradientButton(
                                onPressed: () {
                                  if (_noteService.unlockNote(_password.text)) {
                                    Navigator.of(context).pop();
                                    SharedPrefs.addToPrefs(pin: _password.text);
                                  }
                                },
                                child: const Text('Enable'),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
