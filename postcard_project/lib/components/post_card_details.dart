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
              child: Image.network(
                postCard.imageUrl,
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
            const Text(
              'Title',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              postCard.title,
              style: const TextStyle(fontSize: 17),
            ),
            const Text(
              'Description',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              postCard.description,
              style: const TextStyle(fontSize: 17),
            ),
            const Text(
              'Date',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              postCard.date,
              style: const TextStyle(fontSize: 17),
            ),
            const Text(
              'Author',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              postCard.author,
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
