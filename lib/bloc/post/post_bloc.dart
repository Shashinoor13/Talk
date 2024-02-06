import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talk/data/model/post_model.dart';
import 'package:talk/data/model/response_model.dart';
import 'package:talk/data/repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostDataRepository _postRepository = PostDataRepository();
  PostBloc() : super(PostInitial()) {
    on<PostEvent>((event, emit) async {
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
        print('GetUserPosts');
        final response =
            await _postRepository.getPostsByUser(userId: event.userId);
        print(response.data);
        if (response.status) {
          emit(PostsLoaded(
            posts: response,
          ));
        } else {
          emit(PostLoadingFailure(message: response.message));
        }
      }
    });
  }
}
