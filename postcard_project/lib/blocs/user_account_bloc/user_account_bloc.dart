import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';
part 'user_account_event.dart';
part 'user_account_state.dart';

///This is a Bloc that handle user log in procress
///To detect successfuly or failed log in
class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  PostcardApiProvider postCardApi;
  UserAccountBloc(this.postCardApi) : super(UserAccountInitial()) {
    on<UserSignInEvent>(_userSignInEvent);
    on<UserClosedEvent>(_userClosedEvent);
    on<UserSignInSuccessEvent>(_userSignInSuccessEvent);
    on<UserSignInFailedEvent>(_userSignInFailedEvent);
  }

  ///API listener to handle general response related to user login service
  void initializeApiListen() {
    try {
      postCardApi.postCardAPIController.listen((message) {
        final decodedMessage = jsonDecode(message);

        if (decodedMessage["type"] == 'sign_in') {
          if (decodedMessage["data"]["response"] == 'OK') {
            add(UserSignInSuccessEvent(decodedMessage["data"]["response"]));
          } else {
            add(UserSignInFailedEvent(decodedMessage["errors"].cast<String>()));
          }
        }

        if (decodedMessage["type"] == 'error') {
          add(UserSignInFailedEvent(decodedMessage["errors"].cast<String>()));
        }
      });
    } catch (e) {
      add(UserSignInFailedEvent(const ['Login Error Detected']));
    }
  }

  void _userSignInEvent(UserSignInEvent event, Emitter<UserAccountState> emit) {
    postCardApi.sendSignInRequest(event.userNameStr);
    emit(UserSignInProgressingState());
  }

  void _userSignInSuccessEvent(
      UserSignInSuccessEvent event, Emitter<UserAccountState> emit) {
    emit(UserSignInSuccessState(event.response));
  }

  void _userSignInFailedEvent(
      UserSignInFailedEvent event, Emitter<UserAccountState> emit) {
    emit(UserSignInFailedState(event.errors));
  }

  void _userClosedEvent(
      UserAccountEvent event, Emitter<UserAccountState> emit) {
    postCardApi.terminateAPIStream();
  }
}
