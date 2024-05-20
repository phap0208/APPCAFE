class Comment {
  final String id;
  final String postId;
  final String content;
  final String authorName;
  final DateTime createDate;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorName,
    required this.createDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      content: json['content'],
      authorName: json['authorName'],
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'authorName': authorName,
      'createDate': createDate.toIso8601String(),
    };
  }
}
