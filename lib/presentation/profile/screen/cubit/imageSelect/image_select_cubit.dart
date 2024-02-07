import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'image_select_state.dart';

class ImageSelectCubit extends Cubit<ImageSelectState> {
  ImageSelectCubit() : super(ImageSelectInitial());

  final ImagePicker _picker = ImagePicker();
  final Set<XFile> _images = {};

  Future<void> pickImage() async {
    emit(ImageSelectLoading());
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!_images.contains(image)) {
        //this isn't working as it is generating new url for each image even if they are the same
        _images.add(image);
      }
      emit(ImageSelectLoaded(images: [..._images]));
    } else {
      emit(ImageSelectInitial());
    }
  }

  void removeImage(int index) {
    _images.removeWhere(
        (element) => element.path == _images.elementAt(index).path);

    if (_images.isEmpty) {
      emit(ImageSelectInitial());
    } else {
      print([..._images]);
      emit(ImageSelectLoaded(images: [..._images]));
    }
  }

  void clearImages() {
    _images.clear();
    print(_images.length);
    print("Inside Clear Images");
    emit(ImageSelectInitial());
  }
}
