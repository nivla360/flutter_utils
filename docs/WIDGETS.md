# Widgets Reference

Flutter Utils provides a comprehensive set of modern widgets designed to eliminate repetitive code and provide consistent UI patterns across your Flutter applications.

## Table of Contents

- [Quick Widgets](#quick-widgets)
- [Smart Form Builder](#smart-form-builder)
- [Skeleton Loaders](#skeleton-loaders)
- [Loading States](#loading-states)
- [Empty States](#empty-states)
- [Layout Helpers](#layout-helpers)
- [Navigation Widgets](#navigation-widgets)

## Quick Widgets

High-level widgets that replace verbose widget trees with simple, configurable components.

### QuickCard

Replace 15+ lines of Card setup with a single widget.

```dart
// Before: Verbose Card setup
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () => navigateToDetails(),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Text('Content goes here'),
        ],
      ),
    ),
  ),
)

// After: QuickCard
QuickCard(
  title: 'Title',
  child: Text('Content goes here'),
  onTap: () => navigateToDetails(),
)
```

#### Properties

```dart
QuickCard({
  Widget? child,
  String? title,
  String? subtitle,
  Widget? leading,
  Widget? trailing,
  VoidCallback? onTap,
  EdgeInsets? padding,
  EdgeInsets? margin,
  double? elevation,
  Color? color,
  BorderRadius? borderRadius,
  bool showBorder = false,
  Color? borderColor,
  double? borderWidth,
})
```

#### Examples

```dart
// Basic card
QuickCard(
  child: Text('Simple content'),
)

// Card with title and subtitle
QuickCard(
  title: 'Product Name',
  subtitle: '\$29.99',
  child: Text('Product description here'),
  onTap: () => viewProduct(),
)

// Card with leading icon
QuickCard(
  leading: Icon(Icons.star, color: Colors.amber),
  title: 'Featured Item',
  child: Text('This item is featured'),
  elevation: 8,
)

// Custom styled card
QuickCard(
  title: 'Warning',
  child: Text('This action cannot be undone'),
  color: Colors.orange.shade50,
  showBorder: true,
  borderColor: Colors.orange,
  borderWidth: 2,
)
```

### QuickButton

Consistent button styling with loading states and multiple variants.

```dart
// Primary button with loading
QuickButton(
  text: 'Login',
  icon: Icons.login,
  style: QuickButtonStyle.primary,
  isLoading: isLoggingIn,
  onPressed: handleLogin,
)

// Secondary button
QuickButton(
  text: 'Cancel',
  style: QuickButtonStyle.secondary,
  onPressed: () => Navigator.pop(context),
)

// Outline button with custom colors
QuickButton(
  text: 'Custom',
  style: QuickButtonStyle.outline,
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  onPressed: handleCustomAction,
)

// Icon-only button
QuickButton.icon(
  icon: Icons.favorite,
  style: QuickButtonStyle.primary,
  isCircular: true,
  onPressed: toggleFavorite,
)
```

#### Button Styles

```dart
enum QuickButtonStyle {
  primary,    // Filled with primary color
  secondary,  // Filled with secondary color
  outline,    // Outlined border
  text,       // Text-only button
  elevated,   // Material elevated button
  tonal,      // Material 3 tonal button
}
```

### QuickListTile

Enhanced ListTile with avatar handling and common patterns.

```dart
// Avatar from URL with fallback
QuickListTile.avatar(
  title: 'John Doe',
  subtitle: 'Software Engineer',
  avatarUrl: 'https://example.com/avatar.jpg',
  fallbackIcon: Icons.person,
  onTap: () => viewProfile(),
)

// Icon-based list tile
QuickListTile.icon(
  leading: Icons.settings,
  title: 'Settings',
  subtitle: 'App preferences',
  trailing: Icons.arrow_forward_ios,
  onTap: () => openSettings(),
)

// List tile with badge
QuickListTile.badge(
  title: 'Messages',
  subtitle: 'Unread conversations',
  badgeCount: 5,
  badgeColor: Colors.red,
  onTap: () => openMessages(),
)

// Switch list tile
QuickListTile.switch(
  title: 'Dark Mode',
  subtitle: 'Enable dark theme',
  value: isDarkMode,
  onChanged: toggleDarkMode,
)
```

### QuickTextField

Enhanced text input with built-in validation and styling.

```dart
// Email field with validation
QuickTextField.email(
  label: 'Email Address',
  controller: emailController,
  required: true,
  onChanged: (value) => validateEmail(value),
)

// Password field with strength indicator
QuickTextField.password(
  label: 'Password',
  controller: passwordController,
  showStrengthIndicator: true,
  minLength: 8,
)

// Search field
QuickTextField.search(
  hint: 'Search products...',
  onSearch: (query) => performSearch(query),
  showClearButton: true,
)

// Number input with formatting
QuickTextField.number(
  label: 'Price',
  controller: priceController,
  prefix: '\$',
  decimalPlaces: 2,
  allowNegative: false,
)
```

## Smart Form Builder

Declarative form creation with built-in validation and styling.

### Basic Usage

```dart
SmartFormBuilder(
  fields: [
    FormFieldConfig(
      key: 'firstName',
      label: 'First Name',
      type: FormFieldType.text,
      required: true,
      validators: [RequiredValidator(), MinLengthValidator(2)],
    ),
    FormFieldConfig(
      key: 'email',
      label: 'Email',
      type: FormFieldType.email,
      required: true,
      validators: [EmailValidator()],
    ),
    FormFieldConfig(
      key: 'birthDate',
      label: 'Birth Date',
      type: FormFieldType.date,
      required: true,
    ),
    FormFieldConfig(
      key: 'country',
      label: 'Country',
      type: FormFieldType.dropdown,
      options: ['USA', 'Canada', 'UK', 'Australia'],
      required: true,
    ),
  ],
  onSubmit: (values) {
    print('Form values: $values');
    // Handle form submission
  },
  showSubmitButton: true,
  submitButtonText: 'Create Account',
)
```

### Field Types

```dart
enum FormFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
  dropdown,
  radio,
  checkbox,
  date,
  time,
  dateTime,
  slider,
  switch,
  file,
}
```

### Custom Validators

```dart
// Built-in validators
RequiredValidator()
EmailValidator()
MinLengthValidator(8)
MaxLengthValidator(50)
PhoneValidator()
PasswordStrengthValidator()

// Custom validator
class CustomValidator extends FieldValidator {
  @override
  String? validate(String? value) {
    if (value?.contains('admin') == true) {
      return 'Username cannot contain "admin"';
    }
    return null;
  }
}
```

### Advanced Form Configuration

```dart
SmartFormBuilder(
  fields: formFields,
  spacing: 16.0,
  padding: EdgeInsets.all(20),
  showSubmitButton: true,
  submitButtonText: 'Save Changes',
  submitButtonStyle: QuickButtonStyle.primary,
  enableAutoValidation: true,
  validateOnChange: true,
  onFieldChanged: (key, value) {
    print('Field $key changed to: $value');
  },
  onValidationChanged: (isValid) {
    setState(() => formIsValid = isValid);
  },
  customSubmitButton: QuickButton(
    text: 'Custom Submit',
    isLoading: isSubmitting,
    onPressed: isFormValid ? handleSubmit : null,
  ),
)
```

## Skeleton Loaders

Modern loading placeholders with shimmer effects.

### Skeleton Shapes

```dart
// Basic shapes
SkeletonShapes.rectangle(width: 200, height: 16)
SkeletonShapes.circle(size: 50)
SkeletonShapes.rounded(width: 100, height: 20, radius: 8)

// Text placeholders
SkeletonShapes.text(lines: 3, lastLineWidth: 0.7)
SkeletonShapes.paragraph(lines: 5)

// Common UI elements
SkeletonShapes.button(width: 120, height: 40)
SkeletonShapes.avatar(size: 60)
SkeletonShapes.icon(size: 24)
```

### Skeleton Layouts

```dart
// List tile skeleton
SkeletonLayouts.listTile(
  showAvatar: true,
  showSubtitle: true,
  showTrailing: true,
)

// Card skeleton
SkeletonLayouts.card(
  imageHeight: 200,
  showTitle: true,
  showSubtitle: true,
  showActions: true,
)

// Article skeleton
SkeletonLayouts.article(
  showImage: true,
  imageHeight: 180,
  titleLines: 2,
  contentLines: 4,
)

// Profile skeleton
SkeletonLayouts.profile(
  showCoverImage: true,
  showBio: true,
  showStats: true,
)

// Grid item skeleton
SkeletonLayouts.gridItem(
  imageHeight: 150,
  showTitle: true,
  showPrice: true,
)
```

### Custom Skeleton

```dart
SkeletonLoader(
  loading: isLoading,
  child: ActualContent(),
  skeleton: Column(
    children: [
      SkeletonShapes.rectangle(width: double.infinity, height: 200),
      SizedBox(height: 16),
      SkeletonShapes.text(lines: 2),
      SizedBox(height: 8),
      Row(
        children: [
          SkeletonShapes.circle(size: 40),
          SizedBox(width: 12),
          Expanded(child: SkeletonShapes.text(lines: 1)),
        ],
      ),
    ],
  ),
)
```

## Loading States

Consistent loading indicators and states.

### Loading Indicators

```dart
// Size-based loaders (configured in FlutterUtil.initialize)
LoadingIndicator.small()    // 30px
LoadingIndicator.medium()   // 50px
LoadingIndicator.large()    // 70px

// Custom loader
LoadingIndicator.custom(
  size: 40,
  color: Colors.blue,
  strokeWidth: 3,
)

// SpinKit loaders (pre-configured)
LoadingIndicator.spinKit(SpinKitType.circle)
LoadingIndicator.spinKit(SpinKitType.pulse)
LoadingIndicator.spinKit(SpinKitType.wave)
```

### Loading Overlays

```dart
// Full screen loading
QuickLoadingOverlay(
  isLoading: isLoading,
  message: 'Please wait...',
  child: YourContent(),
)

// Loading with progress
QuickLoadingOverlay.progress(
  isLoading: isLoading,
  progress: downloadProgress,
  message: 'Downloading... ${(downloadProgress * 100).toInt()}%',
  child: YourContent(),
)

// Custom loading overlay
QuickLoadingOverlay.custom(
  isLoading: isLoading,
  loader: SpinKitFadingCircle(color: Colors.blue),
  backgroundColor: Colors.black54,
  child: YourContent(),
)
```

## Empty States

Consistent empty state handling.

### Basic Empty State

```dart
QuickEmptyState(
  title: 'No messages yet',
  subtitle: 'Start a conversation with someone',
  icon: Icons.message_outlined,
  action: QuickButton(
    text: 'New Message',
    onPressed: () => createNewMessage(),
  ),
)
```

### Specialized Empty States

```dart
// No internet connection
QuickEmptyState.noInternet(
  onRetry: () => retryConnection(),
)

// Search results
QuickEmptyState.noSearchResults(
  searchQuery: currentQuery,
  onClearSearch: () => clearSearch(),
)

// Error state
QuickEmptyState.error(
  error: 'Failed to load data',
  onRetry: () => reloadData(),
)

// No data
QuickEmptyState.noData(
  dataType: 'products',
  onCreate: () => addNewProduct(),
)
```

### Custom Empty State

```dart
QuickEmptyState.custom(
  image: Image.asset('assets/empty_cart.png'),
  title: 'Your cart is empty',
  subtitle: 'Add items to get started',
  actions: [
    QuickButton(
      text: 'Browse Products',
      style: QuickButtonStyle.primary,
      onPressed: () => browseCatalog(),
    ),
    QuickButton(
      text: 'View Wishlist',
      style: QuickButtonStyle.outline,
      onPressed: () => viewWishlist(),
    ),
  ],
)
```

## Layout Helpers

Utility widgets for common layout patterns.

### Responsive Helpers

```dart
// Responsive breakpoints
ResponsiveWidget(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)

// Responsive spacing
ResponsiveSpacing.vertical(
  mobile: 8,
  tablet: 12,
  desktop: 16,
)

// Responsive columns
ResponsiveColumns(
  mobile: 1,
  tablet: 2,
  desktop: 3,
  children: items.map((item) => ItemCard(item)).toList(),
)
```

### Quick Layouts

```dart
// Center with loading
QuickCenter(
  isLoading: isLoading,
  child: ContentWidget(),
)

// Padded container
QuickPadded(
  padding: 16,
  child: ContentWidget(),
)

// Scrollable column
QuickColumn(
  scrollable: true,
  spacing: 16,
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)

// Animated list
QuickAnimatedList(
  items: listItems,
  itemBuilder: (context, item, animation) => SlideTransition(
    position: animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
    child: ItemWidget(item),
  ),
)
```

### Spacing Widgets

```dart
// Vertical spacing
VSpace(8)    // SizedBox(height: 8)
VSpace.xs    // 4px
VSpace.sm    // 8px
VSpace.md    // 16px
VSpace.lg    // 24px
VSpace.xl    // 32px

// Horizontal spacing
HSpace(16)   // SizedBox(width: 16)
HSpace.xs    // 4px
HSpace.sm    // 8px
HSpace.md    // 16px
HSpace.lg    // 24px
HSpace.xl    // 32px

// Flexible spacing
FlexSpace()  // Expanded(child: SizedBox())
```

## Navigation Widgets

Enhanced navigation components.

### Quick Navigation

```dart
// Tab bar with icons and badges
QuickTabBar(
  tabs: [
    TabConfig(
      icon: Icons.home,
      label: 'Home',
      badgeCount: 0,
    ),
    TabConfig(
      icon: Icons.message,
      label: 'Messages',
      badgeCount: 5,
    ),
    TabConfig(
      icon: Icons.person,
      label: 'Profile',
      badgeCount: 0,
    ),
  ],
  onTabSelected: (index) => handleTabChange(index),
)

// Breadcrumb navigation
QuickBreadcrumb(
  items: [
    BreadcrumbItem(text: 'Home', onTap: () => goHome()),
    BreadcrumbItem(text: 'Products', onTap: () => goToProducts()),
    BreadcrumbItem(text: 'Details'),
  ],
)

// Navigation drawer item
QuickDrawerItem(
  icon: Icons.settings,
  title: 'Settings',
  subtitle: 'App preferences',
  onTap: () => openSettings(),
  isSelected: currentRoute == '/settings',
)
```

### App Bar Variants

```dart
// Search app bar
QuickAppBar.search(
  title: 'Products',
  onSearch: (query) => searchProducts(query),
  searchHint: 'Search products...',
)

// Profile app bar
QuickAppBar.profile(
  title: 'Profile',
  avatar: 'https://example.com/avatar.jpg',
  onAvatarTap: () => editProfile(),
)

// Action app bar
QuickAppBar.actions(
  title: 'Messages',
  actions: [
    AppBarAction(
      icon: Icons.search,
      onPressed: () => openSearch(),
    ),
    AppBarAction(
      icon: Icons.more_vert,
      onPressed: () => showMenu(),
    ),
  ],
)
```

## Best Practices

### Widget Organization

```dart
// Good: Use appropriate widget for the task
class ProductCard extends StatelessWidget {
  final Product product;
  
  ProductCard({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return QuickCard(
      title: product.name,
      subtitle: '\$${product.price}',
      child: Text(product.description),
      leading: QuickImageLoader(
        imageUrl: product.imageUrl,
        width: 60,
        height: 60,
      ),
      onTap: () => navigateToProduct(product),
    );
  }
}
```

### Form Patterns

```dart
// Good: Use SmartFormBuilder for complex forms
class RegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SmartFormBuilder(
      fields: [
        FormFieldConfig(
          key: 'email',
          type: FormFieldType.email,
          label: 'Email',
          required: true,
        ),
        FormFieldConfig(
          key: 'password',
          type: FormFieldType.password,
          label: 'Password',
          required: true,
          validators: [PasswordStrengthValidator()],
        ),
        FormFieldConfig(
          key: 'confirmPassword',
          type: FormFieldType.password,
          label: 'Confirm Password',
          required: true,
          validators: [PasswordMatchValidator('password')],
        ),
      ],
      onSubmit: handleRegistration,
    );
  }
}
```

### Loading State Management

```dart
// Good: Consistent loading patterns
class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<ProductController>(
      controller: GetIt.instance<ProductController>(),
      onLoading: (context, controller) => ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => SkeletonLayouts.listTile(),
      ),
      onSuccess: (context, controller) => ListView.builder(
        itemCount: controller.data?.length ?? 0,
        itemBuilder: (context, index) {
          final product = controller.data![index];
          return QuickListTile.avatar(
            title: product.name,
            subtitle: '\$${product.price}',
            avatarUrl: product.imageUrl,
            onTap: () => navigateToProduct(product),
          );
        },
      ),
      onError: (context, controller) => QuickEmptyState.error(
        error: controller.errorMessage,
        onRetry: controller.retry,
      ),
    );
  }
}
```

This widget system provides a comprehensive foundation for building modern Flutter UIs with minimal code and maximum consistency.