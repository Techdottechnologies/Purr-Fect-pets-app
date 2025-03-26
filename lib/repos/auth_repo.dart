import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/page/auth/login_page.dart';

import '../exceptions/app_exceptions.dart';
import '/models/location_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../utils/utils.dart';
import '../services/web/firebase_auth_serivces.dart';
import 'user_repo.dart';
import 'validations/check_validation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  int userFetchFailureCount = 0;
  //  LoginUser ====================================
  Future<void> loginUser(
      {required String withEmail, required String withPassword}) async {
    try {
      // Make Validation
      await CheckVaidation.loginUser(email: withEmail, password: withPassword);
      final _ = await FirebaseAuthService()
          .login(withEmail: withEmail, withPassword: withPassword);
      await UserRepo().fetch();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> sendEmailVerifcationLink() async {
    try {
      await FirebaseAuthService().sendEmailVerifcationLink();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

//  RegisteredAUser ====================================
  Future<void> registeredUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    LocationModel? location,
  }) async {
    try {
      /// Make validation
      await CheckVaidation.onCreateUser(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phoneNumber,
        location: location,
      );

      // Create user After validation
      final UserCredential userCredential = await FirebaseAuthService()
          .registerUser(email: email, password: password);
      await UserRepo().create(
        uid: userCredential.user?.uid ?? "",
        name: name,
        email: email,
        phone: phoneNumber,
        location: location!,
      );
      sendEmailVerifcationLink();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Return Login user object
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Perform Logout
  Future<void> performLogout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuthService().logoutUser();
    UserRepo().clearAll();

    // /// UnSubscribe notifications
    // PushNotificationServices().unsubscribe(
    //     forTopic:
    //         "$PUSH_NOTIFICATION_FRIEND_REQUEST${UserRepo().currentUser.uid}");

    /// Removing Get Instances
    // Get.deleteAll(force: true);
    // Get.offAll(LoginPage());
  }

  /// Perform Logout
  Future<void> sendForgotPasswordEmail({required String atMail}) async {
    if (atMail == "") {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: atMail)) {
      throw AuthExceptionInvalidEmail();
    }
    await FirebaseAuthService().resetPassword(email: atMail);
  }

  /// =========================== Social Auth Methods ================================
  //  Login With Apple ====================================
  Future<void> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      AuthCredential authCredential = OAuthProvider("apple.com").credential(
          accessToken: credential.authorizationCode,
          idToken: credential.identityToken);
      await FirebaseAuthService()
          .loginWithCredentials(credential: authCredential);
      await _fetchOrCreateUser();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Mostly used for Social Account Authenticatopn
  Future<void> _fetchOrCreateUser() async {
    try {
      await UserRepo().fetch();
      userFetchFailureCount = 0;
    } on AppException catch (e) {
      if (AppManager.currentUser == null || e is AuthExceptionUserNotFound) {
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          if (userFetchFailureCount <= 1) {
            await UserRepo().create(
              uid: user.uid,
              name: user.displayName ?? "",
              avatarUrl: user.photoURL,
              email: user.email ?? "",
              phone: "",
              location: null,
            );
            _fetchOrCreateUser();
          } else {
            throw throwAppException(e: e);
          }
          userFetchFailureCount += 1;
        }
        return;
      }
      throw throwAppException(e: e);
    }
  }

  //  Login With Google ====================================
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuthService().loginWithCredentials(credential: credential);
      await _fetchOrCreateUser();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
