import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';

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
}
