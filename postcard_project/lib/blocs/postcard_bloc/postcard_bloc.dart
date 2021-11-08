import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:postcard_project/models/postcard_model.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'postcard_event.dart';
part 'postcard_state.dart';

class PostcardBloc extends Bloc<PostcardEvent, PostcardState> {
  PostcardApiProvider postCardApi;
  late String _loggedUser;

  PostcardBloc(this.postCardApi) : super(PostcardState()) {
    on<PostcardEvent>(_postCardEvent);
    on<PostCardFetchEvent>(_postCardFetchEvent);
    on<PostCardFetchSuccessEvent>(_postCardFetchSuccessEvent);
  }

  void initializeApiListen() {
    postCardApi.postCardAPIController.listen((message) {
      final decodedMessage = jsonDecode(message);

      if (decodedMessage["type"] == 'all_posts') {
        _allPostProccess(decodedMessage);
      }
    });
  }

  void _allPostProccess(dynamic decodedMessage) async {
    final prefs = await SharedPreferences.getInstance();

    dynamic encodedFavoriteList;
    List<String> favoriteList = [];
    if (prefs.containsKey('favoritelist')) {
      encodedFavoriteList = prefs.getString('favoritelist');
      jsonDecode(encodedFavoriteList).forEach((data) => favoriteList.add(data));
    }

    List<PostCardModel> tempData = [];
    DateTime tempDate;
    decodedMessage["data"]["posts"].forEach((data) => {
          tempDate = DateTime.parse(data["date"]),
          tempData.add(PostCardModel(
            id: data["_id"],
            title: data["title"],
            description: data["description"],
            imageUrl: data["image"],
            date: DateFormat("yyyy-MM-dd hh:mm:ss").format(tempDate),
            author: data["author"],
            selfAuthor: data["author"] == _loggedUser ? true : false,
            favorite: favoriteList.contains(data["_id"]) ? true : false,
          ))
        });

    add(PostCardFetchEvent(
        status: PostFetchStatus.success, postCards: tempData));
  }

  void logUserName(String userName) {
    _loggedUser = userName;
  }

  void _postCardEvent(PostcardEvent event, Emitter<PostcardState> emit) {
    emit(PostcardInitial());
  }

  void _postCardFetchEvent(
      PostCardFetchEvent event, Emitter<PostcardState> emit) {
    state.status = event.status;
    state.postCards = event.postCards;
    if (state.status == PostFetchStatus.initial) {
      postCardApi.sendGetPostcardRequest();
    }
    if (state.status == PostFetchStatus.success) {
      emit(state.copyWith(
          status: PostFetchStatus.success, postCards: event.postCards));
    }
    if (state.status == PostFetchStatus.removeat) {
      event.postCards.removeAt(event.removeIndex);
      PostFetchStatus emitStatus = PostFetchStatus.success;
      if (event.deleteAtStatus != PostFetchStatus.initial) {
        emitStatus = event.deleteAtStatus;
      }

      emit(state.copyWith(status: emitStatus, postCards: event.postCards));
    }
    if (state.status == PostFetchStatus.refresh) {
      postCardApi.sendGetPostcardRequest();
    }
    if (state.status == PostFetchStatus.favorite) {
      _getFavoritePost(event.postCards).then((value) => emit(
          state.copyWith(status: PostFetchStatus.favorite, postCards: value)));
    }
    if (state.status == PostFetchStatus.ownpost) {
      emit(state.copyWith(
          status: PostFetchStatus.ownpost, postCards: event.postCards));
    }
  }

  void _postCardFetchSuccessEvent(
      PostCardFetchSuccessEvent event, Emitter<PostcardState> emit) {
    emit(state.copyWith(
        status: PostFetchStatus.success, postCards: event.postCards));
  }

  Future<List<PostCardModel>> _getFavoritePost(
      List<PostCardModel> postCards) async {
    final prefs = await SharedPreferences.getInstance();

    dynamic encodedFavoriteList;
    List<String> favoriteList = [];
    if (prefs.containsKey('favoritelist')) {
      encodedFavoriteList = prefs.getString('favoritelist');
      jsonDecode(encodedFavoriteList).forEach((data) => favoriteList.add(data));
    }

    for (int i = 0; i < postCards.length; i++) {
      if (favoriteList.contains(postCards[i].id)) {
        postCards[i].favorite = true;
      }
    }

    return postCards;
  }

  @override
  void onTransition(Transition<PostcardEvent, PostcardState> transition) {
    super.onTransition(transition);
    // print('Transisiton');
    // print(transition.currentState.status);
    // print(transition.nextState.status);
    // print(transition.event);
  }
}
