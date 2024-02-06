part of 'add_post_cubit.dart';

sealed class AddPostState extends Equatable {
  const AddPostState();

  @override
  List<Object> get props => [];
}

final class AddPostClosed extends AddPostState {}

final class AddPostOpened extends AddPostState {}
