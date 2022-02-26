import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'picture_event.dart';
part 'picture_state.dart';

//Bloc recive events and emits a state
class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial()) {
    on<ChangeImageEvent>(_onChangedImage);
  }

  void _onChangedImage(PictureEvent event, Emitter emitState) async {
    // take picture
    File? img = await _pickImage();
    try {
      if (img != null) {
        emitState(
          PictureSelectedState(picture: img),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      emitState(
        PictureErrorState(errorMsg: "No se pudo seleccionar la imagen"),
      );
    }
  }

  // Method to take image
  Future<File?> _pickImage() async {
    // Pick an image
    final _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720, //Vertical picture and compress it
      maxWidth: 720, //Horizontal picture and compress it
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }
}
