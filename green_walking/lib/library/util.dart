import 'dart:math' show log, pow;

String? truncateString(String? myString, int? cutoff) {
  if (myString == null) {
    return null;
  }
  if (cutoff == null || cutoff < 1) {
    return null;
  }
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}
