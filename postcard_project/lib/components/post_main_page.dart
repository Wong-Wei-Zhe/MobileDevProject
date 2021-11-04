import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/user_account_bloc/user_account_bloc.dart';

class PostMainPage extends StatefulWidget {
  const PostMainPage({Key? key}) : super(key: key);

  @override
  _PostMainPageState createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  late final userAccBloc;

  @override
  void initState() {
    userAccBloc = BlocProvider.of<UserAccountBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    userAccBloc.add(UserClosedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Yaaa'),
          ElevatedButton(
            onPressed: () {
              userAccBloc.add(UserSignInEvent());
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
