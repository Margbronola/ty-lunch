extension UrlParse on String {
  Uri get toUrl => Uri.parse(this);

  static final RegExp number = RegExp(r"^(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})$");
  bool isvalidFrenchNumber()=> number.hasMatch(this);

  static final RegExp email = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
  bool isvalidEmail() => email.hasMatch(this);
}