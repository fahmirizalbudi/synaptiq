class JsonUtils {
  const JsonUtils._();

  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    if (value is Map<String, dynamic>) {
      final dynamic seconds = value['seconds'];
      final dynamic nanoseconds = value['nanoseconds'] ?? 0;
      if (seconds is num && nanoseconds is num) {
        return DateTime.fromMillisecondsSinceEpoch(
          (seconds * 1000).round() + (nanoseconds ~/ 1000000),
          isUtc: true,
        );
      }
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int? toTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().millisecondsSinceEpoch;
  }
}
