import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      return false;
    }
    return await auth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    try {

      if (!await canAuthenticate()) return false;

        return await auth.authenticate(
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ),
          localizedReason: 'Use Face Id to authenticate',
          authMessages: const [
            AndroidAuthMessages(
                signInTitle: 'Unlock Note', cancelButton: 'Back'),
          ],
        );
      
    } catch (e) {
      print('error $e');
      return false;
    }
  }
}
