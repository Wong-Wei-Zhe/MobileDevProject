import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';
part 'user_account_event.dart';
part 'user_account_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  PostcardApiProvider postCardApi;
  UserAccountBloc(this.postCardApi) : super(UserAccountInitial()) {
    on<UserSignInEvent>(_userSignInEvent);
    on<UserClosedEvent>(_userClosedEvent);
  }

  void initializeApiListen() {
    postCardApi.postCardAPIController.listen((message) {
      print(message);
    });
  }

  void _userSignInEvent(
      UserAccountEvent event, Emitter<UserAccountState> emit) {
    postCardApi.sendSignInRequest();
    emit(UserAccountInitial());
  }

  void _userClosedEvent(
      UserAccountEvent event, Emitter<UserAccountState> emit) {
    postCardApi.terminateAPIStream();
  }
}
