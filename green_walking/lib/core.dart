
const String privacyPolicyUrl =
    'https://raw.githubusercontent.com/Xennis/green-walking/master/web/privacy/privacy-policy.md';

String? truncateString(String? myString, int? cutoff) {
  if (myString == null) {
    return null;
  }
  if (cutoff == null || cutoff < 1) {
    return null;
  }
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}