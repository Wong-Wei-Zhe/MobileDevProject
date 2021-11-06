import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/manage_post_bloc/manage_post_bloc.dart';
import 'package:postcard_project/models/postcard_model.dart';

class PostCardDisplay extends StatelessWidget {
  final PostCardModel postCard;
  const PostCardDisplay(this.postCard, {Key? key}) : super(key: key);

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
            //     child: Image.network(postCard.imageUrl)),
            Expanded(
              child: Column(
                children: <Widget>[
                  const Text('Title'),
                  Text(postCard.title),
                  const Text('Description'),
                  Text(postCard.description),
                  const Text('Date'),
                  Text(postCard.date),
                  const Text('Author'),
                  Text(postCard.author),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                const Text('Icon placeholer'),
                ElevatedButton(
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
                                        managePostBloc
                                            .add(DeletePostEvent(postCard.id)),
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
                                      onPressed: () => Navigator.pop(context),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
