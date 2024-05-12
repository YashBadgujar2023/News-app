import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:news_app/bloc/news_state.dart';
import 'package:news_app/model/news_model.dart';

import 'news_event.dart';

class NewsBloc extends Bloc<NewsEvent,NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<data>((event, emit) async{
      // TODO: implement event handler
      emit(Newsloading());
      var request =await http.get(Uri.parse("api Url"));
      if(request.statusCode == 200){
        Map<String,dynamic> responsedata = jsonDecode(request.body);
        log(responsedata.toString());
        emit(Newsloaded(data: news_model.fromJson(responsedata)));
      }
      else{
        emit(Newserror(error: request.statusCode.toString()));
      }
    });
  }
}
