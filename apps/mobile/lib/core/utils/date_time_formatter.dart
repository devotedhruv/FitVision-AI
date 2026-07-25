abstract final class DateTimeFormatter {
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String friendlyDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}, ${date.year}';

  static String shortDate(DateTime date) =>
      '${_months[date.month - 1].substring(0, 3)} ${date.day}';

  static String duration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }
}
