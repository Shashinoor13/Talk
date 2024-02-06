import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk/data/constants/collection_names.dart';
import 'package:talk/data/model/post_model.dart';
import 'package:talk/data/model/response_model.dart';

class PostDataRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<ResponseModel> getPosts() async {
    try {
      final posts = await _firebaseFirestore.collection('post').get();
      final _posts =
          posts.docs.map((e) => PostModel.fromMap(e.data())).toList();
      return ResponseModel(
        status: true,
        message: 'Posts fetched successfully',
        data: _posts,
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseModel> getPostsByUser({required String userId}) async {
    try {
      final posts = await _firebaseFirestore
          .collection(userCollection)
          .doc(userId)
          .collection(postCollection)
          .get();
      final _posts = posts.docs.map((e) => e.data()).toList();
      //these are the document ids of the posts
      final postIds = _posts.map((e) => e['postId']).toList();
      final postsData = await Future.wait(
        postIds.map(
          (e) async {
            final post = await _firebaseFirestore
                .collection(postCollection)
                .doc(e)
                .get();
            return post.data();
          },
        ),
      );

      print(postsData);
      return ResponseModel(
        status: true,
        message: 'Posts fetched successfully',
        data: postsData,
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseModel> addPost({required PostModel post}) async {
    try {
      final _post = _firebaseFirestore.collection('post').doc(post.postId);
      await _post.set(post.toMap());
      await _firebaseFirestore
          .collection(userCollection)
          .doc(post.user.uid)
          .collection(postCollection)
          .doc(post.postId)
          .set({'postId': post.postId});
      return ResponseModel(
        status: true,
        message: 'Post added successfully',
        data: _post,
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseModel> deletePost({required PostModel post}) async {
    try {
      await _firebaseFirestore
          .collection('post')
          .doc(post.user.uid)
          .collection('posts')
          .doc(post.postId)
          .delete();
      await _firebaseFirestore
          .collection('users')
          .doc(post.user.uid)
          .collection('posts')
          .doc(post.postId)
          .delete();
      return ResponseModel(
        status: true,
        message: 'Post deleted successfully',
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: e.toString(),
      );
    }
  }
}
