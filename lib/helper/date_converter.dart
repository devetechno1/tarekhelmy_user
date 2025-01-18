import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../features/language/controllers/language_controller.dart';

class DateConverter {

  static String get _locale => Get.find<LocalizationController>().locale.languageCode;

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss a',_locale).format(dateTime);
  }

  static String dateToTimeOnly(DateTime dateTime) {
    return DateFormat(_timeFormatter(),_locale).format(dateTime);
  }

  static String dateToDateAndTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm',_locale).format(dateTime);
  }

  static String dateToDateAndTimeAm(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd ${_timeFormatter()}',_locale).format(dateTime);
  }

  // static String dateToDate(DateTime dateTime) {
  //   return DateFormat('yyyy-MM-dd',_locale).format(dateTime);
  // }

  // static String dateToReadableDate(DateTime dateTime) {
  //   return DateFormat('dd MMM, yyy',_locale).format(dateTime);
  // }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}',_locale).format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }
  // static String dateTimeStringToDateString(String dateTime) {
  //   final DateTime date = DateFormat('yyyy-MM-dd HH:mm:ss',_locale).parse(dateTime);
  //   return "${date.day} / ${date.month} / ${date.year}";
  // }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy',_locale).format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String isoStringToLocalString(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss',_locale).format(DateTime.parse(dateTime).toLocal());
  }

  // static String isoStringToReadableString(String dateTime) {
  //   return DateFormat('dd MMMM, yyyy HH:mm a',_locale).format(DateTime.parse(dateTime).toLocal());
  // }

  static String stringToReadableString(String dateTime) {
    return DateFormat('dd MMMM, yyyy',_locale).format(DateTime.parse(dateTime).toLocal());
  }

  static String isoStringToDateTimeString(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}',_locale).format(isoStringToLocalDate(dateTime));
  }

  // static String isoStringToLocalDateOnly(String dateTime) {
  //   return DateFormat('dd MMM yyyy',_locale).format(isoStringToLocalDate(dateTime));
  // }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy',_locale).format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS',_locale).format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter(),_locale).format(DateFormat('HH:mm').parse(time));
  }

  static DateTime convertStringTimeToDate(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  // static String convertTimeToTimeDate(DateTime time) {
  //   return DateFormat('HH:mm',_locale).format(time);
  // }

  static bool isAvailable(String? start, String? end, {DateTime? time}) {
    DateTime currentTime;
    if(time != null) {
      currentTime = time;
    }else {
      currentTime = Get.find<SplashController>().currentTime;
    }
    DateTime start0 = start != null ? DateFormat('HH:mm').parse(start) : DateTime(currentTime.year);
    DateTime end0 = end != null ? DateFormat('HH:mm').parse(end) : DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 59, 59);
    DateTime startTime = DateTime(currentTime.year, currentTime.month, currentTime.day, start0.hour, start0.minute, start0.second);
    DateTime endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, end0.hour, end0.minute, end0.second);
    if(endTime.isBefore(startTime)) {
      if(currentTime.isBefore(startTime) && currentTime.isBefore(endTime)){
        startTime = startTime.add(const Duration(days: -1));
      }else {
        endTime = endTime.add(const Duration(days: 1));
      }
    }
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  static String _timeFormatter() {
    return Get.find<SplashController>().configModel!.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static String convertFromMinute(int minMinute, int maxMinute) {
    int firstValue = minMinute;
    int secondValue = maxMinute;
    String type = 'min';
    if(minMinute >= 525600) {
      firstValue = (minMinute / 525600).floor();
      secondValue = (maxMinute / 525600).floor();
      type = 'year';
    }else if(minMinute >= 43200) {
      firstValue = (minMinute / 43200).floor();
      secondValue = (maxMinute / 43200).floor();
      type = 'month';
    }else if(minMinute >= 10080) {
      firstValue = (minMinute / 10080).floor();
      secondValue = (maxMinute / 10080).floor();
      type = 'week';
    }else if(minMinute >= 1440) {
      firstValue = (minMinute / 1440).floor();
      secondValue = (maxMinute / 1440).floor();
      type = 'day';
    }else if(minMinute >= 60) {
      firstValue = (minMinute / 60).floor();
      secondValue = (maxMinute / 60).floor();
      type = 'hour';
    }
    return '$firstValue-$secondValue ${type.tr}';
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('${_timeFormatter()} | d-MMM-yyyy ',_locale).format(dateTime.toLocal());
  }

  static bool isBeforeTime(String? dateTime) {
    if(dateTime == null) {
      return false;
    }
    DateTime scheduleTime = dateTimeStringToDate(dateTime);
    return scheduleTime.isBefore(DateTime.now());
  }

  static int differenceInMinute(String? deliveryTime, String? orderTime, int? processingTime, String? scheduleAt) {
    // 'min', 'hours', 'days'
    int minTime = processingTime ?? 0;
    if(deliveryTime != null && deliveryTime.isNotEmpty && processingTime == null) {
      try {
        List<String> timeList = deliveryTime.split('-'); // ['15', '20']
        minTime = int.parse(timeList[0]);
      }catch(_) {}
    }
    DateTime deliveryTime0 = dateTimeStringToDate(scheduleAt ?? orderTime!).add(Duration(minutes: minTime));
    return deliveryTime0.difference(DateTime.now()).inMinutes;
  }

  static String containTAndZToUTCFormat(String time) {
    var newTime = '${time.substring(0,10)} ${time.substring(11,23)}';
    return DateFormat('dd MMM, yyyy',_locale).format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(newTime));

    // return DateFormat('${_timeFormatter()} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static String convertTodayYesterdayFormat(String createdAt) {
    final now = DateTime.now();
    final createdAtDate = DateTime.parse(createdAt).toLocal();

    if (createdAtDate.year == now.year &&
        createdAtDate.month == now.month &&
        createdAtDate.day == now.day) {
      return '${'today'.tr}, ${DateFormat.jm(_locale).format(createdAtDate)}';
    } else if (createdAtDate.year == now.year &&
        createdAtDate.month == now.month &&
        createdAtDate.day == now.day - 1) {
      return '${'yesterday'.tr}, ${DateFormat.jm(_locale).format(createdAtDate)}';
    } else {
      return DateConverter.localDateToIsoStringAMPM(createdAtDate);
    }
  }

  static String convertOnlyTodayTime(String createdAt) {
    final now = DateTime.now();
    final createdAtDate = DateTime.parse(createdAt).toLocal();

    if (createdAtDate.year == now.year &&
        createdAtDate.month == now.month &&
        createdAtDate.day == now.day) {
      return DateFormat('h:mm a',_locale).format(createdAtDate);
    } else {
      return DateConverter.localDateToIsoStringAMPM(createdAtDate);
    }
  }

  static String convertRestaurantOpenTime(String time) {
    return DateFormat('hh:mm a',_locale).format(DateFormat('HH:mm:ss').parse(time).toLocal());
  }

  static String dateTimeStringToFormattedTime(String dateTime) {
    return DateFormat(_timeFormatter(),_locale).format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

}
