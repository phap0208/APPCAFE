import 'package:flutter/material.dart';
import 'package:giaydep_app/model/comment.dart';
import 'package:giaydep_app/model/post.dart';
import 'package:giaydep_app/view/customer/blogs/comments_screen.dart';
import 'package:giaydep_app/viewmodel/post_viewmodel.dart';

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  PostDetailsScreen({required this.post});

  @override
  State<StatefulWidget> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  void loadComments() async {
    List<Comment> loadedComments = await PostViewModel().getCommentsForPost(widget.post.id);
    setState(() {
      comments = loadedComments;
    });
  }

  void navigateToAddCommentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCommentScreen(postId: widget.post.id),
      ),
    ).then((_) {
      loadComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Bài Viết'),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: navigateToAddCommentScreen,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiêu đề: ${widget.post.title}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Hiển thị ảnh nếu có
            if (widget.post.image.isNotEmpty)
              Image.network(
                widget.post.image,
                height: 200, // Thiết lập chiều cao cho ảnh
                width: double.infinity, // Thiết lập chiều rộng cho ảnh
                fit: BoxFit.cover, // Thiết lập chế độ hiển thị ảnh
              ),
            // SizedBox(height: 10),
            // Text('Nội dung: ${widget.post.content}'),
            // SizedBox(height: 20),
            // Text(
            //   'Bình luận:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index].content),
                    subtitle: Text('Bởi: ${comments[index].authorName}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
