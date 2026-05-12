class Validator {
  static String? emptyfield(String value) {
    if (value.isEmpty) {
      return 'ce champ est requis ou incorrect';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return "ce champ est requis ou incorrect";
    } else {
      if (value.length < 14) {
        return "ce champ est requis ou incorrect";
      } else {
        return null;
      }
    }
  }

  static String? validatePassword(String value) {
    // Pattern pattern =
    //     "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@%^&*-]).{6,}";
    // RegExp regex = RegExp(pattern as String);
    if (value.isEmpty) {
      return "ce champ est requis ou incorrect";
    } else if (value.length < 6) {
      return "Le mot de passe doit contenir au minimum 6 caractères.";
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String value, String passwordValue) {
    if (passwordValue.isEmpty) {
      if (value.isEmpty) {
        return null;
      }
    } else {
      if (value.isEmpty) {
        return 'ce champ est requis ou incorrect';
      }
    }

    if (passwordValue != value) {
      return 'Le mot de passe n’est pas le même';
    }
    return null;
  }

  static String? validateEmail(String value) {
    Pattern pattern = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]";
    RegExp regex = RegExp(pattern as String);
    if (value.isEmpty) {
      return "ce champ est requis ou incorrect";
    } else if (!regex.hasMatch(value)) {
      return "Format d'email invalide!";
    } else {
      return null;
    }
  }

  static String? validateConfirmEmail(String value, String emailValue) {
    if (emailValue.isEmpty) {
      if (value.isEmpty) {
        return null;
      }
    } else {
      if (value.isEmpty) {
        return 'ce champ est requis ou incorrect';
      }
    }

    if (emailValue != value) {
      return 'Le email n’est pas le même';
    }
    return null;
  }
}
