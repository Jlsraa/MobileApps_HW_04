import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
part 'apibloc_event.dart';
part 'apibloc_state.dart';

class ApiblocBloc extends Bloc<ApiblocEvent, ApiblocState> {
  ApiblocBloc() : super(ApiblocInitial()) {
    on<ApiblocEvent>(_apiGet);
  }

  void _apiGet(ApiblocEvent event, Emitter emitState) async {
    String? data = await _getData();
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

  Future<String?> _getData() async {
    final _url = Uri.parse(
        'https:/api.sheety.co/88011278006bffc90dececcea235db7c/dummyApi/sheet1');
    final _response = await http.get(_url);

    if (_response.statusCode == 200) {
      return convert.jsonDecode(_response.body);
    } else {
      print(_response.statusCode);
      return null;
    }
  }
}
