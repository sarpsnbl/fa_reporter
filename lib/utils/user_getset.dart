var location = "";
var username = "";
var tollNumber = 0;
List<List<String>> excelReport = [];

String getUserCurrentDate() {
  final DateTime now = DateTime.now(); // Get the current date and time

  // Format the date as DD-MM-YY
  String formattedDate =
      '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}';

  return formattedDate;
}

getExcelReport() {
  return excelReport;
}

getUserLocation() {
  return location;
}

setUserLocation(value) {
  location = value;
}

getUserName() {
  return username;
}

setUserName(value) {
  username = value;
}

getTollNumber() {
  return tollNumber;
}

setTollNumber(value) {
  tollNumber = value;
}
