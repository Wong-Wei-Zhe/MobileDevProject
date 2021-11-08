import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostcardApiProvider {
  final String _postCardAPI = 'ws://besquare-demo.herokuapp.com';
  late final _postCardWebSocket;
  final _postCardAPIController = BehaviorSubject<String>();

  PostcardApiProvider() {
    _postCardWebSocket = WebSocketChannel.connect(Uri.parse(_postCardAPI));
    _postCardWebSocket.stream.listen((message) {
      _postCardAPIController.add(message);
    });
  }

  ///API Call for User Sign In Request
  void sendSignInRequest(String userNameStr) {
    _postCardWebSocket.sink
        .add('{"type": "sign_in", "data": {"name": "$userNameStr"}}');
  }

  ///API Call for Get Postcards Request
  void sendGetPostcardRequest(
      {String lastId = '', String sortBy = 'date', int limit = 10}) {
    _postCardWebSocket.sink.add(
        '{"type": "get_posts", "data": {"lastId": "$lastId", "sortBy": "$sortBy"}}');
    // _postCardWebSocket.sink.add(
    //     '{"type": "get_posts", "data": {"lastId": "$lastId", "sortBy": "$sortBy", "limit": $limit}}');
  }

  ///API Call for Create New Postcard Request
  void sendCreatePostRequest(String title, String description, String imagUrl) {
    _postCardWebSocket.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$imagUrl"}}');
  }

  ///API Call for Delete Postcard Request
  void sendDeletePostRequest(String postId) {
    _postCardWebSocket.sink
        .add('{"type": "delete_post", "data": {"postId": "$postId"}}');
  }

  ///Clean up API and stream
  void terminateAPIStream() {
    _postCardWebSocket.sink.close();
    _postCardAPIController.close();
  }

  dynamic get postCardAPIController => _postCardAPIController;
}
