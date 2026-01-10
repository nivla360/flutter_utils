
/// Comprehensive validation extensions for common validation scenarios
extension ValidationExt on String {
  
  // Basic validation
  
  /// Check if string is not null and not empty
  bool get isNotEmptyOrNull => trim().isNotEmpty;
  
  /// Check if string contains only whitespace
  bool get isBlank => trim().isEmpty;
  
  /// Check if string is not blank
  bool get isNotBlank => trim().isNotEmpty;
  
  // Email validation
  
  /// Basic email validation
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(this);
  }
  
  /// Strict email validation
  bool get isValidEmailStrict {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
    );
    return emailRegex.hasMatch(this);
  }
  
  // Phone validation
  
  /// US phone number validation
  bool get isValidUSPhone {
    final phoneRegex = RegExp(r'^\+?1?[2-9]\d{2}[2-9]\d{2}\d{4}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
  
  /// International phone number validation (basic)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(this);
  }
  
  /// Mobile phone validation (basic pattern)
  bool get isValidMobile {
    final cleanPhone = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return cleanPhone.length >= 10 && cleanPhone.length <= 15 && cleanPhone.isNumeric;
  }
  
  // Password validation
  
  /// Basic password validation (minimum 8 characters)
  bool get isValidPassword => length >= 8;
  
  /// Strong password validation
  bool get isStrongPassword {
    if (length < 8) return false;
    
    final hasLowercase = contains(RegExp(r'[a-z]'));
    final hasUppercase = contains(RegExp(r'[A-Z]'));
    final hasDigits = contains(RegExp(r'[0-9]'));
    final hasSpecialChars = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasLowercase && hasUppercase && hasDigits && hasSpecialChars;
  }
  
  /// Very strong password validation
  bool get isVeryStrongPassword {
    if (length < 12) return false;
    return isStrongPassword && !hasCommonPatterns;
  }
  
  /// Check for common password patterns to avoid
  bool get hasCommonPatterns {
    final patterns = [
      RegExp(r'(.)\1{2,}'), // Repeated characters (aaa, 111)
      RegExp(r'(012|123|234|345|456|567|678|789|890)'), // Sequential numbers
      RegExp(r'(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)', caseSensitive: false), // Sequential letters
      RegExp(r'(password|123456|qwerty|admin)', caseSensitive: false), // Common passwords
    ];
    
    return patterns.any((pattern) => contains(pattern));
  }
  
  // URL validation
  
  /// Basic URL validation
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
  
  /// HTTP/HTTPS URL validation
  bool get isValidHttpUrl {
    try {
      final uri = Uri.parse(this);
      return (uri.scheme == 'http' || uri.scheme == 'https') && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
  
  // Name validation
  
  /// Person name validation (letters, spaces, hyphens, apostrophes)
  bool get isValidPersonName {
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    return nameRegex.hasMatch(this) && isNotBlank;
  }
  
  /// Username validation (letters, numbers, underscores, hyphens)
  bool get isValidUsername {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');
    return usernameRegex.hasMatch(this);
  }
  
  // Credit card validation
  
  /// Basic credit card number validation (Luhn algorithm)
  bool get isValidCreditCard {
    if (isEmpty) return false;
    
    final cleanNumber = replaceAll(RegExp(r'\s'), '');
    if (!cleanNumber.isNumeric) return false;
    
    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }
  
  /// Detect credit card type
  String get creditCardType {
    final cleanNumber = replaceAll(RegExp(r'\s'), '');
    
    if (cleanNumber.startsWith(RegExp(r'^4'))) return 'Visa';
    if (cleanNumber.startsWith(RegExp(r'^5[1-5]'))) return 'Mastercard';
    if (cleanNumber.startsWith(RegExp(r'^3[47]'))) return 'American Express';
    if (cleanNumber.startsWith(RegExp(r'^6(?:011|5)'))) return 'Discover';
    
    return 'Unknown';
  }
  
  // Social Security Number validation
  
  /// US SSN validation
  bool get isValidSSN {
    final ssnRegex = RegExp(r'^(?!000)(?!666)(?!9)\d{3}-?(?!00)\d{2}-?(?!0000)\d{4}$');
    return ssnRegex.hasMatch(this);
  }
  
  // Date validation
  
  /// Date string validation (various formats)
  bool get isValidDate {
    final dateFormats = [
      RegExp(r'^\d{4}-\d{2}-\d{2}$'), // YYYY-MM-DD
      RegExp(r'^\d{2}/\d{2}/\d{4}$'), // MM/DD/YYYY
      RegExp(r'^\d{2}-\d{2}-\d{4}$'), // MM-DD-YYYY
    ];
    
    if (!dateFormats.any((format) => format.hasMatch(this))) return false;
    
    try {
      DateTime.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // IP address validation
  
  /// IPv4 address validation
  bool get isValidIPv4 {
    final ipv4Regex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    );
    return ipv4Regex.hasMatch(this);
  }
  
  /// IPv6 address validation
  bool get isValidIPv6 {
    final ipv6Regex = RegExp(
      r'^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^::1$|^::$'
    );
    return ipv6Regex.hasMatch(this);
  }
  
  // Postal code validation
  
  /// US ZIP code validation
  bool get isValidUSZip {
    final zipRegex = RegExp(r'^\d{5}(-\d{4})?$');
    return zipRegex.hasMatch(this);
  }
  
  /// UK postal code validation
  bool get isValidUKPostcode {
    final postcodeRegex = RegExp(
      r'^[A-Z]{1,2}[0-9][A-Z0-9]?\s?[0-9][A-Z]{2}$',
      caseSensitive: false,
    );
    return postcodeRegex.hasMatch(this);
  }
  
  /// Canadian postal code validation
  bool get isValidCanadianPostcode {
    final postcodeRegex = RegExp(
      r'^[A-Z]\d[A-Z]\s?\d[A-Z]\d$',
      caseSensitive: false,
    );
    return postcodeRegex.hasMatch(this);
  }
  
  // Numeric validation
  
  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);
  
  /// Check if string is a valid integer
  bool get isValidInteger => int.tryParse(this) != null;
  
  /// Check if string is a valid double
  bool get isValidDouble => double.tryParse(this) != null;
  
  /// Check if string is a valid number in range
  bool isNumberInRange(num min, num max) {
    final number = num.tryParse(this);
    return number != null && number >= min && number <= max;
  }
  
  // Length validation
  
  /// Check minimum length
  bool hasMinLength(int minLength) => length >= minLength;
  
  /// Check maximum length
  bool hasMaxLength(int maxLength) => length <= maxLength;
  
  /// Check length is in range
  bool hasLengthInRange(int min, int max) => length >= min && length <= max;
  
  // Content validation
  
  /// Check if string contains only letters
  bool get isAlphabetic => RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  
  /// Check if string contains only letters and spaces
  bool get isAlphabeticWithSpaces => RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  
  /// Check if string contains only alphanumeric characters
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  
  /// Check if string contains only alphanumeric characters and spaces
  bool get isAlphanumericWithSpaces => RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(this);
  
  /// Check if string matches a custom pattern
  bool matchesPattern(String pattern) => RegExp(pattern).hasMatch(this);
  
  /// Check if string contains profanity (basic check)
  bool get containsProfanity {
    final profanityWords = [
      'damn', 'hell', 'crap', 'shit', 'fuck', 'bitch', 'ass', 'bastard'
    ];
    final lowerCase = toLowerCase();
    return profanityWords.any((word) => lowerCase.contains(word));
  }
  
  // File validation
  
  /// Check if string is a valid file extension
  bool get isValidFileExtension => RegExp(r'^\.[a-zA-Z0-9]+$').hasMatch(this);
  
  /// Check if string is an image file extension
  bool get isImageFileExtension {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg'];
    return imageExtensions.contains(toLowerCase());
  }
  
  /// Check if string is a video file extension
  bool get isVideoFileExtension {
    final videoExtensions = ['.mp4', '.avi', '.mov', '.wmv', '.flv', '.webm', '.mkv'];
    return videoExtensions.contains(toLowerCase());
  }
  
  /// Check if string is an audio file extension
  bool get isAudioFileExtension {
    final audioExtensions = ['.mp3', '.wav', '.aac', '.flac', '.ogg', '.wma'];
    return audioExtensions.contains(toLowerCase());
  }
  
  // Sanitization methods
  
  /// Remove all whitespace
  String get removeAllWhitespace => replaceAll(RegExp(r'\s+'), '');
  
  /// Clean phone number (remove formatting)
  String get cleanPhoneNumber => replaceAll(RegExp(r'[\s\-\(\)]'), '');
  
  /// Clean credit card number (remove spaces and hyphens)
  String get cleanCreditCardNumber => replaceAll(RegExp(r'[\s\-]'), '');
  
  /// Sanitize for filename (remove invalid characters)
  String get sanitizeForFilename => replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  
  /// Strip HTML tags
  String get stripHtml => replaceAll(RegExp(r'<[^>]*>'), '');
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  
  const ValidationResult.valid() : isValid = true, errorMessage = null;
  const ValidationResult.invalid(this.errorMessage) : isValid = false;
  
  @override
  String toString() => isValid ? 'Valid' : 'Invalid: $errorMessage';
}

/// Comprehensive validator utility class
class Validator {
  /// Validate multiple conditions
  static ValidationResult validateAll(String value, List<ValidationRule> rules) {
    for (final rule in rules) {
      final result = rule.validate(value);
      if (!result.isValid) {
        return result;
      }
    }
    return const ValidationResult.valid();
  }
  
  /// Create a composite validator
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
  
  /// Common validator functions for use with TextFormField
  
  static String? required(String? value, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }
  
  static String? email(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (!value.isValidEmail) {
      return message ?? 'Please enter a valid email address';
    }
    return null;
  }
  
  static String? Function(String?) minLength(int length) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < length) {
        return 'Must be at least $length characters long';
      }
      return null;
    };
  }
  
  static String? Function(String?) maxLength(int length) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > length) {
        return 'Must be no more than $length characters long';
      }
      return null;
    };
  }
  
  static String? strongPassword(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (!value.isStrongPassword) {
      return message ?? 'Password must contain at least 8 characters with uppercase, lowercase, numbers and special characters';
    }
    return null;
  }
  
  static String? phone(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (!value.isValidPhone) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  }
  
  static String? numeric(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (!value.isValidDouble) {
      return message ?? 'Please enter a valid number';
    }
    return null;
  }
  
  static String? Function(String?) range(num min, num max) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final number = num.tryParse(value);
      if (number == null) return 'Please enter a valid number';
      if (number < min || number > max) {
        return 'Must be between $min and $max';
      }
      return null;
    };
  }
}

/// Abstract base class for validation rules
abstract class ValidationRule {
  ValidationResult validate(String value);
}

/// Required field validation rule
class RequiredRule implements ValidationRule {
  final String? message;
  
  const RequiredRule([this.message]);
  
  @override
  ValidationResult validate(String value) {
    if (value.trim().isEmpty) {
      return ValidationResult.invalid(message ?? 'This field is required');
    }
    return const ValidationResult.valid();
  }
}

/// Email validation rule
class EmailRule implements ValidationRule {
  final String? message;
  
  const EmailRule([this.message]);
  
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) return const ValidationResult.valid();
    if (!value.isValidEmail) {
      return ValidationResult.invalid(message ?? 'Please enter a valid email address');
    }
    return const ValidationResult.valid();
  }
}

/// Minimum length validation rule
class MinLengthRule implements ValidationRule {
  final int minLength;
  final String? message;
  
  const MinLengthRule(this.minLength, [this.message]);
  
  @override
  ValidationResult validate(String value) {
    if (value.length < minLength) {
      return ValidationResult.invalid(message ?? 'Must be at least $minLength characters long');
    }
    return const ValidationResult.valid();
  }
}

/// Pattern matching validation rule
class PatternRule implements ValidationRule {
  final RegExp pattern;
  final String message;
  
  const PatternRule(this.pattern, this.message);
  
  @override
  ValidationResult validate(String value) {
    if (!pattern.hasMatch(value)) {
      return ValidationResult.invalid(message);
    }
    return const ValidationResult.valid();
  }
}