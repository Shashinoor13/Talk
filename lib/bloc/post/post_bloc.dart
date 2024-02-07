import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talk/data/model/post_model.dart';
import 'package:talk/data/model/response_model.dart';
import 'package:talk/data/repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostDataRepository _postRepository = PostDataRepository();
  final lastDocument = [];
  PostBloc() : super(PostInitial()) {
    on<PostEvent>(
      (event, emit) async {
        if (event is PostCreate) {
          emit(PostLoading());
          final response = await _postRepository.addPost(post: event.postModel);
          if (response.status) {
            emit(PostSuccess(responseModel: response));
          } else {
            emit(PostFailure(message: response.message));
          }
        }
        if (event is GetUserPosts) {
          emit(PostLoading());
          final response =
              await _postRepository.getPostsByUser(userId: event.userId);
          if (response.status) {
            emit(PostsLoaded(
              posts: response.data,
            ));
          } else {
            emit(PostLoadingFailure(message: response.message));
          }
        }
        if (event is GetInitialPosts) {
          emit(PostLoading());
          final response = await _postRepository.getPosts();
          if (response.status) {
            lastDocument.add(response.data.docs[response.data.docs.length - 1]);
            final listPost = response.data.docs.map((e) => e.data()).toList();
            final List<PostModel> postList = [];
            for (var i = 0; i < listPost.length; i++) {
              postList.add(PostModel.fromMap(listPost[i]));
            }

            emit(PostsLoaded(
              posts: postList,
            ));
          } else {
            emit(PostLoadingFailure(message: response.message));
          }
        }

        if (event is LoadMorePosts) {
          final response =
              await _postRepository.getMorePosts(lastDocument: lastDocument);
          print(response.message);
        }
      },
    );
  }
}
