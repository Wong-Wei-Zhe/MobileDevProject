import 'package:flutter/material.dart';
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
            SizedBox(
                height: 200,
                width: 200,
                child: Image.network(postCard.imageUrl)),
            Expanded(
              child: Column(
                children: <Widget>[
                  const Text('Title'),
                  Text(postCard.title),
                  const Text('Description'),
                  Text(postCard.description),
                  const Text('Date'),
                  Text(postCard.date),
                ],
              ),
            ),
            const Text('Icon placeholer'),
          ],
        ),
      ),
    );
  }
}
