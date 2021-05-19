class CalcModel {
  // date:   起算日
  // days:   日齢
  // weeks:  週齢
  DateTime calcDueDate(DateTime date, int days, int weeks) {
    var daysOfWeeks = weeks*7;
    var pastDays = 280 - (days + daysOfWeeks);

    return date.add(Duration(days: pastDays));
  }
}
