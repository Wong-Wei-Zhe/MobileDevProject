import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/user_account_bloc/user_account_bloc.dart';
import 'package:postcard_project/components/post_main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameField = TextEditingController();
  late final UserAccountBloc userAccBloc;

  @override
  void initState() {
    userAccBloc = BlocProvider.of<UserAccountBloc>(context);
    userAccBloc.initializeApiListen();
    super.initState();
  }

  @override
  void dispose() {
    _userNameField.dispose();
    userAccBloc.add(UserClosedEvent());
    super.dispose();
  }

  void _snackBarCall(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar(
        reason: SnackBarClosedReason.remove,
      )
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _userNameField,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter your author name',
              labelText: 'Author Name',
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              userAccBloc.add(UserSignInEvent(_userNameField.text));
            },
            child: const Text('Sign In'),
          ),
          BlocListener<UserAccountBloc, UserAccountState>(
            listener: (context, state) {
              if (state is UserSignInProgressingState) {
                _snackBarCall('Loging In...');
              }
              if (state is UserSignInSuccessState) {
                _snackBarCall('Success!');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostMainPage(_userNameField.text)));
              }
              if (state is UserSignInFailedState) {
                _snackBarCall(state.toString());
              }
            },
            child: const SizedBox.shrink(),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     userAccBloc.add(UserClosedEvent());
          //   },
          //   child: const Text('Close'),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     ////////
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const PostMainPage()),
          //     );
          //     ////////////
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //       builder: (context)
          //     //           //return const PostMainPage();
          //     //           =>
          //     //           BlocProvider.value(
          //     //             value: BlocProvider.of<UserAccountBloc>(context),
          //     //             child: const PostMainPage(),
          //     //           )),
          //     // );
          //     ///////////
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) {
          //     //     return MultiBlocProvider(
          //     //       providers: [
          //     //         BlocProvider<UserAccountBloc>(
          //     //           create: (BuildContext context) => UserAccountBloc(
          //     //               RepositoryProvider.of<PostcardApiProvider>(
          //     //                   context)),
          //     //         ),
          //     //         // BlocProvider<BlocB>(
          //     //         //   create: (BuildContext context) => BlocB(),
          //     //         // ),
          //     //       ],
          //     //       child: const PostMainPage(),
          //     //     );
          //     //   }),
          //     // );
          //     ///////////
          //   },
          //   child: const Text('Navigate Test'),
          // ),
        ],
      ),
    );
  }
}
