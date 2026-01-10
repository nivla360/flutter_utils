import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Form field configuration
class FormFieldConfig {
  final String key;
  final String label;
  final String? hintText;
  final String? helperText;
  final FormFieldType type;
  final bool required;
  final List<FormValidator> validators;
  final dynamic initialValue;
  final Map<String, dynamic>? options;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool enabled;

  const FormFieldConfig({
    required this.key,
    required this.label,
    required this.type,
    this.hintText,
    this.helperText,
    this.required = false,
    this.validators = const [],
    this.initialValue,
    this.options,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines,
    this.maxLength,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.enabled = true,
  });
}

/// Form field types
enum FormFieldType {
  text,
  email,
  password,
  number,
  phone,
  multiline,
  dropdown,
  checkbox,
  radio,
  date,
  time,
  dateTime,
  slider,
  switch_,
  chips,
}

/// Form validation rules
abstract class FormValidator {
  String get errorMessage;
  bool isValid(dynamic value);
}

/// Built-in validators
class RequiredValidator extends FormValidator {
  @override
  String get errorMessage => 'This field is required';

  @override
  bool isValid(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    if (value is List) return value.isNotEmpty;
    return true;
  }
}

class EmailValidator extends FormValidator {
  @override
  String get errorMessage => 'Please enter a valid email address';

  @override
  bool isValid(dynamic value) {
    if (value == null || value is! String) return false;
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(value);
  }
}

class MinLengthValidator extends FormValidator {
  final int minLength;

  MinLengthValidator(this.minLength);

  @override
  String get errorMessage => 'Must be at least $minLength characters long';

  @override
  bool isValid(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.length >= minLength;
    return false;
  }
}

class MaxLengthValidator extends FormValidator {
  final int maxLength;

  MaxLengthValidator(this.maxLength);

  @override
  String get errorMessage => 'Must be no more than $maxLength characters long';

  @override
  bool isValid(dynamic value) {
    if (value == null) return true; // null is valid for max length
    if (value is String) return value.length <= maxLength;
    return false;
  }
}

class NumberRangeValidator extends FormValidator {
  final num? min;
  final num? max;

  NumberRangeValidator({this.min, this.max});

  @override
  String get errorMessage {
    if (min != null && max != null) {
      return 'Must be between $min and $max';
    } else if (min != null) {
      return 'Must be at least $min';
    } else if (max != null) {
      return 'Must be at most $max';
    }
    return 'Invalid number';
  }

  @override
  bool isValid(dynamic value) {
    if (value == null) return true;
    
    num? numValue;
    if (value is num) {
      numValue = value;
    } else if (value is String) {
      numValue = num.tryParse(value);
    }
    
    if (numValue == null) return false;
    
    if (min != null && numValue < min!) return false;
    if (max != null && numValue > max!) return false;
    
    return true;
  }
}

class PhoneValidator extends FormValidator {
  @override
  String get errorMessage => 'Please enter a valid phone number';

  @override
  bool isValid(dynamic value) {
    if (value == null || value is! String) return false;
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(value);
  }
}

/// Smart form builder widget
class SmartFormBuilder extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final Map<String, dynamic>? initialValues;
  final void Function(Map<String, dynamic> values)? onChanged;
  final void Function(Map<String, dynamic> values)? onSubmit;
  final String? submitButtonText;
  final bool showSubmitButton;
  final EdgeInsetsGeometry? padding;
  final double fieldSpacing;
  final bool autovalidateMode;

  const SmartFormBuilder({
    super.key,
    required this.fields,
    this.initialValues,
    this.onChanged,
    this.onSubmit,
    this.submitButtonText,
    this.showSubmitButton = false,
    this.padding,
    this.fieldSpacing = 16.0,
    this.autovalidateMode = false,
  });

  @override
  State<SmartFormBuilder> createState() => _SmartFormBuilderState();
}

class _SmartFormBuilderState extends State<SmartFormBuilder> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    for (final field in widget.fields) {
      _values[field.key] = widget.initialValues?[field.key] ?? field.initialValue;
    }
  }

  void _updateValue(String key, dynamic value) {
    setState(() {
      _values[key] = value;
      if (widget.autovalidateMode) {
        _validateField(key, value);
      }
    });
    widget.onChanged?.call(_values);
  }

  String? _validateField(String key, dynamic value) {
    final field = widget.fields.firstWhere((f) => f.key == key);
    
    if (field.required && (value == null || (value is String && value.trim().isEmpty))) {
      return 'This field is required';
    }

    for (final validator in field.validators) {
      if (!validator.isValid(value)) {
        return validator.errorMessage;
      }
    }

    return null;
  }

  bool _validateForm() {
    bool isValid = true;
    final newErrors = <String, String?>{};

    for (final field in widget.fields) {
      final error = _validateField(field.key, _values[field.key]);
      newErrors[field.key] = error;
      if (error != null) isValid = false;
    }

    setState(() {
      _errors.clear();
      _errors.addAll(newErrors);
    });

    return isValid;
  }

  void _handleSubmit() {
    if (_validateForm()) {
      widget.onSubmit?.call(_values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.fields.map((field) => _buildField(field)),
            if (widget.showSubmitButton) ...[
              SizedBox(height: widget.fieldSpacing),
              _buildSubmitButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildField(FormFieldConfig field) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.fieldSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(field),
          const SizedBox(height: 8),
          _buildFieldWidget(field),
          if (field.helperText != null || _errors[field.key] != null)
            const SizedBox(height: 4),
          if (_errors[field.key] != null)
            Text(
              _errors[field.key]!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            )
          else if (field.helperText != null)
            Text(
              field.helperText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(FormFieldConfig field) {
    return RichText(
      text: TextSpan(
        text: field.label,
        style: Theme.of(context).textTheme.labelLarge,
        children: [
          if (field.required)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFieldWidget(FormFieldConfig field) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.password:
      case FormFieldType.number:
      case FormFieldType.phone:
        return _buildTextFormField(field);
      case FormFieldType.multiline:
        return _buildMultilineField(field);
      case FormFieldType.dropdown:
        return _buildDropdownField(field);
      case FormFieldType.checkbox:
        return _buildCheckboxField(field);
      case FormFieldType.radio:
        return _buildRadioField(field);
      case FormFieldType.date:
      case FormFieldType.time:
      case FormFieldType.dateTime:
        return _buildDateTimeField(field);
      case FormFieldType.slider:
        return _buildSliderField(field);
      case FormFieldType.switch_:
        return _buildSwitchField(field);
      case FormFieldType.chips:
        return _buildChipsField(field);
    }
  }

  Widget _buildTextFormField(FormFieldConfig field) {
    return TextFormField(
      initialValue: _values[field.key]?.toString(),
      decoration: InputDecoration(
        hintText: field.hintText,
        prefixIcon: field.prefixIcon,
        suffixIcon: field.suffixIcon,
        border: const OutlineInputBorder(),
        errorText: _errors[field.key],
      ),
      keyboardType: field.keyboardType ?? _getKeyboardType(field.type),
      inputFormatters: field.inputFormatters,
      maxLines: field.maxLines ?? 1,
      maxLength: field.maxLength,
      obscureText: field.obscureText,
      enabled: field.enabled,
      onTap: field.onTap,
      onChanged: (value) => _updateValue(field.key, value),
    );
  }

  Widget _buildMultilineField(FormFieldConfig field) {
    return TextFormField(
      initialValue: _values[field.key]?.toString(),
      decoration: InputDecoration(
        hintText: field.hintText,
        border: const OutlineInputBorder(),
        errorText: _errors[field.key],
      ),
      maxLines: field.maxLines ?? 3,
      maxLength: field.maxLength,
      enabled: field.enabled,
      onChanged: (value) => _updateValue(field.key, value),
    );
  }

  Widget _buildDropdownField(FormFieldConfig field) {
    final options = field.options?['options'] as List<dynamic>? ?? [];
    
    return DropdownButtonFormField<dynamic>(
      value: _values[field.key],
      decoration: InputDecoration(
        hintText: field.hintText,
        border: const OutlineInputBorder(),
        errorText: _errors[field.key],
      ),
      items: options.map((option) {
        final value = option is Map ? option['value'] : option;
        final label = option is Map ? option['label'] : option.toString();
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(label),
        );
      }).toList(),
      onChanged: field.enabled ? (value) => _updateValue(field.key, value) : null,
    );
  }

  Widget _buildCheckboxField(FormFieldConfig field) {
    return CheckboxListTile(
      title: Text(field.label),
      value: _values[field.key] ?? false,
      onChanged: field.enabled 
        ? (value) => _updateValue(field.key, value ?? false)
        : null,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildRadioField(FormFieldConfig field) {
    final options = field.options?['options'] as List<dynamic>? ?? [];
    
    return Column(
      children: options.map((option) {
        final value = option is Map ? option['value'] : option;
        final label = option is Map ? option['label'] : option.toString();
        
        return RadioListTile<dynamic>(
          title: Text(label),
          value: value,
          groupValue: _values[field.key],
          onChanged: field.enabled 
            ? (selectedValue) => _updateValue(field.key, selectedValue)
            : null,
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeField(FormFieldConfig field) {
    return TextFormField(
      initialValue: _values[field.key]?.toString(),
      decoration: InputDecoration(
        hintText: field.hintText,
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
        errorText: _errors[field.key],
      ),
      readOnly: true,
      enabled: field.enabled,
      onTap: field.enabled ? () => _selectDateTime(field) : null,
    );
  }

  Widget _buildSliderField(FormFieldConfig field) {
    final min = field.options?['min']?.toDouble() ?? 0.0;
    final max = field.options?['max']?.toDouble() ?? 100.0;
    final divisions = field.options?['divisions'] as int?;
    
    return Slider(
      value: (_values[field.key]?.toDouble() ?? min).clamp(min, max),
      min: min,
      max: max,
      divisions: divisions,
      label: _values[field.key]?.toString(),
      onChanged: field.enabled 
        ? (value) => _updateValue(field.key, value)
        : null,
    );
  }

  Widget _buildSwitchField(FormFieldConfig field) {
    return SwitchListTile(
      title: Text(field.label),
      value: _values[field.key] ?? false,
      onChanged: field.enabled 
        ? (value) => _updateValue(field.key, value)
        : null,
    );
  }

  Widget _buildChipsField(FormFieldConfig field) {
    final options = field.options?['options'] as List<dynamic>? ?? [];
    final selected = _values[field.key] as List<dynamic>? ?? [];
    
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: options.map((option) {
        final value = option is Map ? option['value'] : option;
        final label = option is Map ? option['label'] : option.toString();
        final isSelected = selected.contains(value);
        
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: field.enabled ? (selected) {
            final newSelected = List.from(_values[field.key] ?? []);
            if (selected) {
              newSelected.add(value);
            } else {
              newSelected.remove(value);
            }
            _updateValue(field.key, newSelected);
          } : null,
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        child: Text(widget.submitButtonText ?? 'Submit'),
      ),
    );
  }

  TextInputType _getKeyboardType(FormFieldType type) {
    switch (type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.number:
        return TextInputType.number;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  Future<void> _selectDateTime(FormFieldConfig field) async {
    final now = DateTime.now();
    
    switch (field.type) {
      case FormFieldType.date:
        final date = await showDatePicker(
          context: context,
          initialDate: _values[field.key] ?? now,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          _updateValue(field.key, date);
        }
        break;
        
      case FormFieldType.time:
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_values[field.key] ?? now),
        );
        if (time != null) {
          _updateValue(field.key, time);
        }
        break;
        
      case FormFieldType.dateTime:
        final date = await showDatePicker(
          context: context,
          initialDate: _values[field.key] ?? now,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          if (!mounted) return;
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_values[field.key] ?? now),
          );
          if (time != null) {
            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _updateValue(field.key, dateTime);
          }
        }
        break;
        
      default:
        break;
    }
  }
}