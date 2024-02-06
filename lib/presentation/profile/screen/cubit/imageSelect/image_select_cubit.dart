import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'image_select_state.dart';

class ImageSelectCubit extends Cubit<ImageSelectState> {
  ImageSelectCubit() : super(ImageSelectInitial());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    emit(ImageSelectLoading());
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(ImageSelectLoaded(images: [image]));
    } else {
      emit(ImageSelectInitial());
    }
  }

  void removeImage(int index) {
    final List<XFile> images = (state as ImageSelectLoaded).images;
    images.removeAt(index);
    if (images.isEmpty) {
      emit(ImageSelectInitial());
    } else {
      emit(ImageSelectLoaded(images: images));
    }
  }

  void clearImages() {
    emit(ImageSelectInitial());
  }
}
