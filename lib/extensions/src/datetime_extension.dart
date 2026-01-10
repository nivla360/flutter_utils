import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Comprehensive DateTime extensions for common date operations
extension DateTimeExt on DateTime {
  
  // Formatting methods
  
  /// Format as 'Jan 15, 2025'
  String get mediumDate => DateFormat.yMMMd().format(this);
  
  /// Format as 'January 15, 2025'
  String get longDate => DateFormat.yMMMMd().format(this);
  
  /// Format as '01/15/2025'
  String get shortDate => DateFormat.yMd().format(this);
  
  /// Format as '3:30 PM'
  String get time12 => DateFormat.jm().format(this);
  
  /// Format as '15:30'
  String get time24 => DateFormat.Hm().format(this);
  
  /// Format as 'Jan 15, 2025 3:30 PM'
  String get mediumDateTime => DateFormat.yMMMd().add_jm().format(this);
  
  /// Format as 'Monday, January 15, 2025'
  String get fullDate => DateFormat.yMMMMEEEEd().format(this);
  
  /// Format as 'Mon, Jan 15'
  String get compactDate => DateFormat.E().add_MMMd().format(this);
  
  /// Format as ISO string with timezone
  String get isoString => toUtc().toIso8601String();
  
  /// Format as relative time ('2 hours ago', 'in 3 days')
  String get timeAgo => timeago.format(this);
  
  /// Format as relative time from now
  String timeAgoFrom(DateTime from) => timeago.format(this, locale: 'en', clock: from);
  
  /// Smart formatting based on how recent the date is
  String get smart {
    final now = DateTime.now();
    final difference = now.difference(this).abs();
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return timeAgo;
    } else if (difference.inDays < 1) {
      return time12;
    } else if (difference.inDays < 7) {
      return DateFormat.E().add_jm().format(this); // 'Mon 3:30 PM'
    } else if (year == now.year) {
      return DateFormat.MMMd().add_jm().format(this); // 'Jan 15, 3:30 PM'
    } else {
      return mediumDateTime;
    }
  }
  
  // Comparison methods
  
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }
  
  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.startOfDay) && isBefore(endOfWeek.endOfDay);
  }
  
  /// Check if date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
  
  /// Check if date is this year
  bool get isThisYear => year == DateTime.now().year;
  
  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());
  
  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());
  
  /// Check if date is a weekend
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;
  
  /// Check if date is a weekday
  bool get isWeekday => !isWeekend;
  
  // Utility getters
  
  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);
  
  /// Get end of day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  
  /// Get start of week (Monday 00:00:00)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;
  
  /// Get end of week (Sunday 23:59:59.999)
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6)).endOfDay;
  
  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);
  
  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 1).subtract(const Duration(microseconds: 1));
  
  /// Get start of year
  DateTime get startOfYear => DateTime(year, 1, 1);
  
  /// Get end of year
  DateTime get endOfYear => DateTime(year + 1, 1, 1).subtract(const Duration(microseconds: 1));
  
  /// Get days in current month
  int get daysInMonth => DateTime(year, month + 1, 0).day;
  
  /// Get week number of year
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstWeekday = firstDayOfYear.weekday;
    final daysInFirstWeek = 8 - firstWeekday;
    final dayOfYear = difference(firstDayOfYear).inDays + 1;
    
    if (dayOfYear <= daysInFirstWeek) {
      return 1;
    }
    
    return ((dayOfYear - daysInFirstWeek - 1) / 7).floor() + 2;
  }
  
  /// Get quarter of year (1-4)
  int get quarter => ((month - 1) / 3).floor() + 1;
  
  // Manipulation methods
  
  /// Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    var result = this;
    var remaining = days.abs();
    final increment = days > 0 ? 1 : -1;
    
    while (remaining > 0) {
      result = result.add(Duration(days: increment));
      if (result.isWeekday) {
        remaining--;
      }
    }
    
    return result;
  }
  
  /// Get next business day
  DateTime get nextBusinessDay {
    var next = add(const Duration(days: 1));
    while (next.isWeekend) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }
  
  /// Get previous business day
  DateTime get previousBusinessDay {
    var previous = subtract(const Duration(days: 1));
    while (previous.isWeekend) {
      previous = previous.subtract(const Duration(days: 1));
    }
    return previous;
  }
  
  /// Copy with specific values
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
  
  /// Set time to specific hour and minute
  DateTime atTime(int hour, [int minute = 0, int second = 0]) {
    return DateTime(year, month, day, hour, minute, second);
  }
  
  // Age calculation
  
  /// Calculate age from this date
  int ageFrom(DateTime birthDate) {
    int age = year - birthDate.year;
    if (month < birthDate.month || (month == birthDate.month && day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  /// Get age in years from this birthdate
  int get age => DateTime.now().ageFrom(this);
}

/// Extension on Duration for better readability
extension DurationExt on Duration {
  /// Format duration as human readable string
  String get readable {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    final parts = <String>[];
    
    if (days > 0) parts.add('${days}d');
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 && days == 0) parts.add('${seconds}s');
    
    if (parts.isEmpty) return '0s';
    return parts.join(' ');
  }
  
  /// Format duration as short string (e.g., '2:30:45')
  String get hms {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

/// Utility class for date operations
class DateUtils {
  /// Get all dates in a date range
  static List<DateTime> dateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = start.startOfDay;
    final endDate = end.startOfDay;
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    
    return dates;
  }
  
  /// Get all business days in a date range
  static List<DateTime> businessDays(DateTime start, DateTime end) {
    return dateRange(start, end).where((date) => date.isWeekday).toList();
  }
  
  /// Parse various date string formats
  static DateTime? tryParse(String dateString) {
    // Try common formats
    final formats = [
      DateFormat('yyyy-MM-dd'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('MM/dd/yyyy HH:mm:ss'),
      DateFormat('MMM dd, yyyy'),
      DateFormat('MMMM dd, yyyy'),
      DateFormat('dd MMM yyyy'),
      DateFormat('dd MMMM yyyy'),
    ];
    
    for (final format in formats) {
      try {
        return format.parse(dateString);
      } catch (_) {
        continue;
      }
    }
    
    // Try DateTime.parse as fallback
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }
  
  /// Get list of months in a year
  static List<DateTime> monthsInYear(int year) {
    return List.generate(12, (index) => DateTime(year, index + 1, 1));
  }
  
  /// Get list of days in a month
  static List<DateTime> daysInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    return dateRange(firstDay, lastDay);
  }
  
  /// Calculate business days between two dates
  static int businessDaysBetween(DateTime start, DateTime end) {
    return businessDays(start, end).length;
  }
  
  /// Check if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }
}