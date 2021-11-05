import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/postcard_bloc/postcard_bloc.dart';
import 'package:postcard_project/blocs/user_account_bloc/user_account_bloc.dart';
import 'package:postcard_project/components/create_post_page.dart';
import 'package:postcard_project/components/post_card_display.dart';

class PostMainPage extends StatefulWidget {
  const PostMainPage({Key? key}) : super(key: key);

  @override
  _PostMainPageState createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  late final UserAccountBloc userAccBloc;
  late final PostcardBloc postcardBloc;

  @override
  void initState() {
    userAccBloc = BlocProvider.of<UserAccountBloc>(context);
    postcardBloc = BlocProvider.of<PostcardBloc>(context);
    postcardBloc.initializeApiListen();
    super.initState();
  }

  @override
  void dispose() {
    //userAccBloc.add(UserClosedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Card Page'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    //userAccBloc.add(UserSignInEvent());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePostPage()));
                  },
                  child: const Text('Create Post'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //userAccBloc.add(UserSignInEvent());
                    postcardBloc.add(PostCardFetchEvent());
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),
            BlocBuilder<PostcardBloc, PostcardState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostFetchStatus.initial:
                    postcardBloc.add(PostCardFetchEvent());
                    return const CircularProgressIndicator();
                    break;
                  case PostFetchStatus.success:
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.postCards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PostCardDisplay(state.postCards[index]);
                        },
                      ),
                    );
                    break;
                  case PostFetchStatus.failure:
                    // TODO: Handle this case.
                    break;
                  case PostFetchStatus.nothingnew:
                    // TODO: Handle this case.
                    break;
                }
                return Text('data');
              },
            ),
          ],
        ),
      ),
    );
  }
}
