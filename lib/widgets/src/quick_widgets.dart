import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import '../../util/util.dart';

/// Collection of high-level widgets that eliminate repetitive code
/// These widgets handle common patterns with sensible defaults

/// Quick card with built-in padding, shadow, and rounded corners
class QuickCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const QuickCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.backgroundColor,
    this.boxShadow,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? paddingAllFifteen,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// Quick list tile with avatar, title, subtitle, and trailing
class QuickListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;

  const QuickListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.dense = false,
  });

  /// Factory for creating a tile with circular avatar
  factory QuickListTile.avatar({
    Key? key,
    required String title,
    String? subtitle,
    String? avatarUrl,
    String? avatarText,
    Color? avatarColor,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
    bool dense = false,
  }) {
    Widget? leading;
    
    if (avatarUrl != null) {
      leading = CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
        backgroundColor: avatarColor,
      );
    } else if (avatarText != null) {
      leading = CircleAvatar(
        backgroundColor: avatarColor ?? Colors.blue,
        child: Text(
          avatarText,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return QuickListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding,
      dense: dense,
    );
  }

  /// Factory for creating a tile with icon
  factory QuickListTile.icon({
    Key? key,
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
    bool dense = false,
  }) {
    return QuickListTile(
      key: key,
      leading: Icon(icon, color: iconColor),
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding,
      dense: dense,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding ?? paddingAllFifteen,
      dense: dense,
    );
  }
}

/// Quick button with predefined styles and loading state
class QuickButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final QuickButtonStyle style;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const QuickButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.style = QuickButtonStyle.primary,
    this.width,
    this.height = 48,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    Color backgroundColor;
    Color textColor;
    BorderSide? borderSide;

    switch (style) {
      case QuickButtonStyle.primary:
        backgroundColor = theme.primaryColor;
        textColor = Colors.white;
        break;
      case QuickButtonStyle.secondary:
        backgroundColor = Colors.transparent;
        textColor = theme.primaryColor;
        borderSide = BorderSide(color: theme.primaryColor);
        break;
      case QuickButtonStyle.danger:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case QuickButtonStyle.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case QuickButtonStyle.ghost:
        backgroundColor = Colors.transparent;
        textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        break;
    }

    Widget buttonChild;
    
    if (isLoading) {
      buttonChild = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor),
          horizontalSpaceEight,
          Text(text, style: TextStyle(color: textColor)),
        ],
      );
    } else {
      buttonChild = Text(text, style: TextStyle(color: textColor));
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusFifteen,
            side: borderSide ?? BorderSide.none,
          ),
        ),
        child: buttonChild,
      ),
    );
  }
}

enum QuickButtonStyle { primary, secondary, danger, success, ghost }

/// Quick section header with optional action button
class QuickSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const QuickSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? paddingAllFifteen,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.theme.textTheme.headlineSmall,
                ),
                if (subtitle != null) ...[
                  verticalSpaceFive,
                  Text(
                    subtitle!,
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Quick loading states for common scenarios
class QuickLoadingStates<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(T data) onData;
  final Widget? onLoading;
  final Widget Function(Object error)? onError;
  final Widget? onEmpty;
  final bool Function(T data)? isEmpty;

  const QuickLoadingStates({
    super.key,
    required this.snapshot,
    required this.onData,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return onLoading ?? const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      final error = snapshot.error;
      if (error != null && onError != null) {
        return onError!(error);
      }
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return onEmpty ?? const Center(child: Text('No data'));
    }

    final data = snapshot.data as T;
    
    if (isEmpty?.call(data) == true) {
      return onEmpty ?? const Center(child: Text('No data'));
    }

    return onData(data);
  }
}

/// Quick empty state widget
class QuickEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? imagePath;
  final Widget? action;
  final EdgeInsetsGeometry? padding;

  const QuickEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.imagePath,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? paddingAllTwenty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 200,
              width: 200,
            )
          else if (icon != null)
            Icon(
              icon,
              size: 100,
              color: Colors.grey,
            ),
          
          verticalSpaceTwenty,
          
          Text(
            title,
            style: context.theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          
          if (subtitle != null) ...[
            verticalSpaceEight,
            Text(
              subtitle!,
              style: context.theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          
          if (action != null) ...[
            verticalSpaceTwenty,
            action!,
          ],
        ],
      ),
    );
  }
}

/// Quick scaffold with common app bar configurations
class QuickScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const QuickScaffold({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title != null ? AppBar(
        title: Text(title!),
        centerTitle: centerTitle,
        actions: actions,
        leading: leading ?? (showBackButton ? 
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          ) : null),
        automaticallyImplyLeading: false,
      ) : null,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
    );
  }
}

/// Quick grid builder with responsive columns
class QuickGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const QuickGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final calculatedCrossAxisCount = crossAxisCount ?? 
      (screenWidth > 1200 ? 4 : screenWidth > 800 ? 3 : 2);

    return GridView.count(
      crossAxisCount: calculatedCrossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

/// Quick list builder with built-in loading and empty states
class QuickListBuilder<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const QuickListBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.emptyWidget,
    this.loadingWidget,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Text(errorMessage ?? 'An error occurred'),
      );
    }

    if (items.isEmpty) {
      return emptyWidget ?? const QuickEmptyState(
        title: 'No items found',
        icon: Icons.inbox,
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
    );
  }
}