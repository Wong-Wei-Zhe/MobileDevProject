import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/manage_post_bloc/manage_post_bloc.dart';
import 'package:postcard_project/blocs/postcard_bloc/postcard_bloc.dart';
import 'package:postcard_project/blocs/user_account_bloc/user_account_bloc.dart';
import 'package:postcard_project/components/create_post_page.dart';
import 'package:postcard_project/components/post_card_details.dart';
import 'package:postcard_project/components/post_card_display.dart';

import 'about_page.dart';

class PostMainPage extends StatefulWidget {
  final String _userName;
  const PostMainPage(this._userName, {Key? key}) : super(key: key);

  @override
  _PostMainPageState createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  late final UserAccountBloc userAccBloc;
  late final PostcardBloc postcardBloc;
  late final ManagePostBloc _managePostBloc;

  @override
  void initState() {
    userAccBloc = BlocProvider.of<UserAccountBloc>(context);
    postcardBloc = BlocProvider.of<PostcardBloc>(context);
    _managePostBloc = BlocProvider.of<ManagePostBloc>(context);
    postcardBloc.logUserName(widget._userName);
    _managePostBloc.initializeApiListen();
    postcardBloc.initializeApiListen();
    super.initState();
  }

  @override
  void dispose() {
    //userAccBloc.add(UserClosedEvent());
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

  void _testEncode() {
    List<String> testData = ['22', '33', '44'];
    dynamic encodedStuff = jsonEncode(testData);
    dynamic decodedStuff = jsonDecode(encodedStuff);
    decodedStuff.forEach((data) => print(data));
    //print(decodedStuff);
  }

  void _testRemove() {
    print(postcardBloc.state.postCards[1].author);
    postcardBloc.state.postCards.removeAt(1);
    print(postcardBloc.state.postCards[1].author);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Card Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    widget._userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('My Post'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('About'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
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
                    print('ON BUTTON');
                    print(postcardBloc.state);
                    postcardBloc.add(PostCardFetchEvent());
                  },
                  child: const Text('Refresh'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _testRemove();
                  },
                  child: const Text('Remove Test'),
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
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostCardDetails(
                                          state.postCards[index])));
                            },
                            child: PostCardDisplay(
                                state.postCards[index], widget._userName),
                          );
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
            BlocListener<ManagePostBloc, ManagePostState>(
              listener: (context, state) {
                if (state is DeletePostSubmittingState) {
                  _snackBarCall('Deleting Postcard...');
                }
                if (state is DeletePostSucceedState) {
                  _snackBarCall('Deleted Successfully');
                }
                if (state is ManagePostFailedState) {
                  _snackBarCall(state.toString());
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
