import 'package:flutter/foundation.dart';
import 'package:time_ticker/app/sign_in/validator.dart';
import 'package:time_ticker/app/sign_in/emailSignInModel.dart';
import 'package:time_ticker/services/auth.dart';


class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = "",
    this.password = "",
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthBase auth;

  // Provider -> mutable variable
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create an Account";
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have an account? Sign in";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            this.email, this.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: "",
      password: "",
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType = formType ?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submitted = submitted ?? this.submitted;
      notifyListeners();
  }

}
