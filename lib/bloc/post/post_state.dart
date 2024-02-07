part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostSuccess extends PostState {
  final ResponseModel responseModel;

  const PostSuccess({required this.responseModel});

  @override
  List<Object> get props => [responseModel];
}

final class PostFailure extends PostState {
  final String message;

  const PostFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class PostsLoaded extends PostState {
  final List<PostModel> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

final class PostLoadingFailure extends PostState {
  final String message;

  const PostLoadingFailure({required this.message});

  @override
  List<Object> get props => [message];
}
