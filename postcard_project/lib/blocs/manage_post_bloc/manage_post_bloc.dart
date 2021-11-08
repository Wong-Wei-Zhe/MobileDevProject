import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';

part 'manage_post_event.dart';
part 'manage_post_state.dart';

class ManagePostBloc extends Bloc<ManagePostEvent, ManagePostState> {
  PostcardApiProvider postCardApi;
  int lastDeletedIndex = 0;

  ManagePostBloc(this.postCardApi) : super(ManagePostInitial()) {
    on<ManagePostEvent>(_managePostEvent);
    on<CreatePostEvent>(_createPostEvent);
    on<DeletePostEvent>(_deletePostEvent);
    on<CreatePostSucceedEvent>(_createPostSucceedEvent);
    on<DeletePostSucceedEvent>(_deletePostSucceedEvent);
    on<ManagePostSucceedEvent>(_managePostSucceedEvent);
    on<ManagePostFailEvent>(_managePostFailEvent);
  }

  void initializeApiListen() {
    try {
      postCardApi.postCardAPIController.listen((message) {
        final decodedMessage = jsonDecode(message);

        try {
          if (decodedMessage["type"] == 'new_post') {
            add(CreatePostSucceedEvent());
          }

          if (decodedMessage["type"] == 'delete_post') {
            if (decodedMessage["data"]["response"] == 'OK') {
              add(DeletePostSucceedEvent());
            } else {
              add(ManagePostFailEvent(decodedMessage["errors"].cast<String>()));
            }
          }

          if (decodedMessage["type"] == 'error') {
            add(ManagePostFailEvent(decodedMessage["errors"].cast<String>()));
          }
        } catch (e) {
          add(const ManagePostFailEvent(['Something went wrong.']));
        }
      });
    } catch (e) {
      add(const ManagePostFailEvent(['Error Web Connection Problem']));
    }
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

  void _deletePostSucceedEvent(
      DeletePostSucceedEvent event, Emitter<ManagePostState> emit) {
    emit(DeletePostSucceedState());
  }

  void _deletePostEvent(DeletePostEvent event, Emitter<ManagePostState> emit) {
    postCardApi.sendDeletePostRequest(event.postId);
    lastDeletedIndex = event.index;
    emit(DeletePostSubmittingState());
  }

  void _managePostSucceedEvent(
      ManagePostSucceedEvent event, Emitter<ManagePostState> emit) {
    emit(ManagePostSucceedState());
  }

  void _managePostFailEvent(
      ManagePostFailEvent event, Emitter<ManagePostState> emit) {
    emit(ManagePostFailedState(event.errors));
  }
}
