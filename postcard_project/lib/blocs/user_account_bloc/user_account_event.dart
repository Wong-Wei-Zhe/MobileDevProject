part of 'user_account_bloc.dart';

@immutable
abstract class UserAccountEvent {}

class UserSignInEvent extends UserAccountEvent {
  final String _userNameStr;

  UserSignInEvent(this._userNameStr);

  String get userNameStr => _userNameStr;
}

class UserSignInSuccessEvent extends UserAccountEvent {
  final String _response;

  UserSignInSuccessEvent(this._response);

  String get response => _response;
}

class UserSignInFailedEvent extends UserAccountEvent {
  final List<String> _errors;

  UserSignInFailedEvent(this._errors);

  List<String> get errors => _errors;
}

class UserClosedEvent extends UserAccountEvent {}
