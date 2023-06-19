import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/services/shared_prefs.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final NoteService _noteService = NoteService();
  late TextEditingController _password;

  @override
  void initState() {
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: GradientButton(
        onPressed: () {
          showAuthDialog(context: context);
        },
        child: const Text('Enable biometrics'),
      ),
    );
  }

  void showAuthDialog({required BuildContext context}) {
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
                                child: const Text('Unlock'),
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
