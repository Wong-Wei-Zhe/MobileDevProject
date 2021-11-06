part of 'postcard_bloc.dart';

enum PostFetchStatus { initial, success, failure, nothingnew }

class PostcardState extends Equatable {
  final PostFetchStatus status;
  final List<PostCardModel> postCards;

  const PostcardState(
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

// class PostcardFetchState extends PostcardState {
//   final PostFetchStatus status;
//   final List<PostCardModel> postCards;

//   const PostcardFetchState(
//       {this.status = PostFetchStatus.initial,
//       this.postCards = const <PostCardModel>[]});

//   PostcardFetchState copyObj(
//       {PostFetchStatus? status, List<PostCardModel>? postCards}) {
//     return PostcardFetchState(
//         status: status ?? this.status, postCards: postCards ?? this.postCards);
//   }

//   @override
//   String toString() {
//     return 'PostState { status: $status, posts: ${postCards.length} }';
//   }
// }
