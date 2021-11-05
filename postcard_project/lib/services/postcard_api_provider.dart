import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostcardApiProvider {
  final String _postCardAPI = 'ws://besquare-demo.herokuapp.com';
  //final String _postCardAPI = 'wss://ws.binaryws.com/websockets/v3?app_id=1089';
  late final _postCardWebSocket;
  final _postCardAPIController = BehaviorSubject<String>();

  PostcardApiProvider() {
    _postCardWebSocket = WebSocketChannel.connect(Uri.parse(_postCardAPI));
    _postCardWebSocket.stream.listen((message) {
      _postCardAPIController.add(message);
    });
  }

  void sendSignInRequest(String userNameStr) {
    _postCardWebSocket.sink
        .add('{"type": "sign_in", "data": {"name": "$userNameStr"}}');
  }

  void terminateAPIStream() {
    _postCardWebSocket.sink.close();
    _postCardAPIController.close();
  }

  dynamic get postCardAPIController => _postCardAPIController;
  //dynamic get postCardWebSocket => _postCardWebSocket;
}
