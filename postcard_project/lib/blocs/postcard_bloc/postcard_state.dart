part of 'postcard_bloc.dart';

enum PostFetchStatus {
  initial,
  success,
  failure,
  nothingnew,
  removeat,
  refresh,
  favorite,
  ownpost,
}

class PostcardState extends Equatable {
  PostFetchStatus status;
  List<PostCardModel> postCards;

  PostcardState(
      {this.status = PostFetchStatus.initial,
      this.postCards = const <PostCardModel>[]});

  PostcardState copyWith(
      {PostFetchStatus? status, List<PostCardModel>? postCards}) {
    return PostcardState(
        status: status ?? this.status, postCards: postCards ?? this.postCards);
  }

  @override
  String toString() {
    return 'PostState { status: $status, posts: ${postCards.length} }';
  }

  @override
  List<Object> get props => [status, postCards];
}

class PostcardInitial extends PostcardState {}
