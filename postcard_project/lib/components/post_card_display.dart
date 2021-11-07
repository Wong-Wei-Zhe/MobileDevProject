import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/manage_post_bloc/manage_post_bloc.dart';
import 'package:postcard_project/models/postcard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCardDisplay extends StatefulWidget {
  final PostCardModel postCard;
  final String _userName;
  final int _index;
  const PostCardDisplay(this.postCard, this._userName, this._index, {Key? key})
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
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 1.0, bottom: 1.0),
      child: SizedBox(
        height: 220,
        child: Card(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.postCard.imageUrl,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return LayoutBuilder(builder: (context, constraint) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline_outlined,
                                  size: constraint.biggest.width * 0.4),
                              const FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  'Image Error',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        });
                      },
                    ),
                  )),
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                      child: Text(
                        widget.postCard.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                      child: Text(
                        widget.postCard.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                      child: Text(
                        widget.postCard.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        'Author',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 8.0),
                      child: Text(
                        widget.postCard.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.contain,
                      child: IconButton(
                        icon: const Icon(Icons.favorite),
                        color: widget.postCard.favorite
                            ? Colors.pink
                            : Colors.grey,
                        tooltip: 'Favorite',
                        onPressed: () {
                          _favoriteOnPress();
                        },
                      ),
                    ),
                    widget._userName == widget.postCard.author
                        ? FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                              icon: const Icon(Icons.delete_forever_outlined),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size(
                                                      double.infinity, 50),
                                                ),
                                                child: const Text(
                                                  'Confirm',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () => {
                                                  managePostBloc.add(
                                                    DeletePostEvent(
                                                        widget.postCard.id,
                                                        widget._index),
                                                  ),
                                                  Navigator.pop(context)
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size(
                                                      double.infinity, 50),
                                                ),
                                                child: const Text(
                                                  'Cancel',
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
