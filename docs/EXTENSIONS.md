# Extensions Guide

Flutter Utils provides powerful extensions that eliminate repetitive code patterns and add convenient utilities to built-in Dart and Flutter types.

## Table of Contents

- [DateTime Extensions](#datetime-extensions)
- [String Extensions](#string-extensions)
- [Validation Extensions](#validation-extensions)
- [Widget Extensions](#widget-extensions)
- [Number Extensions](#number-extensions)
- [Collection Extensions](#collection-extensions)
- [Color Extensions](#color-extensions)
- [Context Extensions](#context-extensions)

## DateTime Extensions

50+ utilities for date operations that eliminate the need for external date libraries in most cases.

### Smart Formatting

```dart
final now = DateTime.now();
final yesterday = DateTime.now().subtract(Duration(days: 1));
final lastWeek = DateTime.now().subtract(Duration(days: 7));

// Smart relative formatting
print(now.smart);           // "Just now"
print(yesterday.smart);     // "Yesterday 3:30 PM"
print(lastWeek.smart);      // "Jan 15, 2024"

// Different time ranges use different formats automatically
final twoHoursAgo = DateTime.now().subtract(Duration(hours: 2));
print(twoHoursAgo.smart);   // "2 hours ago"

final nextWeek = DateTime.now().add(Duration(days: 7));
print(nextWeek.smart);      // "Next Monday"
```

### Date Checking

```dart
final date = DateTime.now();

// Quick date checks
print(date.isToday);        // true
print(date.isYesterday);    // false
print(date.isTomorrow);     // false
print(date.isThisWeek);     // true
print(date.isThisMonth);    // true
print(date.isThisYear);     // true

// Day of week checks
print(date.isWeekend);      // true/false
print(date.isWeekday);      // true/false
print(date.isMonday);       // true/false
print(date.isFriday);       // true/false

// Time checks
print(date.isMorning);      // 6 AM - 12 PM
print(date.isAfternoon);    // 12 PM - 6 PM
print(date.isEvening);      // 6 PM - 10 PM
print(date.isNight);        // 10 PM - 6 AM
```

### Date Calculations

```dart
final date = DateTime(2024, 1, 15); // Monday

// Start and end of periods
print(date.startOfDay);     // 2024-01-15 00:00:00
print(date.endOfDay);       // 2024-01-15 23:59:59
print(date.startOfWeek);    // 2024-01-15 (Monday)
print(date.endOfWeek);      // 2024-01-21 (Sunday)
print(date.startOfMonth);   // 2024-01-01
print(date.endOfMonth);     // 2024-01-31
print(date.startOfYear);    // 2024-01-01
print(date.endOfYear);      // 2024-12-31

// Business day calculations
print(date.nextBusinessDay);     // Next weekday (skips weekends)
print(date.previousBusinessDay); // Previous weekday
print(date.addBusinessDays(5));  // Add 5 business days

// Week calculations
print(date.weekOfYear);     // 3 (third week of year)
print(date.weekOfMonth);    // 3 (third week of month)
print(date.daysInMonth);    // 31
```

### Time Operations

```dart
final date = DateTime.now();

// Time only operations
print(date.timeOnly);       // "14:30:45"
print(date.time12Hour);     // "2:30 PM"
print(date.time24Hour);     // "14:30"

// Time with date
print(date.dateTimeShort);  // "Jan 15, 2:30 PM"
print(date.dateTimeFull);   // "Monday, January 15, 2024 at 2:30 PM"

// Age calculations
final birthDate = DateTime(1990, 5, 15);
print(birthDate.ageInYears);    // 34
print(birthDate.ageInMonths);   // 408
print(birthDate.ageInDays);     // 12,419
```

### Formatting Options

```dart
final date = DateTime(2024, 1, 15, 14, 30, 45);

// Standard formats
print(date.toIso8601String());  // "2024-01-15T14:30:45.000"
print(date.toLocal().toString()); // System default format

// Custom formats (no external library needed)
print(date.format('yyyy-MM-dd'));        // "2024-01-15"
print(date.format('MMM dd, yyyy'));      // "Jan 15, 2024"
print(date.format('EEEE, MMMM dd'));     // "Monday, January 15"
print(date.format('h:mm a'));            // "2:30 PM"
print(date.format('yyyy-MM-dd HH:mm'));  // "2024-01-15 14:30"
```

### Comparison Utilities

```dart
final date1 = DateTime(2024, 1, 15);
final date2 = DateTime(2024, 1, 20);

// Date-only comparisons (ignores time)
print(date1.isSameDayAs(date2));    // false
print(date1.isBeforeDay(date2));    // true
print(date1.isAfterDay(date2));     // false

// Time-aware comparisons
print(date1.isBetween(
  DateTime(2024, 1, 10),
  DateTime(2024, 1, 20),
)); // true

// Difference calculations
print(date2.daysDifference(date1)); // 5
print(date2.hoursDifference(date1)); // 120
print(date2.minutesDifference(date1)); // 7200
```

## String Extensions

Comprehensive string utilities for common operations.

### Text Processing

```dart
final text = "  hello world  ";

// Case conversions
print(text.titleCase);      // "Hello World"
print(text.sentenceCase);   // "Hello world"
print(text.camelCase);      // "helloWorld"
print(text.pascalCase);     // "HelloWorld"
print(text.snakeCase);      // "hello_world"
print(text.kebabCase);      // "hello-world"

// Cleaning
print(text.cleaned);        // "hello world" (trimmed)
print(text.removeSpaces);   // "helloworld"
print(text.removeNumbers);  // "hello world"
print(text.removeSpecialChars); // "hello world"
```

### Validation Helpers

```dart
final input = "user@example.com";

// Quick checks
print(input.isNotEmpty);    // true (better than !isEmpty)
print(input.hasContent);    // true (not empty and not just whitespace)
print(input.isNumeric);     // false
print(input.isAlphabetic);  // false
print(input.isAlphanumeric); // false

// Length checks
print(input.hasMinLength(5));   // true
print(input.hasMaxLength(50));  // true
print(input.isBetweenLength(10, 30)); // true
```

### Text Formatting

```dart
final name = "john doe";
final price = "1234.56";
final phone = "1234567890";

// Formatting
print(name.capitalize);         // "John doe"
print(name.capitalizeWords);    // "John Doe"
print(price.toCurrency());      // "\$1,234.56"
print(phone.formatAsPhone());   // "(123) 456-7890"

// Truncation
print("Long text here".truncate(10));           // "Long te..."
print("Long text here".truncateWords(2));       // "Long text..."
print("Long text here".truncateMiddle(10));     // "Lon...ere"
```

### Color and HTML

```dart
// Color conversions
final hexColor = "#FF5733";
print(hexColor.toColor());      // Color(0xFFFF5733)
print(hexColor.toColorOrNull()); // Color or null if invalid

final colorName = "red";
print(colorName.toColor());     // Colors.red

// HTML utilities
final html = "<p>Hello <b>world</b></p>";
print(html.stripHtml);          // "Hello world"
print(html.decodeHtml);         // Decodes HTML entities
```

### Utility Methods

```dart
final text = "Hello World";

// Manipulation
print(text.reverse);            // "dlroW olleH"
print(text.shuffle);            // Random character order
print(text.repeat(3));          // "Hello WorldHello WorldHello World"

// Analysis
print(text.wordCount);          // 2
print(text.characterCount);     // 11
print(text.vowelCount);         // 3
print(text.consonantCount);     // 7

// Searching
print(text.containsIgnoreCase("HELLO")); // true
print(text.startsWithIgnoreCase("hello")); // true
print(text.endsWithIgnoreCase("WORLD")); // true
```

## Validation Extensions

Comprehensive validation for forms and user input.

### Email Validation

```dart
final email = "user@example.com";

// Basic validation
print(email.isValidEmail);      // true

// Advanced email validation
print(email.isBusinessEmail);   // true (not gmail, yahoo, etc.)
print(email.isDisposableEmail); // false (not temp email service)
print(email.emailDomain);       // "example.com"
print(email.emailUsername);     // "user"
```

### Password Validation

```dart
final password = "MyPassword123!";

// Strength checking
print(password.isStrongPassword);   // true
print(password.isWeakPassword);     // false
print(password.passwordStrength);   // PasswordStrength.strong

// Requirements checking
print(password.hasMinLength(8));    // true
print(password.hasUppercase);       // true
print(password.hasLowercase);       // true
print(password.hasNumbers);         // true
print(password.hasSpecialChars);    // true

// Password score (0-100)
print(password.passwordScore);      // 85
```

### Phone Number Validation

```dart
final phone = "+1234567890";

// Validation
print(phone.isValidPhone);          // true
print(phone.isValidUSPhone);        // true
print(phone.isValidInternationalPhone); // true

// Formatting
print(phone.formatPhone());         // "(123) 456-7890"
print(phone.formatInternationalPhone()); // "+1 123 456 7890"

// Analysis
print(phone.phoneCountryCode);      // "+1"
print(phone.phoneAreaCode);         // "123"
print(phone.phoneDigitsOnly);       // "1234567890"
```

### Credit Card Validation

```dart
final cardNumber = "4532123456789012";

// Validation
print(cardNumber.isValidCreditCard);    // true
print(cardNumber.creditCardType);       // CreditCardType.visa

// Formatting
print(cardNumber.formatCreditCard());   // "4532 1234 5678 9012"
print(cardNumber.maskCreditCard());     // "**** **** **** 9012"

// Luhn algorithm check
print(cardNumber.passesLuhnCheck);      // true
```

### Other Validations

```dart
// Social Security Number (US)
final ssn = "123456789";
print(ssn.isValidSSN);              // true
print(ssn.formatSSN());             // "123-45-6789"

// IP Address
final ip = "192.168.1.1";
print(ip.isValidIPv4);              // true
print(ip.isValidIPv6);              // false
print(ip.isPrivateIP);              // true

// URL validation
final url = "https://example.com";
print(url.isValidUrl);              // true
print(url.isHttpsUrl);              // true
print(url.urlDomain);               // "example.com"

// File extensions
final filename = "document.pdf";
print(filename.fileExtension);      // "pdf"
print(filename.isImageFile);        // false
print(filename.isDocumentFile);     // true
```

## Widget Extensions

Convenient widget styling and behavior shortcuts.

### Padding Extensions

```dart
Text('Hello World')
  .paddingAll(16)                    // Padding.all(16)
  .paddingHorizontal(20)             // Padding.symmetric(horizontal: 20)
  .paddingVertical(10)               // Padding.symmetric(vertical: 10)
  .paddingOnly(left: 8, right: 12)   // Padding.only(...)
  .paddingLTRB(8, 4, 8, 4)          // Padding.fromLTRB(8, 4, 8, 4)
```

### Margin Extensions

```dart
Container(child: Text('Hello'))
  .marginAll(16)
  .marginHorizontal(20)
  .marginVertical(10)
  .marginOnly(top: 8, bottom: 12)
```

### Alignment Extensions

```dart
Text('Centered')
  .center()                         // Center widget
  .centerLeft()                     // Align.centerLeft
  .centerRight()                    // Align.centerRight
  .topCenter()                      // Align.topCenter
  .bottomCenter()                   // Align.bottomCenter
```

### Sizing Extensions

```dart
Container()
  .size(100, 100)                   // SizedBox(width: 100, height: 100)
  .width(200)                       // SizedBox(width: 200)
  .height(150)                      // SizedBox(height: 150)
  .square(50)                       // SizedBox(width: 50, height: 50)
  .expanded()                       // Expanded widget
  .flexible()                       // Flexible widget
```

### Gesture Extensions

```dart
Container()
  .onTap(() => print('Tapped'))     // GestureDetector with onTap
  .onDoubleTap(() => print('Double tapped'))
  .onLongPress(() => print('Long pressed'))
  .onPanUpdate((details) => print('Panning'))
```

### Visual Extensions

```dart
Container()
  .rounded(12)                      // BorderRadius.circular(12)
  .roundedOnly(topLeft: 8, topRight: 8)
  .bordered(color: Colors.grey, width: 2)
  .shadow(elevation: 4, color: Colors.black26)
  .opacity(0.5)                     // Opacity widget
  .rotate(45)                       // Transform.rotate
  .scale(1.5)                       // Transform.scale
```

### Layout Extensions

```dart
// Column shortcuts
[
  Text('Item 1'),
  Text('Item 2'),
  Text('Item 3'),
].toColumn(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
)

// Row shortcuts
[
  Icon(Icons.star),
  Text('Rating'),
].toRow(spacing: 8)

// Wrap shortcuts
[
  Chip(label: Text('Tag 1')),
  Chip(label: Text('Tag 2')),
].toWrap(spacing: 8, runSpacing: 4)
```

### Animation Extensions

```dart
Container()
  .fadeIn(duration: Duration(milliseconds: 500))
  .slideIn(direction: SlideDirection.left)
  .scaleIn(delay: Duration(milliseconds: 200))
  .animate()                        // Basic animation wrapper
```

## Number Extensions

Helpful utilities for numeric operations.

### Formatting

```dart
final number = 1234.567;

// Currency formatting
print(number.toCurrency());         // "\$1,234.57"
print(number.toCurrency(symbol: '€')); // "€1,234.57"
print(number.toCurrency(locale: 'de')); // "1.234,57 €"

// Percentage
print(0.25.toPercentage());         // "25%"
print(0.1234.toPercentage(decimals: 2)); // "12.34%"

// Number formatting
print(number.toFormatted());        // "1,234.567"
print(number.toFixed(2));           // "1234.57"
print(number.toPrecision(5));       // "1234.6"
```

### Ranges and Clamping

```dart
final value = 15;

// Range checking
print(value.isBetween(10, 20));     // true
print(value.isInRange(10, 20));     // true (inclusive)

// Clamping
print(25.clamp(10, 20));            // 20
print(5.clamp(10, 20));             // 10

// Mapping ranges
print(value.mapRange(0, 100, 0, 1)); // 0.15 (maps 15 from 0-100 to 0-1)
```

### Math Operations

```dart
final number = 16;

// Powers and roots
print(number.squared);              // 256
print(number.cubed);               // 4096
print(number.sqrt);                // 4.0
print(number.cbrt);                // 2.52 (cube root)

// Rounding
print(15.7.roundToNearest(5));     // 15
print(17.3.roundToNearest(5));     // 20
print(123.456.roundToDecimal(2));  // 123.46
```

## Collection Extensions

Enhanced collection operations.

### List Extensions

```dart
final numbers = [1, 2, 3, 4, 5];
final names = ['Alice', 'Bob', 'Charlie'];

// Safe operations
print(numbers.safeFirst);           // 1 (null if empty)
print(numbers.safeLast);            // 5
print(numbers.safeElementAt(10));   // null (instead of error)

// Chunking
print(numbers.chunk(2));            // [[1, 2], [3, 4], [5]]
print(names.splitBy(2));            // [['Alice', 'Bob'], ['Charlie']]

// Filtering
print(numbers.whereNotNull());      // Removes null values
print(numbers.whereType<int>());    // Type-safe filtering
print(numbers.distinct());          // Remove duplicates

// Statistics
print(numbers.sum);                 // 15
print(numbers.average);             // 3.0
print(numbers.max);                 // 5
print(numbers.min);                 // 1
```

### Map Extensions

```dart
final map = {'a': 1, 'b': 2, 'c': 3};

// Safe operations
print(map.safeGet('d'));            // null (instead of error)
print(map.getOrDefault('d', 0));    // 0

// Filtering
final filtered = map.whereKeys((key) => key != 'b');
final values = map.whereValues((value) => value > 1);

// Transformation
final swapped = map.swapKeysValues(); // {1: 'a', 2: 'b', 3: 'c'}
```

## Color Extensions

Color manipulation and utilities.

### Color Analysis

```dart
final color = Colors.blue;

// Properties
print(color.brightness);            // Brightness.dark/light
print(color.isLight);               // false
print(color.isDark);                // true
print(color.luminance);             // 0.0-1.0

// Hex conversion
print(color.toHex());               // "#2196F3"
print(color.toHexWithAlpha());      // "#FF2196F3"
```

### Color Manipulation

```dart
final color = Colors.red;

// Lightening/Darkening
print(color.lighten(0.2));          // 20% lighter
print(color.darken(0.3));           // 30% darker
print(color.brighten(0.1));         // 10% brighter

// Saturation
print(color.saturate(0.2));         // More saturated
print(color.desaturate(0.2));       // Less saturated

// Transparency
print(color.withOpacity(0.5));      // 50% opacity
print(color.withAlpha(128));        // Alpha value 0-255
```

### Color Harmony

```dart
final baseColor = Colors.blue;

// Color schemes
print(baseColor.complementary);     // Opposite on color wheel
print(baseColor.analogous);         // Adjacent colors
print(baseColor.triadic);           // Triadic color scheme
print(baseColor.splitComplementary); // Split complementary

// Tints and shades
print(baseColor.tint(0.3));         // Mix with white
print(baseColor.shade(0.3));        // Mix with black
print(baseColor.tone(0.3));         // Mix with gray
```

## Context Extensions

BuildContext utilities for cleaner code.

### Theme Access

```dart
// In a Widget's build method
Widget build(BuildContext context) {
  return Container(
    color: context.primaryColor,       // Theme.of(context).primaryColor
    child: Text(
      'Hello',
      style: context.textTheme.headlineMedium, // Theme.of(context).textTheme...
    ),
  );
}

// Color shortcuts
context.primaryColor
context.accentColor
context.backgroundColor
context.errorColor
context.surfaceColor

// Text theme shortcuts
context.textTheme.displayLarge
context.textTheme.headlineMedium
context.textTheme.bodyLarge
context.textTheme.labelSmall
```

### Screen Information

```dart
// Screen dimensions
context.screenWidth               // MediaQuery width
context.screenHeight             // MediaQuery height
context.screenSize               // Size object
context.orientation              // Portrait/Landscape

// Safe area
context.safeAreaTop
context.safeAreaBottom
context.safeAreaLeft
context.safeAreaRight

// Responsive helpers
context.isTablet                 // Width > 768
context.isDesktop                // Width > 1200
context.isMobile                 // Width <= 768
```

### Navigation Shortcuts

```dart
// Navigation
context.push('/next-page')        // Navigator.of(context).pushNamed
context.pop()                     // Navigator.of(context).pop
context.replace('/home')          // pushReplacementNamed
context.pushAndClearStack('/login') // pushNamedAndRemoveUntil

// Route information
context.currentRoute             // Current route name
context.canPop                   // Can pop current route
```

### Dialogs and Snackbars

```dart
// Show dialogs
context.showDialog(MyDialog())
context.showBottomSheet(MyBottomSheet())
context.showSnackBar('Message')

// Material specific
context.showMaterialDialog(
  title: 'Confirm',
  content: 'Are you sure?',
  actions: [
    TextButton(onPressed: context.pop, child: Text('Cancel')),
    ElevatedButton(onPressed: () {}, child: Text('Confirm')),
  ],
)
```

## Best Practices

### Extension Usage Patterns

```dart
// Good: Chain extensions for readability
Text('Hello World')
  .paddingAll(16)
  .center()
  .onTap(() => print('Tapped'))

// Good: Use validation extensions for forms
final isValid = email.isValidEmail && 
                password.isStrongPassword &&
                phone.isValidPhone;

// Good: Use date extensions for business logic
final canSchedule = selectedDate.isBusinessDay && 
                   selectedDate.isAfter(DateTime.now()) &&
                   selectedDate.isBefore(maxDate);
```

### Performance Considerations

```dart
// Good: Cache expensive operations
class MyWidget extends StatelessWidget {
  static final _formatter = DateFormat('yyyy-MM-dd');
  
  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.date.format('yyyy-MM-dd'); // Use extension
    return Text(formattedDate);
  }
}

// Avoid: Excessive chaining in hot paths
// This is fine for UI building, but avoid in loops
list.map((item) => 
  Text(item.name)
    .paddingAll(8)
    .center()
    .onTap(() => selectItem(item))
).toList();
```

These extensions provide a comprehensive toolkit for common Flutter development tasks, significantly reducing boilerplate code while maintaining readability and type safety.