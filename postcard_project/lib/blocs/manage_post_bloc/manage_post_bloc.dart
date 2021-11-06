import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';

part 'manage_post_event.dart';
part 'manage_post_state.dart';

class ManagePostBloc extends Bloc<ManagePostEvent, ManagePostState> {
  PostcardApiProvider postCardApi;

  ManagePostBloc(this.postCardApi) : super(ManagePostInitial()) {
    on<ManagePostEvent>(_managePostEvent);
    on<CreatePostEvent>(_createPostEvent);
    on<CreatePostSucceedEvent>(_createPostSucceedEvent);
    on<DeletePostEvent>(_deletePostEvent);
    on<ManagePostSucceedEvent>(_managePostSucceedEvent);
    on<ManagePostFailEvent>(_managePostFailEvent);
  }

  void initializeApiListen() {
    postCardApi.postCardAPIController.listen((message) {
      final decodedMessage = jsonDecode(message);

      if (decodedMessage["type"] == 'new_post') {
        add(CreatePostSucceedEvent());
      }

      if (decodedMessage["type"] == 'error') {
        add(ManagePostFailEvent(decodedMessage["errors"].cast<String>()));
      }
    });
  }

  void _managePostEvent(ManagePostEvent event, Emitter<ManagePostState> emit) {}

  void _createPostEvent(CreatePostEvent event, Emitter<ManagePostState> emit) {
    postCardApi.sendCreatePostRequest(
        event.title, event.description, event.imgUrl);

    emit(CreatePostSubmittingState());
  }

  void _createPostSucceedEvent(
      CreatePostSucceedEvent event, Emitter<ManagePostState> emit) {
    emit(CreatePostSucceedState());
  }

  void _deletePostEvent(DeletePostEvent event, Emitter<ManagePostState> emit) {}

  void _managePostSucceedEvent(
      ManagePostSucceedEvent event, Emitter<ManagePostState> emit) {}

  void _managePostFailEvent(
      ManagePostFailEvent event, Emitter<ManagePostState> emit) {
    emit(ManagePostFailedState(event.errors));
  }
}
