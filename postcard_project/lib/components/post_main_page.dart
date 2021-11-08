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

///This is the main page that display the list of postcards
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
  String _selectedFilterValue = "All";

  @override
  void initState() {
    userAccBloc = BlocProvider.of<UserAccountBloc>(context);
    postcardBloc = BlocProvider.of<PostcardBloc>(context);
    _managePostBloc = BlocProvider.of<ManagePostBloc>(context);
    postcardBloc.logUserName(widget._userName);
    _managePostBloc.initializeApiListen();
    //postcardBloc.initializeApiListen();
    super.initState();
  }

  @override
  void dispose() {
    //Placeholder, resource cleanup when login widget terminate
    //userAccBloc.add(UserClosedEvent());
    super.dispose();
  }

  ///Reusable Snackbar, mainly used for Postcard management feedback.
  void _snackBarCall(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar(
        reason: SnackBarClosedReason.remove,
      )
      ..showSnackBar(snackBar);
  }

  List<DropdownMenuItem<String>> get _dropdownFilterItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text('All'), value: 'All'),
      const DropdownMenuItem(child: Text('Favorite'), value: 'Favorite'),
      const DropdownMenuItem(child: Text('My Post'), value: 'My Post'),
    ];
    return menuItems;
  }

  ///Keep track of dropdown menu selection and run its corresponding
  ///state call to update list for all, refreash, favorite and own post
  void _filterOptionChanged(String filterValue) {
    if (filterValue == 'All') {
      postcardBloc
          .add(const PostCardFetchEvent(status: PostFetchStatus.refresh));
    } else if (filterValue == 'Favorite') {
      postcardBloc.add(PostCardFetchEvent(
          status: PostFetchStatus.favorite,
          postCards: postcardBloc.state.postCards));
    } else {
      postcardBloc.add(PostCardFetchEvent(
          status: PostFetchStatus.ownpost,
          postCards: postcardBloc.state.postCards));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostCards'),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    widget._userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
              onTap: () {
                setState(() {
                  _selectedFilterValue = 'My Post';
                });
                _filterOptionChanged('My Post');
                Navigator.pop(context);
              },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 8,
                        direction: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                bool createPostResult = false;
                                createPostResult = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreatePostPage())) ??
                                    false;

                                if (createPostResult) {
                                  setState(() {
                                    _selectedFilterValue = 'All';
                                  });
                                  _filterOptionChanged('All');
                                }
                              },
                              child: const Text('Create Post'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded),
                            onPressed: () {
                              setState(() {
                                _selectedFilterValue = 'All';
                              });
                              _filterOptionChanged('All');
                            },
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 8,
                        direction: Axis.horizontal,
                        children: [
                          const Text(
                            'Filter:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: SizedBox(
                                width: 85,
                                height: 50,
                                child: DropdownButtonFormField(
                                    value: _selectedFilterValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedFilterValue = newValue!;
                                      });
                                      _filterOptionChanged(newValue!);
                                    },
                                    items: _dropdownFilterItems),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            BlocBuilder<PostcardBloc, PostcardState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostFetchStatus.initial:
                    postcardBloc.add(const PostCardFetchEvent());
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator(),
                    ));
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
                            child: PostCardDisplay(state.postCards[index],
                                widget._userName, index),
                          );
                        },
                      ),
                    );
                    break;
                  case PostFetchStatus.failure:
                    // PlaceHolder for pagination feature
                    break;
                  case PostFetchStatus.nothingnew:
                    // PlaceHolder for pagination feature
                    break;
                  case PostFetchStatus.removeat:
                    // PlaceHolder for pagination feature
                    break;
                  case PostFetchStatus.refresh:
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator(),
                    ));
                    break;
                  case PostFetchStatus.favorite:
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.postCards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return state.postCards[index].favorite
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostCardDetails(
                                                    state.postCards[index])));
                                  },
                                  child: PostCardDisplay(state.postCards[index],
                                      widget._userName, index),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    );
                    break;
                  case PostFetchStatus.ownpost:
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.postCards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return state.postCards[index].selfAuthor
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostCardDetails(
                                                    state.postCards[index])));
                                  },
                                  child: PostCardDisplay(state.postCards[index],
                                      widget._userName, index),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    );
                    break;
                }
                return const Text('');
              },
            ),
            BlocListener<ManagePostBloc, ManagePostState>(
              //BlocListener for delete postcard feedback
              listener: (context, state) {
                if (state is DeletePostSubmittingState) {
                  _snackBarCall('Deleting Postcard...');
                }
                if (state is DeletePostSucceedState) {
                  _snackBarCall('Deleted Successfully');
                  postcardBloc.add(PostCardFetchEvent(
                      status: PostFetchStatus.removeat,
                      postCards: postcardBloc.state.postCards,
                      removeIndex: _managePostBloc.lastDeletedIndex,
                      deleteAtStatus: postcardBloc.state.status));
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
