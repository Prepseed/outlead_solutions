import 'package:intl/intl.dart';

class DateFormatFunction{

  String? fromDate;

  dateFormatter(date){
    var fromDateTime = DateTime.parse(date.toString());
    var fromDateParse = DateFormat("yyyy-MM-dd HH:mm").parse(fromDateTime.toString(), true);
    return fromDateParse;
  }

}