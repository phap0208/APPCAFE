class Post {
  String id = '';
  String title = '';
  String image = '';
  String authorName = '';
  String authorEmail = '';
  String content = '';
  int numberLike = 0;
  String createDate = '';
  String updateDate = '';
  bool isLiked = false; // Add this property

  Post({
    required this.id,
    required this.title,
    required this.image,
    required this.authorName,
    required this.authorEmail,
    required this.content,
    required this.numberLike,
    required this.createDate,
    required this.updateDate,
    required this.isLiked, // Initialize the property in the constructor
  });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    authorName = json['author_name'];
    authorEmail = json['author_email'];
    content = json['content'];
    numberLike = json['number_like'];
    createDate = json['create_date'];
    updateDate = json['update_date'];
    isLiked = false; // Initialize isLiked to false when parsing from JSON
  }
}
