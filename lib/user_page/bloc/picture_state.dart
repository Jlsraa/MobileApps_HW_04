part of 'picture_bloc.dart';

abstract class PictureState extends Equatable {
  const PictureState();

  @override
  List<Object> get props => [];
}

class PictureInitial extends PictureState {}

// State definition
class PictureErrorState extends PictureState {
  final String errorMsg;

  PictureErrorState({required this.errorMsg});

  @override
  List<Object> get props =>
      [errorMsg]; //Compare if two objects are the same (to change state)
}

class PictureSelectedState extends PictureState {
  final File picture;

  PictureSelectedState({required this.picture});

  @override
  List<Object> get props => [picture];
}
