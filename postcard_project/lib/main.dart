import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/postcard_bloc/postcard_bloc.dart';
import 'package:postcard_project/blocs/user_account_bloc/user_account_bloc.dart';
import 'package:postcard_project/components/login_page.dart';
import 'package:postcard_project/services/postcard_api_provider.dart';

import 'blocs/manage_post_bloc/manage_post_bloc.dart';

void main() {
  Bloc.observer = BlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => PostcardApiProvider(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UserAccountBloc>(
              create: (BuildContext context) => UserAccountBloc(
                  RepositoryProvider.of<PostcardApiProvider>(context)),
            ),
            BlocProvider<PostcardBloc>(
              create: (BuildContext context) => PostcardBloc(
                  RepositoryProvider.of<PostcardApiProvider>(context)),
            ),
            BlocProvider<ManagePostBloc>(
              create: (BuildContext context) => ManagePostBloc(
                  RepositoryProvider.of<PostcardApiProvider>(context)),
            ),
          ],
          child: MaterialApp(
              title: 'PostCard App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const LoginPage()),
        ));
  }
}
