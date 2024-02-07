import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:talk/data/model/post_model.dart';
import 'package:talk/data/model/response_model.dart';
import 'package:talk/data/model/user_model.dart';
import 'package:talk/data/repository/post_repository.dart';
import 'package:talk/presentation/profile/screen/cubit/imageSelect/image_select_cubit.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  SlidingUpPanelController panelController = SlidingUpPanelController();

  AddPostCubit() : super(AddPostClosed());

  void openPanel() {
    panelController.expand();
    emit(AddPostOpened());
  }

  void closePanel() {
    panelController.collapse();
    emit(AddPostClosed());
  }

  Future<void> addPost({text, images}) async {
    emit(AddingPost());
    final UserModel user = UserModel.generateUserModelFromFirebaseUser(
        user: FirebaseAuth.instance.currentUser!);
    final PostDataRepository postDataRepository = PostDataRepository();
    PostModel post = PostModel(
      title: '${user.name}\'s post',
      body: text,
      caption: text,
      imageUrl: [],
      location: 'New York',
      user: user,
    );
    final imageUploadResponse = await postDataRepository.addImagesToBucket(
      images: images,
      userId: user.uid,
      postId: post.postId!,
    );

    if (!imageUploadResponse.status) {
      emit(PostAddingFailed(message: imageUploadResponse.message));
      return;
    }

    //modify the post model to include the image urls
    post = post.copyWith(
      imageUrl: [...imageUploadResponse.data],
    );

    // closePanel();
    final response = await postDataRepository.addPost(post: post);
    if (response.status) {
      emit(
        PostAdded(
          responseModel: ResponseModel(
            status: true,
            message: "Post added successfully",
          ),
        ),
      );
      closePanel();
    } else {
      emit(PostAddingFailed(message: response.message));
    }
  }

  void clearState() {
    emit(AddPostClosed());
  }
}
///
///  PostModel generateNewPost() {
//     final UserModel _user = UserModel.generateUserModelFromFirebaseUser(
//         user: FirebaseAuth.instance.currentUser!);
//     final post = PostModel(
//       title: 'New Post',
//       body: 'This is a new post',
//       caption: 'New Post',
//       imageUrl: 'https://www.google.com',
//       location: 'New York',
//       user: _user,
//     );
//     return post;
//   }
// }
///
