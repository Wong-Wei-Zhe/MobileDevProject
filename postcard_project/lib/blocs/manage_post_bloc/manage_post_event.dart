part of 'manage_post_bloc.dart';

abstract class ManagePostEvent extends Equatable {
  const ManagePostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostEvent extends ManagePostEvent {
  final String title;
  final String description;
  final String imgUrl;

  const CreatePostEvent(this.title, this.description, this.imgUrl);
}

class CreatePostSucceedEvent extends ManagePostEvent {}

class DeletePostEvent extends ManagePostEvent {
  final String postId;

  const DeletePostEvent(this.postId);
}

class DeletePostSucceedEvent extends ManagePostEvent {}

class ManagePostSucceedEvent extends ManagePostEvent {}

class ManagePostFailEvent extends ManagePostEvent {
  final List<String> _errors;

  const ManagePostFailEvent(this._errors);

  List<String> get errors => _errors;
}
