import 'package:flutter/material.dart';
import 'package:postcard_project/models/postcard_model.dart';

class PostCardDetails extends StatelessWidget {
  final PostCardModel postCard;
  const PostCardDetails(this.postCard, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postcard Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Image.network(postCard.imageUrl),
            ),
            const Text('Title'),
            Text(postCard.title),
            const Text('Description'),
            Text(postCard.description),
            const Text('Date'),
            Text(postCard.date),
            const Text('Date author'),
            Text(postCard.author),
          ],
        ),
      ),
    );
  }
}
