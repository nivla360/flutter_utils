import 'package:flutter/foundation.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/services/example_services.dart';

/// Demonstrates form handling with AsyncController for submissions
class FormController extends AsyncController<bool> {
  final MockApiService _apiService = GetIt.instance<MockApiService>();
  
  // Form data
  final Map<String, dynamic> _formData = {};
  final Map<String, String> _errors = {};
  bool _isFormValid = false;
  
  Map<String, dynamic> get formData => Map.from(_formData);
  Map<String, String> get errors => Map.from(_errors);
  bool get isFormValid => _isFormValid;
  
  /// Update form field value
  void updateField(String fieldName, dynamic value) {
    _formData[fieldName] = value;
    _validateField(fieldName, value);
    _updateFormValidity();
    notifyListeners();
  }
  
  /// Get field value
  T? getFieldValue<T>(String fieldName) {
    return _formData[fieldName] as T?;
  }
  
  /// Get field error
  String? getFieldError(String fieldName) {
    return _errors[fieldName];
  }
  
  /// Validate specific field
  void _validateField(String fieldName, dynamic value) {
    switch (fieldName) {
      case 'firstName':
        if (value == null || (value as String).isEmpty) {
          _errors[fieldName] = 'First name is required';
        } else if ((value as String).length < 2) {
          _errors[fieldName] = 'First name must be at least 2 characters';
        } else {
          _errors.remove(fieldName);
        }
        break;
        
      case 'lastName':
        if (value == null || (value as String).isEmpty) {
          _errors[fieldName] = 'Last name is required';
        } else if ((value as String).length < 2) {
          _errors[fieldName] = 'Last name must be at least 2 characters';
        } else {
          _errors.remove(fieldName);
        }
        break;
        
      case 'email':
        if (value == null || (value as String).isEmpty) {
          _errors[fieldName] = 'Email is required';
        } else if (!_isValidEmail(value as String)) {
          _errors[fieldName] = 'Please enter a valid email address';
        } else {
          _errors.remove(fieldName);
        }
        break;
        
      case 'phone':
        if (value != null && (value as String).isNotEmpty) {
          if (!_isValidPhone(value as String)) {
            _errors[fieldName] = 'Please enter a valid phone number';
          } else {
            _errors.remove(fieldName);
          }
        } else {
          _errors.remove(fieldName);
        }
        break;
        
      case 'age':
        if (value == null || (value as String).isEmpty) {
          _errors[fieldName] = 'Age is required';
        } else {
          final age = int.tryParse(value as String);
          if (age == null) {
            _errors[fieldName] = 'Please enter a valid number';
          } else if (age < 18) {
            _errors[fieldName] = 'Must be 18 or older';
          } else if (age > 120) {
            _errors[fieldName] = 'Please enter a valid age';
          } else {
            _errors.remove(fieldName);
          }
        }
        break;
        
      case 'password':
        if (value == null || (value as String).isEmpty) {
          _errors[fieldName] = 'Password is required';
        } else if ((value as String).length < 8) {
          _errors[fieldName] = 'Password must be at least 8 characters';
        } else if (!_isStrongPassword(value as String)) {
          _errors[fieldName] = 'Password must contain uppercase, lowercase, number, and special character';
        } else {
          _errors.remove(fieldName);
        }
        break;
        
      case 'confirmPassword':
        final password = _formData['password'] as String?;
        if (value == null || (value as String).isEmpty) {
          _errors[fieldName] = 'Please confirm your password';
        } else if (value != password) {
          _errors[fieldName] = 'Passwords do not match';
        } else {
          _errors.remove(fieldName);
        }
        break;
        
      case 'termsAccepted':
        if (value != true) {
          _errors[fieldName] = 'You must accept the terms and conditions';
        } else {
          _errors.remove(fieldName);
        }
        break;
    }
  }
  
  /// Update overall form validity
  void _updateFormValidity() {
    _isFormValid = _errors.isEmpty && _hasRequiredFields();
  }
  
  /// Check if all required fields are present
  bool _hasRequiredFields() {
    final requiredFields = ['firstName', 'lastName', 'email', 'age', 'password', 'confirmPassword'];
    return requiredFields.every((field) => 
      _formData.containsKey(field) && 
      _formData[field] != null && 
      _formData[field].toString().isNotEmpty
    );
  }
  
  /// Submit form
  Future<void> submitForm() async {
    // Validate all fields before submission
    _validateAllFields();
    _updateFormValidity();
    
    if (!_isFormValid) {
      // Don't submit if form is invalid
      notifyListeners();
      return;
    }
    
    await executeAsync(
      () async {
        final success = await _apiService.submitForm(_formData);
        return success;
      },
      onSuccess: (success) {
        if (kDebugMode) {
          print('✅ Form submitted successfully');
        }
        // Clear form after successful submission
        clearForm();
      },
      onError: (error, stackTrace) {
        if (kDebugMode) {
          print('❌ Form submission failed: $error');
        }
      },
    );
  }
  
  /// Validate all current fields
  void _validateAllFields() {
    for (final entry in _formData.entries) {
      _validateField(entry.key, entry.value);
    }
  }
  
  /// Clear form data
  void clearForm() {
    _formData.clear();
    _errors.clear();
    _isFormValid = false;
    reset(); // Reset async state
  }
  
  /// Set multiple form values at once
  void setFormData(Map<String, dynamic> data) {
    _formData.clear();
    _formData.addAll(data);
    
    // Validate all new data
    for (final entry in data.entries) {
      _validateField(entry.key, entry.value);
    }
    
    _updateFormValidity();
    notifyListeners();
  }
  
  /// Get form summary for review
  Map<String, String> getFormSummary() {
    return {
      'Name': '${_formData['firstName'] ?? ''} ${_formData['lastName'] ?? ''}',
      'Email': _formData['email']?.toString() ?? '',
      'Phone': _formData['phone']?.toString() ?? 'Not provided',
      'Age': _formData['age']?.toString() ?? '',
      'Terms Accepted': (_formData['termsAccepted'] == true) ? 'Yes' : 'No',
    };
  }
  
  // Validation helper methods
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  bool _isValidPhone(String phone) {
    // Simple phone validation - adjust based on your requirements
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }
  
  bool _isStrongPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(password);
  }
}