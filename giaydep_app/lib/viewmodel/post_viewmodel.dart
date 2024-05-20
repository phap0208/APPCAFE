import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:giaydep_app/model/comment.dart';
import 'package:rxdart/rxdart.dart';
import '../base/baseviewmodel/base_viewmodel.dart';
import '../data/repositories/blogs_repo/blogs_repo.dart';
import '../data/repositories/blogs_repo/blogs_repo_impl.dart';
import '../model/post.dart';
import '../model/status.dart';
import '../utils/common_func.dart';
import 'notification_viewmodel.dart';

class PostViewModel extends BaseViewModel {
  static final PostViewModel _instance = PostViewModel._internal();

  factory PostViewModel() {
    return _instance;
  }

  PostViewModel._internal();

  BlogsRepo blogsRepo = BlogsRepoImpl();

  List<Post> posts = [];

  List<Post> myPosts = [];

  final StreamController<Status> getBlogsController = BehaviorSubject<Status>();

  Stream<Status> get getBlossStream => getBlogsController.stream;

  User? currentUser;

  @override
  FutureOr<void> init() {
    //Khoi tao nguoi dung hien tai
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> getAllPost() async {
    posts.clear();
    getBlogsController.sink.add(Status.loading);
    EasyLoading.show();
    await blogsRepo.getAllPost().then((value) {
      if (value.isNotEmpty) {
        posts = value;
        getMyPosts(posts);
        notifyListeners();
        getBlogsController.sink.add(Status.completed);
      }
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      getBlogsController.sink.add(Status.error);
      EasyLoading.dismiss();
    });
  }

  void getMyPosts(List<Post> posts) {
    currentUser = FirebaseAuth.instance.currentUser;
    myPosts.clear();
    for (int index = 0; index < posts.length; index++) {
      if (posts[index].authorEmail == currentUser?.email) {
        myPosts.add(posts[index]);
      }
    }
  }

  Future<void> likePost({required String postId, required int newLikeCount}) async {
    try {
      await blogsRepo.updateLikeCount(postId: postId, newLikeCount: newLikeCount);
    } catch (e) {
      print("Error liking post: $e");
    }
  }



  Future<void> addPost({required Post post, required File? imageFile, bool isLiked = false}) async {
    await blogsRepo.addPost(post: post, imageFile: imageFile, isLiked: isLiked).then((value) async {
      if (value == true) {
        CommonFunc.showToast("Thêm bài viết thành công.");
        await getAllPost();
        NotificationViewModel().newPostNotification();
      }
    }).onError((error, stackTrace) {
      print("add fail");
    });
  }
  Future<void> addComment({required Comment comment}) async {
    // Gửi yêu cầu thêm bình luận đến repository
    await blogsRepo.addComment(comment: comment, postId: '').then((value) async {
      if (value == true) {
        CommonFunc.showToast("Thêm bình luận thành công.");
        // Cập nhật lại danh sách bài viết sau khi thêm bình luận
        await getAllPost();
      }
    }).onError((error, stackTrace) {
      print("add comment fail");
    });
  }
  Future<List<Comment>> getCommentsForPost(String postId) async {
    try {
      // Gọi phương thức từ repository để lấy danh sách bình luận
      List<Comment> comments = await blogsRepo.getCommentsForPost(postId);
      return comments;
    } catch (error) {
      print("Error getting comments for post: $error");
      return [];
    }
  }

  Future<void> updatePost({required Post post, required File? imageFile}) async {
    await blogsRepo.updatePost(post: post, imageFile: imageFile).then((value) async {
      if (value == true) {
        CommonFunc.showToast("Cập nhật thành công.");
        await getAllPost();
      }
    }).onError((error, stackTrace) {
      print("update fail");
    });
  }

  Future<void> deletePost({required String postId}) async {
    blogsRepo.deletePost(postId: postId).then((value) async {
      if (value == true) {
        CommonFunc.showToast("Xóa thành công.");
        //reload product
        await getAllPost();
      }
    }).onError((error, stackTrace) {
      print("delete fail");
    });
  }
}
