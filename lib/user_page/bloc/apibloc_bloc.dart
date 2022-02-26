import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'apibloc_event.dart';
part 'apibloc_state.dart';

class ApiblocBloc extends Bloc<ApiblocEvent, ApiblocState> {
  ApiblocBloc() : super(ApiblocInitial()) {
    on<ApiblocEvent>(_apiGet);
  }

  void _apiGet(ApiblocEvent event, Emitter emitState) async {
    emitState(ApiLoadingState());
    var data = await _getData();
    try {
      if (data != null) {
        emitState(
          ApiListState(url: data),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      emitState(
        ApiErrorState(apiErrorMsg: "No se pudieron cargar los datos"),
      );
    }
  }

  Future _getData() async {
    String _url =
        "https://api.sheety.co/88011278006bffc90dececcea235db7c/dummyApi/sheet1";
    Uri uri = Uri.parse(_url);
    http.Response _response = await http.get(uri);

    if (_response.statusCode == 200) {
      return jsonDecode(_response.body);
    } else {
      print("Error");
      return null;
    }
  }
}
