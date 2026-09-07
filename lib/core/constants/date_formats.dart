import 'package:intl/intl.dart';

import '../base_import.dart';

class DateFormats {
  static const String dateFormatServer = 'yyyy-MM-dd';
  static const String dateFormatServerDisplay = 'MMM dd, yyyy'; // e.g. "Jun 01, 2026"
  static const String dateFormatServer1 = 'yyyy-MM-ddTHH:mm:ss.SSSSSSZ';
  static const String dateFormatToday = 'yyyy-MM-dd HH:mm:ss';
  static const String dateFormatYYYYMMSSHHMMSS = 'yyyy-MM-dd HH:mm:ss';
  static const String dateFormatYYYYMMSSTHHMMSS = 'yyyy-MM-ddTHH:mm:ss';
  static const String dateFormatDDMMMMEEEE = 'dd MMMM, EEEE';

  static const String dateFormatDDMMYYYY = 'dd/MM/yyyy';
  static const String dateFormatDDMMYY = 'dd/MM/yy';
  static const String dateFormatDDMMYYHHMMA = 'dd/MM/yy, hh:mm a';
  static const String dateFormatDDMMYYYYDes = 'dd-MM-yyyy';
  static const String dateFormatDDMYYYY = 'dd/M/yyyy';
  static const String dateFormatYYYYMDD = 'yyyy-MM-dd';
  static const String dateFormatMMMMYYYY = 'MMMM yyyy';
  static const String dateFormatMMYYYY = 'MM/yyyy';
  static const String dateFormatDDMMM = 'dd MMM';
  static const String dateFormatMMMY = 'MMM y';
  static const String dateFormatMMMD = 'MMM d';
  static const String dateFormatMMMMY = 'MMMM y';
  static const String dateFormatDD = 'dd';
  static const String dateFormatMMMM = 'MMMM';
  static const String dateFormatMMM = 'MMM';
  static const String dateFormatMM = 'MM';
  static const String dateFormatHHMMA = 'hh:mm a';
  static const String dateFormatHHMMSS = 'HH:mm:ss';
  static const String dateFormatHHMM = 'HH:mm';
  static const String dateFormatHH = 'HH';
  static const String dateFormatM = 'M';
  static const String dateFormatEE = 'EE';
  static const String dateFormatEEE = 'EEE';
  static const dateFormatWithDay = 'dd MMM yyyy';
  static const dateFormatWithDayComma = 'dd MMM, yyyy'; // e.g. "01 Jun, 2026"
  static const dateFormatWithFullMonth = 'dd MMMM, yyyy';
  static const dateFormatWithDayName = 'EEEE, dd MMMM, yyyy';
  static const dateFormatWithMMMMddYYYY = 'dd MMMM yyyy';
  static const dateFormatWithMMMddYYYY = 'dd MMM yyyy';
  static const dateFormatWithDateAndTime = 'dd MMM, hh:mm a';
  static const dateFormatWithDateAndTimeAndYear = 'dd/MM/yyyy, hh:mm a';
  static const dateFormatWithDayDateWithMonth = 'EEEE, dd MMM';

  static const dateFormatScheduleDateLocal = DateFormats.dateFormatWithDay;
  static const dateFormatScheduleDateServer = DateFormats.dateFormatDDMMYYYYDes;
}

String formatDate(DateTime inputDate, String outputFormat) {
  return DateFormat(outputFormat).format(inputDate);
}

String formatRelativeDate(BuildContext context, DateTime date) {
  final localDate = date.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCompare = DateTime(localDate.year, localDate.month, localDate.day);

  final timeFormat = DateFormats.dateFormatHHMMA; // hh:mm a
  final loc = context.loc;

  if (dateToCompare == today) {
    return loc.todayAt(DateFormat(timeFormat).format(localDate));
  } else if (dateToCompare == yesterday) {
    return loc.yesterdayAt(DateFormat(timeFormat).format(localDate));
  } else {
    return DateFormat("d MMM, yyyy 'at' h:mm a").format(localDate);
  }
}

String getFormattedCurrentDate() {
  return DateFormat(DateFormats.dateFormatYYYYMDD).format(DateTime.now());
}

DateTime getCurrentDate() {
  return DateTime.now();
}

String convertToUTC(String? dateTime) {
  return changeDateFormat(
    DateTime.parse('$dateTime').toLocal().toString(),
    DateFormats.dateFormatToday,
    DateFormats.dateFormatHHMMA,
  );
}

String getDaysName(String dateTime, inputFormat) {
  DateTime inputDate = DateTime.now();
  if (dateTime.isNotNullOrEmpty()) {
    inputDate = DateFormat(inputFormat).parse(dateTime);
  }
  return DateFormat('EEE').format(inputDate);
}

String changeDateFormat(
  String? dateTime,
  String inputFormat,
  String outputFormat,
) {
  if (dateTime == null || dateTime.toString().trim() == '') {
    return '';
  }
  DateTime inputDate = DateTime.now();
  if (dateTime.isNotNullOrEmpty()) {
    inputDate = DateFormat(inputFormat).parse(dateTime);
  }
  return DateFormat(outputFormat).format(inputDate);
}

DateTime? formatDateFormat(
  String? inputDate,
  String inputFormat,
  String outputFormat,
) {
  if (inputDate == null || inputDate.isEmpty) {
    return null;
  }
  final dateTime = DateFormat(inputFormat).parse(inputDate);
  return DateFormat(outputFormat).parse(dateTime.toString());
}

bool showTimer(dynamic val) {
  return DateTime.now().compareTo(
        DateFormat(DateFormats.dateFormatDDMMYYYY).parse(val),
      ) ==
      -1;
}

bool checkCurrentDate(dynamic val) {
  return DateTime.now().compareTo(
        DateFormat(DateFormats.dateFormatDDMMYYYY).parse(val),
      ) >
      0;
}

String hhMM(dynamic val) {
  if (val != null) {
    var inputFormat = DateFormat(DateFormats.dateFormatHHMMSS);
    var invoiceDates = inputFormat.parse(val);
    var outputFormat = DateFormat(DateFormats.dateFormatHHMMA);
    return outputFormat.format(invoiceDates);
  }
  return '';
}

/// Returns the suffix for the given number, such as 'st' for 1 or 'th' for 11.
String getSuffix(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return 'th';
  } else {
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

bool isMultipleDay(String startDateStr, String endDateStr) {
  if (startDateStr.isEmpty || startDateStr.isEmpty) {
    return false;
  }
  DateTime startDate = DateTime.parse(startDateStr);
  DateTime endDate = DateTime.parse(endDateStr);

  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);

  return end.difference(start).inDays != 0;
}

int getDayDifference(String startDateStr, String endDateStr) {
  DateTime startDate = DateTime.parse(startDateStr);
  DateTime endDate = DateTime.parse(endDateStr);
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);

  final difference = end.difference(start).inDays.abs() + 1;

  return difference == 0 ? 1 : difference;
}

List<String> getDateRangeList(String startDateStr, String endDateStr) {
  DateTime startDate = DateTime.parse(startDateStr);
  DateTime endDate = DateTime.parse(endDateStr);

  List<String> ranges = [];

  DateTime currentDate = startDate;

  while (currentDate.isBefore(endDate) ||
      currentDate.isAtSameMomentAs(endDate)) {
    ranges.add(formatDate(currentDate, DateFormats.dateFormatWithDay));
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return ranges;
}

String formatDurationIntoHours(int minutes) {
  int hour = minutes ~/ 60;
  int minute = minutes % 60;
  String formatted = '';
  if (hour > 0) {
    formatted += "$hour ${hour > 1 ? "hours" : "hour"}";
  }
  if (minute > 0) {
    formatted += " ${minute.toString().padLeft(2, '0')} mins";
  }
  return formatted;
}

bool isStartBeforeEnd(String startTime, String endTime) {
  if (endTime.isEmpty) {
    return false;
  }
  final format = DateFormat(DateFormats.dateFormatHHMMA);

  final start = format.parse(startTime);
  final end = format.parse(endTime);

  if (end.isAfter(start)) {
    return true;
  }

  final isEndMidnight = end.hour == 0 && end.minute == 0;

  return isEndMidnight;
}

String formatRemainingTime(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0 && minutes > 0) {
    return '$hours Hr${hours > 1 ? 's' : ''} '
        '$minutes Min${minutes > 1 ? 's' : ''} Left';
  }

  if (hours > 0) {
    return '$hours Hr${hours > 1 ? 's' : ''} Left';
  }

  if (minutes > 0) {
    return '$minutes Min${minutes > 1 ? 's' : ''} Left';
  }

  return 'Time Over';
}

String formatDateRange(DateTime start, DateTime end) {
  final DateFormat formatter = DateFormat('d MMM yyyy');

  return '${formatter.format(start)} – ${formatter.format(end)}';
}
