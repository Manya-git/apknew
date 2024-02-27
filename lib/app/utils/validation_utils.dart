
class ValidationUtils {

  static String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value!.trim().isEmpty) {
      return 'Please enter email-id';
    } else if (!regex.hasMatch(value))
      return 'Please enter valid email-id';
    else
      return null;
  }

  static String? validatePassword(String? value) {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value!.trim().isEmpty) {
      return 'Please enter password';
    } else if (value.length < 8) {
      return 'Password should contain minimum 8 characters';
    } else if(!regExp.hasMatch(value)) {
      return 'Must contain at least one number and one special character and one uppercase and lowercase letter, and at least 8 or more characters';
    }
    return null;
  }

  static String? requiredField(String? value, String message) {
    if (value!.trim().isEmpty) {
      return message + "\trequired";
    }
    return null;
  }

  static bool isValidMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[+0-9]{8,15}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().isEmpty || !regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String? isValidateMobile(String? value, String name) {
    String patttern = r'(^(?:[+0]9)?[0-9]{8,15}$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.trim().isEmpty || value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }


}
