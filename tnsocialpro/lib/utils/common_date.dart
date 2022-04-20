
import 'package:date_format/date_format.dart';

class CommonDate {

  // 根据出生日期获取年龄
  static int getAgeFromBirthday(String strBirthday) {
    if(strBirthday == null || strBirthday.isEmpty) {
      print('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age --;
    }
    return age;
  }

  static timeShowUtils(int _maturityTim) {
    ///字符串类型转换成时间戳
    // int _maturityTim = DateTime.parse(startTime).millisecondsSinceEpoch;

    ///创建时间戳 转换为 DateTime对象
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(_maturityTim);

    ///超出一年
    if (_dateTime.year != DateTime.now().year) {
      String _r = formatDate(_dateTime, [yyyy, '年', mm, '月', dd, '日']);
      if (_dateTime.hour < 12) {
        return "$_r 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
      } else {
        return "$_r 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
      }
    } else {
      ///间隔时间 = 当前时间 - 创建时间   单位：分钟
      int _m = DateTime.now().difference(_dateTime).inMinutes.abs();

      ///一小时以内
      if (_m < 60) {
        return "${_m}分钟前";
      }else if(_m < 1){
        return "刚刚";
      }

      ///当天
      if (isToday(_maturityTim)) {
        ///12点之前 上午
        if (_dateTime.hour < 12) {
          return "今天${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";

          ///12点之后 下午
        } else {
          return "今天${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }

      ///前一天
      if ((DateTime.now().day - _dateTime.day) == 1) {
        if (_dateTime.hour < 12) {
          return "昨天 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        } else {
          return "昨天 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }

      ///一周以内 不建议用 时间信息不够明确
      if ((DateTime.now().day - _dateTime.day) <= 7) {
        String _x = getWeekday(
            DateTime.fromMillisecondsSinceEpoch(
                _dateTime.millisecondsSinceEpoch),
            languageCode: "zh");

        if (_dateTime.hour < 12) {
          return "$_x 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        } else {
          return "$_x 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }

      ///其他样式 6月01日 下午17:54
      ///12点之前 上午
      if (_dateTime.hour < 12) {
        return "${_dateTime.month}月${numberUtils(_dateTime.day)}日 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";

        ///12点之后 下午
      } else {
        return "${_dateTime.month}月${numberUtils(_dateTime.day)}日 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
      }
    }
    return "";
  }


  // String _time = GlobalVariable.timeUtils(startTime: "2020-09-25 10:18:17")
  static timeUtils(String startTime) {
    if (startTime != null && startTime.runtimeType != Null && startTime != "") {
      ///字符串类型转换成时间戳
      int _maturityTim = DateTime.parse(startTime).millisecondsSinceEpoch;

      ///创建时间戳 转换为 DateTime对象
      DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(_maturityTim);

      ///超出一年
      if (_dateTime.year != DateTime.now().year) {
        String _r = formatDate(_dateTime, [yyyy, '年', mm, '月', dd, '日']);
        if (_dateTime.hour < 12) {
          return "$_r 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        } else {
          return "$_r 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      } else {
        ///间隔时间 = 当前时间 - 创建时间   单位：分钟
        int _m = DateTime.now().difference(_dateTime).inMinutes.abs();

        ///一小时以内
       if (_m < 60) {
         return "${_m}分钟前";
       }else if(_m < 1){
         return "刚刚";
       }

        ///当天
        if (isToday(_maturityTim)) {
          ///12点之前 上午
          if (_dateTime.hour < 12) {
            return "今天${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";

            ///12点之后 下午
          } else {
            return "今天${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
          }
        }

        ///前一天
        if ((DateTime.now().day - _dateTime.day) == 1) {
          if (_dateTime.hour < 12) {
            return "昨天 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
          } else {
            return "昨天 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
          }
        }

        ///一周以内 不建议用 时间信息不够明确
       if ((DateTime.now().day - _dateTime.day) <= 7) {
         String _x = getWeekday(
             DateTime.fromMillisecondsSinceEpoch(
                 _dateTime.millisecondsSinceEpoch),
             languageCode: "zh");

         if (_dateTime.hour < 12) {
           return "$_x 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
         } else {
           return "$_x 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
         }
       }

        ///其他样式 6月01日 下午17:54
        ///12点之前 上午
        if (_dateTime.hour < 12) {
          return "${_dateTime.month}月${numberUtils(_dateTime.day)}日 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";

          ///12点之后 下午
        } else {
          return "${_dateTime.month}月${numberUtils(_dateTime.day)}日 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }
    }
    return "";
  }

  /// get WeekDay.
  /// dateTime
  /// isUtc
  /// languageCode zh or en
  /// short
  static String getWeekday(DateTime dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return "";
    String weekday = "";
    switch (dateTime.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '星期一' : 'Monday';
        break;
      case 2:
        weekday = languageCode == 'zh' ? '星期二' : 'Tuesday';
        break;
      case 3:
        weekday = languageCode == 'zh' ? '星期三' : 'Wednesday';
        break;
      case 4:
        weekday = languageCode == 'zh' ? '星期四' : 'Thursday';
        break;
      case 5:
        weekday = languageCode == 'zh' ? '星期五' : 'Friday';
        break;
      case 6:
        weekday = languageCode == 'zh' ? '星期六' : 'Saturday';
        break;
      case 7:
        weekday = languageCode == 'zh' ? '星期日' : 'Sunday';
        break;
      default:
        break;
    }
    return languageCode == 'zh'
        ? (short ? weekday.replaceAll('星期', '周') : weekday)
        : weekday.substring(0, short ? 3 : weekday.length);
  }

  /// is today.
  /// 是否是当天.
  static bool isToday(int milliseconds, {bool isUtc = false, int locMs}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime old =
    DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = getDateTimeByMs(locMs);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// get DateTime By Milliseconds.
  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  ///时间值转换
  ///2:1  => 02 : 01
  static numberUtils(int number) {
    if (number < 10) {
      return "0${number.toString()}";
    }
    return number.toString();
  }
}