import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:talk/data/constants/collection_names.dart';
import 'package:talk/data/model/post_model.dart';
import 'package:talk/data/model/response_model.dart';

class PostDataRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future<ResponseModel> getPosts() async {
    const int limit = 10;

    // try {
    //   final response = await _firebaseFirestore
    //       .collection(postCollection)
    //       .limit(limit)
    //       .get();
    //   return ResponseModel(
    //     status: true,
    //     message: 'Posts fetched successfully',
    //     data: response.docs.map((e) => e.data()).toList(),
    //   );
    // } catch (e) {
    //   return ResponseModel(
    //     status: false,
    //     message: e.toString(),
    //   );
    // }
    try {
      final response = await _firebaseFirestore
          .collection(postCollection)
          .orderBy('date')
          .limit(limit)
          .get();

      return ResponseModel(
        status: true,
        message: 'Posts fetched successfully',
        data: response,
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: e.toString(),
      );
    }
  }

  Future<ResponseModel> getMorePosts({required lastDocument}) async {
    const int limit = 10;

    try {
      final response = await _firebaseFirestore
          .collection(postCollection)
          .orderBy('date')
          .limit(limit)
          .get();
      print(lastDocument);
      return ResponseModel(
          message: "More Posts Loaded Successfully",
          status: true,
          data: response);
    } catch (e) {
      return ResponseModel(message: e.toString(), status: false);
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
      final List<PostModel> postList = postsData
          .map((e) => PostModel.fromMap(
                e!,
              ))
          .toList();
      return ResponseModel(
        status: true,
        message: 'Posts fetched successfully',
        data: postList,
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
      final _post =
          _firebaseFirestore.collection(postCollection).doc(post.postId);
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
    //TODO: Implement the delete post method
    return ResponseModel(
      status: false,
      message: 'Not implemented',
    );
  }

  Future<ResponseModel> addImagesToBucket({
    required List<File> images,
    required String userId,
    required String postId,
  }) async {
    List<String> imageUrls = [];

    try {
      final storage = FirebaseStorage.instance;
      for (File image in images) {
        // Generate a unique file name for each image
        String imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${userId}_${postId}_${images.indexOf(image)}.jpg';

        // Upload the image to Firebase Storage
        UploadTask uploadTask = storage
            .ref('post_images/$userId/$postId/$imageName')
            .putFile(image);

        // Wait for the upload task to complete and get the download URL
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Add the download URL to the list
        imageUrls.add(downloadUrl);
      }

      // // Return the response with the list of download URLs
      return ResponseModel(
        status: true,
        message: 'Images uploaded successfully',
        data: imageUrls,
      );
    } catch (e) {
      // Return an error response if any exception occurs
      return ResponseModel(
        status: false,
        message: e.toString(),
      );
    }
  }
}
