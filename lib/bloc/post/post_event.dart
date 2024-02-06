part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

final class PostCreate extends PostEvent {
  final PostModel postModel;

  const PostCreate({required this.postModel});

  @override
  List<Object> get props => [postModel];
}

final class PostUpdate extends PostEvent {
  final PostModel postModel;

  const PostUpdate({required this.postModel});

  @override
  List<Object> get props => [postModel];
}

final class PostDelete extends PostEvent {
  final PostModel postModel;

  const PostDelete({required this.postModel});

  @override
  List<Object> get props => [postModel];
}

final class GetUserPosts extends PostEvent {
  final String userId;

  const GetUserPosts({required this.userId});

  @override
  List<Object> get props => [userId];
}

final class GetPosts extends PostEvent {
  const GetPosts();
}
