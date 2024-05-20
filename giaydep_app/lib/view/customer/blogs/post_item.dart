import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giaydep_app/model/post.dart';
import 'package:giaydep_app/model/roles_type.dart';
import 'package:giaydep_app/utils/image_path.dart';
import 'package:giaydep_app/view/customer/blogs/post_details_screen.dart';
import 'package:giaydep_app/view/customer/blogs/edit_post_screen.dart';
import 'package:giaydep_app/viewmodel/auth_viewmodel.dart';
import 'package:giaydep_app/viewmodel/post_viewmodel.dart';
import 'package:giaydep_app/utils/common_func.dart';

class PostItem extends StatefulWidget {
  final Post post;

  PostItem({required this.post});

  @override
  State<StatefulWidget> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PostViewModel postViewModel = PostViewModel();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void goToPostDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsScreen(post: widget.post)),
    );
  }

  void goToEditPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPostScreen(post: widget.post)),
    );
  }

  void showDialogConfirmDeletePost() {
    Widget noButton = TextButton(
      child: Text("Không"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text("Có"),
      onPressed: () {
        postViewModel.deletePost(postId: widget.post.id);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("Bạn có chắc muốn xóa bài viết này?", textAlign: TextAlign.center),
      actions: [
        noButton,
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = 800; // Kích thước chiều rộng mong muốn cho ảnh
    double imageHeight = 300; // Kích thước chiều cao mong muốn cho ảnh

    return InkWell(
      onTap: goToPostDetailsScreen,
      child: Card(
        margin: const EdgeInsets.only(top: 8),
        color: Colors.white,
        elevation: 16,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x0D000000), width: 1),
          borderRadius: BorderRadius.circular(0),
        ),
        shadowColor: const Color(0x33333333),
        child: Container(
          width: 120,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white10,
                spreadRadius: 0,
                blurRadius: 12.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(ImagePath.imgLogo),
                        radius: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.authorName,
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.post.createDate,
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  if (postViewModel.currentUser?.email == widget.post.authorEmail)
                    SizedBox(
                      width: 48,
                      child: TextButton(
                        onPressed: goToEditPostScreen,
                        child: const Text(
                          "Sửa",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  if ((currentUser?.email == widget.post.authorEmail) ||
                      (AuthViewModel().rolesType == RolesType.admin))
                    SizedBox(
                      width: 48,
                      child: TextButton(
                        onPressed: showDialogConfirmDeletePost,
                        child: const Text(
                          "Xóa",
                          style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.post.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.post.image.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(
                    widget.post.image,
                    width: imageWidth,
                    height: imageHeight,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // Kiểm tra nếu bài viết đã được thích trước đó
                          if (widget.post.isLiked) {
                            // Nếu đã thích, giảm đi một lượt thích và đặt trạng thái của bài viết thành chưa thích
                            widget.post.numberLike -= 1;
                            widget.post.isLiked = false;
                          } else {
                            // Nếu chưa thích, tăng thêm một lượt thích và đặt trạng thái của bài viết thành đã thích
                            widget.post.numberLike += 1;
                            widget.post.isLiked = true;
                          }
                        });
                        // Gọi phương thức likePost để cập nhật dữ liệu trên server
                        postViewModel.likePost(postId: widget.post.id, newLikeCount: widget.post.numberLike);
                      },
                      child: Image.asset(
                        widget.post.isLiked ? ImagePath.imgHeartSelected : ImagePath.imgHeartUnselect,
                        width: 18,
                        height: 18,
                      ),
                    ),

                    Text("${widget.post.numberLike}")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
