  //Retorna a data do dia como ddmmyy ex 091203
  String todaysDateDDMMYY() {
  //hoje
    var DateTimeObject = DateTime.now();

  //dia
  String day = DateTimeObject.day.toString();
  if (day.length == 1) {
    day = '$day';
  }

  //mes
  String month = DateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //ano
  String year = DateTimeObject.year.toString();

  String ddmmyy = day + month + year;
  return ddmmyy;

  }

  //Coverte string ddmmyy para um objeto DateTime
  DateTime createDateTimeObject(String ddmmyy) {
    int day = int.parse(ddmmyy.substring(0, 2));
    int month = int.parse(ddmmyy.substring(2, 4));
    int year = int.parse(ddmmyy.substring(4, 8));

    return DateTime(year, month, day);
  }


  //Coverte um objeto DateTime para uma string ddmmyy
  String convertDateTimeToDDMMYY(DateTime dateTime) {
  //dia
    String day = dateTime.day.toString();
    if (day.length == 1) {
      day = '$day';
    }

  //mês
    String month = dateTime.month.toString();
    if (month.length == 1) {
      month = '0$month';
    }

  //ano
    String year = dateTime.year.toString();

    String ddmmyy = day + month + year;
    return ddmmyy;
  }