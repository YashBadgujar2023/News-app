
import 'package:intl/intl.dart';

String date_formatter(String dataString){
  DateTime dateTime = DateTime.parse(dataString);
  DateFormat formatter = DateFormat("yMMMd");
  String data = formatter.format(dateTime);
  return data;
}