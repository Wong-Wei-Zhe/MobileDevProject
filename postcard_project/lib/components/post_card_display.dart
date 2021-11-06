import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/manage_post_bloc/manage_post_bloc.dart';
import 'package:postcard_project/models/postcard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCardDisplay extends StatefulWidget {
  final PostCardModel postCard;
  final String _userName;
  const PostCardDisplay(this.postCard, this._userName, {Key? key})
      : super(key: key);

  @override
  State<PostCardDisplay> createState() => _PostCardDisplayState();
}

class _PostCardDisplayState extends State<PostCardDisplay> {
  void _favoriteOnPress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = [];
    if (prefs.containsKey('favoritelist')) {
      dynamic encodedFavoriteList = prefs.getString('favoritelist');
      jsonDecode(encodedFavoriteList).forEach((data) => favoriteList.add(data));

      if (favoriteList.contains(widget.postCard.id)) {
        favoriteList.removeWhere((element) => element == widget.postCard.id);
        setState(() {
          widget.postCard.favorite = false;
        });
      } else {
        favoriteList.add(widget.postCard.id);
        setState(() {
          widget.postCard.favorite = true;
        });
      }
    } else {
      favoriteList.add(widget.postCard.id);
      setState(() {
        widget.postCard.favorite = true;
      });
    }

    dynamic encodedData = jsonEncode(favoriteList);
    prefs.setString('favoritelist', encodedData);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            // SizedBox(
            //     height: 200,
            //     width: 200,
            //     child: Image.network(widget.postCard.imageUrl)),
            Expanded(
              child: Column(
                children: <Widget>[
                  const Text('Title'),
                  Text(widget.postCard.title),
                  const Text('Description'),
                  Text(widget.postCard.description),
                  const Text('Date'),
                  Text(widget.postCard.date),
                  const Text('Author'),
                  Text(widget.postCard.author),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: widget.postCard.favorite ? Colors.pink : Colors.grey,
                  tooltip: 'Favorite',
                  onPressed: () {
                    _favoriteOnPress();
                  },
                ),
                widget._userName == widget.postCard.author
                    ? ElevatedButton(
                        onPressed: () {
                          final managePostBloc =
                              BlocProvider.of<ManagePostBloc>(context);
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 150,
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size(double.infinity, 60),
                                          ),
                                          child: const Text(
                                            'Confirm',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          onPressed: () => {
                                            managePostBloc.add(DeletePostEvent(
                                                widget.postCard.id)),
                                            Navigator.pop(context)
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size(double.infinity, 60),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Delete'))
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
