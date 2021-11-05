import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:postcard_project/models/postcard_model.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';

part 'postcard_event.dart';
part 'postcard_state.dart';

class PostcardBloc extends Bloc<PostcardEvent, PostcardState> {
  PostcardApiProvider postCardApi;

  PostcardBloc(this.postCardApi) : super(const PostcardState()) {
    on<PostcardEvent>(_postCardEvent);
    on<PostCardFetchEvent>(_postCardFetchEvent);
    on<PostCardFetchSuccessEvent>(_postCardFetchSuccessEvent);
  }

  void initializeApiListen() {
    postCardApi.postCardAPIController.listen((message) {
      final decodedMessage = jsonDecode(message);

      if (decodedMessage["type"] == 'all_posts') {
        List<PostCardModel> tempData = [];
        decodedMessage["data"]["posts"].forEach((data) => {
              tempData.add(PostCardModel(
                  id: data["_id"],
                  title: data["title"],
                  description: data["description"],
                  imageUrl: data["image"],
                  date: data["date"],
                  author: data["author"]))
            });
        print("DATA LENGTH!");
        print(tempData.length);
        add(PostCardFetchSuccessEvent(tempData));
      }

      // List<String> lastPostList = [];
      // print('LENGTH!');
      // print(decodedMessage["data"]["posts"].length);
      // decodedMessage["data"]["posts"]
      //     .forEach((data) => lastPostList.add(data["_id"]));
      // print(lastPostList);
      // postCardApi.sendGetPostcardRequest(lastPostList[0], 'date', 1);
    });
  }

  void _postCardEvent(PostcardEvent event, Emitter<PostcardState> emit) {
    emit(PostcardInitial());
  }

  void _postCardFetchEvent(
      PostCardFetchEvent event, Emitter<PostcardState> emit) {
    if (state.status == PostFetchStatus.initial) {
      postCardApi.sendGetPostcardRequest();
    }
  }

  void _postCardFetchSuccessEvent(
      PostCardFetchSuccessEvent event, Emitter<PostcardState> emit) {
    emit(state.copyObj(
        status: PostFetchStatus.success, postCards: event.postCards));
  }
}
