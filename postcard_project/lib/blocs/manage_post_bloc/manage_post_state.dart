part of 'manage_post_bloc.dart';

abstract class ManagePostState extends Equatable {
  const ManagePostState();

  @override
  List<Object> get props => [];
}

class ManagePostInitial extends ManagePostState {}

class CreatePostSubmittingState extends ManagePostState {}

class DeletePostSubmittingState extends ManagePostState {}

class CreatePostSucceedState extends ManagePostState {}

class DeletePostSucceedState extends ManagePostState {}

class ManagePostSucceedState extends ManagePostState {}

class ManagePostFailedState extends ManagePostState {
  final List<String> _errors;

  const ManagePostFailedState(this._errors);

  List<String> get errors => _errors;

  @override
  String toString() {
    return 'Error: $_errors';
  }
}
