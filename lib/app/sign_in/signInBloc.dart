import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_ticker/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  /*
  * The Commented code is using StreamController
  * */
//  final StreamController<bool> _isLoadingController = StreamController<bool>();
//
//  Stream<bool> get isLoadingStream => _isLoadingController.stream;

//  void dispose() {
//    _isLoadingController.close();
//  }
//
//  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

//  Future<User> _signIn(Future<User> Function() signInMethod) async {
//    try {
//      _setIsLoading(true);
//      return await signInMethod();
//    } catch (e) {
//      _setIsLoading(false);
//      rethrow;
//    }
//  }

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<void> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
