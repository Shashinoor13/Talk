import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:talk/data/repository/homeData_repository.dart';

part 'home_data_event.dart';
part 'home_data_state.dart';

class HomeDataBloc extends Bloc<HomeDataEvent, HomeDataState> {
  final _homeDataRepository = HomeDataRepository();
  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;
  final int limit = 10;
  final List<DocumentSnapshot> data = [];
  HomeDataBloc() : super(HomeDataInitial()) {
    on<HomeDataEvent>((event, emit) async {
      if (event is GetInitialData) {
        emit(HomeDataLoading());
        data.clear();
        final initialDataFromFirebase =
            await _homeDataRepository.getInitialData();
        if (initialDataFromFirebase.docs.length < limit) {
          hasMoreData = false;
          emit(
            HomeDataLoaded(data: initialDataFromFirebase.docs),
          );
        }
        if (initialDataFromFirebase.docs.isNotEmpty) {
          lastDocument = initialDataFromFirebase.docs.last;
        }
        emit(
          HomeDataLoaded(data: initialDataFromFirebase.docs),
        );
      }
    });
  }
}
