part of 'home_data_bloc.dart';

sealed class HomeDataEvent extends Equatable {
  const HomeDataEvent();

  @override
  List<Object> get props => [];
}

final class GetInitialData extends HomeDataEvent {}

final class GetMoreData extends HomeDataEvent {
  final DocumentSnapshot lastDocument;

  GetMoreData({required this.lastDocument});

  @override
  List<Object> get props => [lastDocument];
}
