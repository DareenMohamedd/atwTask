import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String successMessage;
  LoginSuccess(this.successMessage);
}
class LoginError extends LoginState {
  final String errorMessage;
  LoginError(this.errorMessage);
}
class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  LoginCubit() : super(LoginInitial());
  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        emit(LoginSuccess("Login successful!"));
      } else {
        emit(LoginError("Authentication failed"));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(LoginError("An error occurred. Please try again."));
    }
  }
}
