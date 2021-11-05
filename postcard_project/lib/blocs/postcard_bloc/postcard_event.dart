part of 'postcard_bloc.dart';

abstract class PostcardEvent extends Equatable {
  const PostcardEvent();

  @override
  List<Object> get props => [];
}

class PostCardFetchEvent extends PostcardEvent {}

class PostCardFetchSuccessEvent extends PostcardEvent {
  final List<PostCardModel> postCards;
  const PostCardFetchSuccessEvent(this.postCards);
}
