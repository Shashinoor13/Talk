part of 'image_select_cubit.dart';

sealed class ImageSelectState extends Equatable {
  const ImageSelectState();

  @override
  List<Object> get props => [];
}

final class ImageSelectInitial extends ImageSelectState {}

final class ImageSelectLoading extends ImageSelectState {}

final class ImageSelectLoaded extends ImageSelectState {
  final List<XFile> images;
  const ImageSelectLoaded({required this.images});
}
