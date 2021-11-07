part of 'postcard_bloc.dart';

abstract class PostcardEvent extends Equatable {
  const PostcardEvent();

  @override
  List<Object> get props => [];
}

class PostCardFetchEvent extends PostcardEvent {
  final PostFetchStatus status;
  final List<PostCardModel> postCards;
  final int removeIndex;
  const PostCardFetchEvent(
      {this.status = PostFetchStatus.initial,
      this.postCards = const <PostCardModel>[],
      this.removeIndex = 0});
}

class PostCardFetchSuccessEvent extends PostcardEvent {
  final List<PostCardModel> postCards;
  const PostCardFetchSuccessEvent(this.postCards);
}
