
import '../model/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}
class Newsloading extends NewsState {}
class Newsloaded extends NewsState {
  final news_model data;
  Newsloaded({required this.data});
}
class Newserror extends NewsState {
  String error;
  Newserror({required this.error});
}
