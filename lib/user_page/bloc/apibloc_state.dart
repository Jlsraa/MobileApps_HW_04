part of 'apibloc_bloc.dart';

abstract class ApiblocState extends Equatable {
  const ApiblocState();

  @override
  List<Object> get props => [];
}

class ApiblocInitial extends ApiblocState {}

class ApiErrorState extends ApiblocState {
  final String apiErrorMsg;

  ApiErrorState({required this.apiErrorMsg});

  @override
  List<Object> get props => [apiErrorMsg];
}

class ApiListState extends ApiblocState {
  final url;

  ApiListState({required this.url});

  @override
  List<Object> get props => [url];
}

class ApiLoadingState extends ApiblocState {}
