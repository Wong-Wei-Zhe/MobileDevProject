class PostCardModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String author;
  final bool selfAuthor;

  PostCardModel(
      {this.id = 'NA',
      this.title = 'NA',
      this.description = 'NA',
      this.imageUrl = 'NA',
      this.date = 'NA',
      this.author = 'NA',
      this.selfAuthor = false});

  // String get id => _id;
  // String get title => _title;
  // String get description => _description;
  // String get imageUrl => _imageUrl;
  // String get date => _date;
  // String get author => _author;
}
