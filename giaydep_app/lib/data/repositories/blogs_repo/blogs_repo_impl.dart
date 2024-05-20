  import 'dart:io';
  
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:giaydep_app/model/comment.dart';
  import '../../../model/post.dart';
  import '../../../utils/common_func.dart';
  import 'blogs_repo.dart';
  
  class BlogsRepoImpl with BlogsRepo {
    @override
    Future<List<Post>> getAllPost() async {
      List<Post> posts = [];
      try {
        await FirebaseFirestore.instance.collection("POSTS").get().then((
            querySnapshot) {
          for (var result in querySnapshot.docs) {
            posts.add(Post.fromJson(result.data()));
          }
          print("post length:${posts.length}");
        });
        return posts;
      } catch (error) {
        print("error:${error.toString()}");
      }
      return [];
    }
  
    @override
    Future<bool> addPost({required Post post, required File? imageFile,bool isLiked = false}) async {
      //Add image storage
      if (imageFile != null) {
        // Create a storage reference from our app
        final storageRef = FirebaseStorage.instance.ref();
  
        try {
          var snapshot = await storageRef.child('post_images/${post.id}.jpg')
              .putFile(imageFile);
          var downloadUrl = await snapshot.ref.getDownloadURL();
  
          //Assign image path for post
          post.image = downloadUrl;
  
          //Add to firestore
          Map<String, dynamic> postMap = {
            "id": post.id,
            "title": post.title,
            "image": post.image,
            "author_name": post.authorName,
            "author_email": post.authorEmail,
            "content": post.content,
            "number_like": post.numberLike,
            "create_date": post.createDate,
            "update_date": post.updateDate,
            "isLike" : post.isLiked,
          };
  
          FirebaseFirestore.instance.collection('POSTS').doc(post.id).set(
              postMap);
  
          return Future.value(true);
        } on FirebaseException catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        } catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        }
      } else {
        try {
          //Add post without image
          Map<String, dynamic> postMap = {
            "id": post.id,
            "title": post.title,
            "image": post.image,
            "author_name": post.authorName,
            "author_email": post.authorEmail,
            "content": post.content,
            "number_like": post.numberLike,
            "create_date": post.createDate,
            "update_date": post.updateDate,
          };
  
          FirebaseFirestore.instance.collection('POSTS').doc(post.id).set(postMap)
            ..then((value) {}).catchError((error) {
              CommonFunc.showToast("Lỗi thêm bài viết.");
              print("error:${error.toString()}");
              return Future.value(false);
            });
          return Future.value(true);
        } on FirebaseException catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        } catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        }
      }
      return Future.value(false);
    }
  
    @override
    Future<bool> updatePost(
        {required Post post, required File? imageFile}) async {
      //Add image storage
      if (imageFile != null) {
        // Create a storage reference from our app
        final storageRef = FirebaseStorage.instance.ref();
  
        try {
          var snapshot = await storageRef.child('post_images/${post.id}.jpg')
              .putFile(imageFile);
          var downloadUrl = await snapshot.ref.getDownloadURL();
  
          //Assign image path for product
          post.image = downloadUrl;
  
          //Add to firestore
          Map<String, dynamic> postMap = {
            "id": post.id,
            "title": post.title,
            "image": post.image,
            "author_name": post.authorName,
            "author_email": post.authorEmail,
            "content": post.content,
            "number_like": post.numberLike,
            "create_date": post.createDate,
            "update_date": post.updateDate,
          };
  
          FirebaseFirestore.instance.collection('POSTS').doc(post.id).update(
              postMap);
  
          return Future.value(true);
        } on FirebaseException catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        } catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        }
      } else {
        try {
          //Update post without image
          Map<String, dynamic> postMap = {
            "id": post.id,
            "title": post.title,
            "image": post.image,
            "author_name": post.authorName,
            "author_email": post.authorEmail,
            "content": post.content,
            "number_like": post.numberLike,
            "create_date": post.createDate,
            "update_date": post.updateDate,
          };
  
          FirebaseFirestore.instance.collection('POSTS').doc(post.id).update(
              postMap);
          return Future.value(true);
        } on FirebaseException catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        } catch (e) {
          CommonFunc.showToast("Đã có lỗi xảy ra.");
        }
      }
      return Future.value(false);
    }
  
    @override
    Future<bool> deletePost({required String postId}) async {
      try {
        try {
          //delete image
          final storageRef = FirebaseStorage.instance.ref();
          await storageRef.child('post_images/${postId}.jpg').delete();
        } on FirebaseException catch (e) {
          print("code:${e.code},data:${e.message}");
          if (e.code == "object-not-found") {
            //delete product
            FirebaseFirestore.instance.collection('POSTS').doc(postId).delete();
            return Future.value(true);
          }
        }
        //delete product
        FirebaseFirestore.instance.collection('POSTS').doc(postId).delete();
        return Future.value(true);
      } on FirebaseException catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra.");
        print("error:${e.toString()}");
      } catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra.");
      }
      return Future.value(false);
    }
  
    @override
    Future<bool> addComment(
        {required String postId, required Comment comment}) async {
      try {
        Map<String, dynamic> commentMap = {
          "id": comment.id,
          "postId": postId,
          "content": comment.content,
          "authorName": comment.authorName,
          "createDate": comment.createDate,
        };
  
        await FirebaseFirestore.instance.collection('COMMENTS').add(commentMap);
        return Future.value(true);
      } catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra khi thêm bình luận.");
        print("error:${e.toString()}");
        return Future.value(false);
      }
    }
  
    @override
    Future<bool> updateLikeCount(
        {required String postId, required int newLikeCount}) async {
      try {
        await FirebaseFirestore.instance.collection('POSTS').doc(postId).update({
          "number_like": newLikeCount,
        });
        return Future.value(true);
      } catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra khi cập nhật số lượng thích.");
        print("error:${e.toString()}");
        return Future.value(false);
      }
    }
  
    @override
    Future<bool> likePost({required String postId}) async {
      try {
        // Lấy thông tin bài viết từ Firestore
        DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
            .collection('POSTS').doc(postId).get();
  
        // Lấy số lượt thích hiện tại
        Map<String, dynamic> postData = postSnapshot.data() as Map<String,
            dynamic>; // Chuyển đổi sang Map<String, dynamic>
        int currentLikes = postData['number_like'] ??
            0; // Truy cập phần tử 'number_like'
  
        // Tăng số lượt thích lên 1
        int newLikes = currentLikes + 1;
  
        // Cập nhật số lượt thích mới vào Firestore
        await FirebaseFirestore.instance.collection('POSTS').doc(postId).update(
            {'number_like': newLikes});
  
        return true;
      } catch (e) {
        print("Error liking post: $e");
        return false;
      }
    }

  @override
  Future<List<Comment>> getCommentsForPost(String postId) async {
    List<Comment> comments = [];
    try {
      await FirebaseFirestore.instance.collection("COMMENTS")
          .where("postId", isEqualTo: postId)
          .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          comments.add(Comment.fromJson(result.data()));
        }
      });
      return comments;
    } catch (error) {
      print("Error getting comments: $error");
      return [];
    }
  }
  }

  
