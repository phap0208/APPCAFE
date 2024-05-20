
import 'dart:io';

import 'package:giaydep_app/model/comment.dart';

import '../../../model/post.dart';

abstract class BlogsRepo {
  Future<List<Post>> getAllPost();
  Future<bool> addPost({required Post post, required File? imageFile, bool isLiked = false});
  Future<bool> updatePost({required Post post, required File? imageFile});
  Future<bool> deletePost({required String postId});
  Future<bool> addComment({required String postId, required Comment comment});
  Future<bool> updateLikeCount({required String postId, required int newLikeCount});
  Future<bool> likePost({required String postId});
  Future<List<Comment>> getCommentsForPost(String postId);
}