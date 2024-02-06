part of 'home_data_bloc.dart';

sealed class HomeDataState extends Equatable {
  const HomeDataState();

  @override
  List<Object> get props => [];
}

final class HomeDataInitial extends HomeDataState {}

final class HomeDataLoading extends HomeDataState {}

final class HomeDataLoaded extends HomeDataState {
  final List<DocumentSnapshot> data;

  const HomeDataLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class HomeDataError extends HomeDataState {
  final String message;

  const HomeDataError({required this.message});

  @override
  List<Object> get props => [message];
}
