import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giaydep_app/model/comment.dart';
import 'package:giaydep_app/utils/common_func.dart';
import 'package:giaydep_app/viewmodel/post_viewmodel.dart';

class AddCommentScreen extends StatefulWidget {
  final String postId;

  AddCommentScreen({required this.postId});

  @override
  State<StatefulWidget> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Bình Luận'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: commentController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Nội dung bình luận',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (commentController.text.trim().isEmpty) {
                  // Kiểm tra xem nội dung bình luận có rỗng không
                  // Hiển thị thông báo nếu rỗng
                  CommonFunc.showToast('Vui lòng nhập nội dung bình luận.');
                } else {
                  // Lấy thông tin về người dùng đã đăng nhập từ Firebase Authentication
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Lấy tên hiển thị của người dùng
                    String authorName = user.displayName ?? 'qb6996';

                    // Tạo đối tượng Comment từ tên người dùng và nội dung nhập vào
                    Comment newComment = Comment(
                      id: '',
                      postId: widget.postId,
                      content: commentController.text.trim(),
                      authorName: authorName,
                      createDate: DateTime.now(),
                    );

                    // Gọi phương thức addComment từ PostViewModel để thêm bình luận
                    await PostViewModel().addComment(comment: newComment);

                    // Đóng màn hình thêm bình luận khi gửi thành công
                    Navigator.pop(context);
                  } else {
                    // Hiển thị thông báo nếu người dùng chưa đăng nhập
                    CommonFunc.showToast('Vui lòng đăng nhập để thêm bình luận.');
                  }
                }
              },
              child: Text('Gửi Bình Luận'),
            ),
          ],
        ),
      ),
    );
  }
}
