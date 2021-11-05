part of 'user_account_bloc.dart';

@immutable
abstract class UserAccountState {}

class UserAccountInitial extends UserAccountState {}

class UserSignInSuccessState extends UserAccountState {
  final String _response;

  UserSignInSuccessState(this._response);

  String get response => _response;
}

class UserSignInFailedState extends UserAccountState {
  final List<String> _errors;

  UserSignInFailedState(this._errors);

  List<String> get errors => _errors;

  @override
  String toString() {
    return 'Error: $_errors';
  }
}

class UserSignInProgressingState extends UserAccountState {}
