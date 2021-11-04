part of 'user_account_bloc.dart';

@immutable
abstract class UserAccountEvent {}

class UserSignInEvent extends UserAccountEvent {}

class UserClosedEvent extends UserAccountEvent {}
