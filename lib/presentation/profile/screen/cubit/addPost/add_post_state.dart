part of 'add_post_cubit.dart';

sealed class AddPostState extends Equatable {
  const AddPostState();

  @override
  List<Object> get props => [];
}

final class AddPostClosed extends AddPostState {}

final class AddPostOpened extends AddPostState {}

final class AddingPost extends AddPostState {}

final class PostAdded extends AddPostState {
  final ResponseModel responseModel;
  const PostAdded({required this.responseModel});

  @override
  List<Object> get props => [responseModel];
}

final class PostAddingFailed extends AddPostState {
  final String message;
  const PostAddingFailed({required this.message});

  @override
  List<Object> get props => [message];
}
