extension NullableString on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
}
