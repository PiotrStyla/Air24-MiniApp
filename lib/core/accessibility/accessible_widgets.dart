import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'accessibility_service.dart';

/// A button with enhanced accessibility features
class AccessibleButton extends StatelessWidget {
  /// Text to display on the button
  final String label;
  
  /// Detailed description for screen readers
  final String semanticLabel;
  
  /// Callback when button is pressed - can be async or null
  final Function()? onPressed;
  
  /// Optional icon to display with the button
  final IconData? icon;
  
  /// Whether to use a filled button style
  final bool filled;
  
  /// Whether button is enabled
  final bool enabled;
  
  /// Optional color override
  final Color? color;
  
  /// Whether button is currently loading/processing
  final bool isLoading;

  /// Create a new accessible button
  const AccessibleButton({
    Key? key,
    required this.label,
    required this.semanticLabel,
    required this.onPressed,
    this.icon,
    this.filled = true,
    this.enabled = true,
    this.color,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = Provider.of<AccessibilityService>(context);
    
    // Choose button style based on settings and props
    Widget button;
    final finalSemanticLabel = accessibilityService.semanticLabel(
      label, 
      semanticLabel + (isLoading ? ', loading' : '')
    );
    
    // Function that should be passed to button
    final buttonCallback = (enabled && onPressed != null && !isLoading) ? onPressed : null;
    
    // Button content based on loading state
    Widget buttonContent;
    if (isLoading) {
      buttonContent = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    } else if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          // Make label flexible to avoid horizontal overflow on narrow screens
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      );
    } else {
      // Single text label variant with safe overflow handling
      buttonContent = Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      );
    }
    
    if (filled) {
      button = ElevatedButton(
        onPressed: buttonCallback,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // when null, theme primary is used
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 18,
          ),
          minimumSize: const Size(44, 44), // Minimum touch target size
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: buttonContent,
      );
    } else {
      button = OutlinedButton(
        onPressed: buttonCallback,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 18,
          ),
          minimumSize: const Size(44, 44), // Minimum touch target size
          shape: const StadiumBorder(),
          side: BorderSide(color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.6)),
          foregroundColor: color,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: buttonContent,
      );
    }
    
    // Wrap with semantics
    return Semantics(
      button: true,
      enabled: enabled && !isLoading,
      label: finalSemanticLabel,
      onTap: (enabled && !isLoading && onPressed != null)
          ? () {
              // Mirror the primary activation action for assistive tech
              onPressed!();
            }
          : null,
      child: ExcludeSemantics(
        child: button,
      ),
    );
  }
}

/// A text field with enhanced accessibility features
class AccessibleTextField extends StatelessWidget {
  /// Controller for the text field
  final TextEditingController controller;
  
  /// Label for the text field
  final String label;
  
  /// Detailed description for screen readers
  final String semanticLabel;
  
  /// Optional hint text
  final String? hint;
  
  /// Optional help text
  final String? helperText;
  
  /// Optional error text
  final String? errorText;
  
  /// Whether field is required
  final bool required;
  
  /// Field validator
  final String? Function(String?)? validator;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Next focus node
  final FocusNode? nextFocusNode;
  
  /// Optional icon
  final IconData? icon;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Number of lines for multiline input
  final int? maxLines;

  /// Create a new accessible text field
  const AccessibleTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.semanticLabel,
    this.hint,
    this.helperText,
    this.errorText,
    this.required = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.icon,
    this.enabled = true,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = Provider.of<AccessibilityService>(context);
    final finalSemanticLabel = accessibilityService.semanticLabel(
      label, 
      required 
          ? "$semanticLabel, required field" 
          : semanticLabel,
    );
    
    // Choose text field style based on settings
    return Semantics(
      textField: true,
      label: finalSemanticLabel,
      hint: hint,
      enabled: enabled,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines ?? 1,
        enabled: enabled,
        validator: validator,
        onEditingComplete: nextFocusNode != null
            ? () => FocusScope.of(context).requestFocus(nextFocusNode)
            : null,
        decoration: InputDecoration(
          labelText: "$label${required ? ' *' : ''}",
          hintText: hint,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// A custom card with enhanced accessibility features
class AccessibleCard extends StatelessWidget {
  /// Title of the card
  final String title;
  
  /// Content of the card
  final Widget child;
  
  /// Detailed description for screen readers
  final String? semanticLabel;
  
  /// Optional header widget
  final Widget? header;
  
  /// Optional footer widget
  final Widget? footer;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border color
  final Color? borderColor;
  
  /// Whether card has focus
  final bool hasFocus;
  
  /// Optional tap handler
  final VoidCallback? onTap;
  
  /// Create a new accessible card
  const AccessibleCard({
    Key? key,
    required this.title,
    required this.child,
    this.semanticLabel,
    this.header,
    this.footer,
    this.backgroundColor,
    this.borderColor,
    this.hasFocus = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = Provider.of<AccessibilityService>(context);
    final finalSemanticLabel = semanticLabel != null
        ? accessibilityService.semanticLabel(title, semanticLabel!)
        : title;
    
    final theme = Theme.of(context);
    final borderWidth = hasFocus ? 2.0 : 1.0;
    
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) header!,
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
        if (footer != null) footer!,
      ],
    );
    
    // If card is tappable, wrap with appropriate handlers
    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: cardContent,
      );
    }
    
    return Semantics(
      label: finalSemanticLabel,
      button: onTap != null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor ?? theme.dividerColor,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: cardContent,
      ),
    );
  }
}

/// A toggle switch with enhanced accessibility features
class AccessibleToggle extends StatelessWidget {
  /// Label for the toggle
  final String label;
  
  /// Detailed description for screen readers
  final String semanticLabel;
  
  /// Whether toggle is on
  final bool value;
  
  /// Callback when value changes
  final ValueChanged<bool> onChanged;
  
  /// Whether control is enabled
  final bool enabled;
  
  /// Create a new accessible toggle
  const AccessibleToggle({
    Key? key,
    required this.label,
    required this.semanticLabel,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessibilityService = Provider.of<AccessibilityService>(context);
    final finalSemanticLabel = accessibilityService.semanticLabel(
      label, 
      semanticLabel,
    );
    final theme = Theme.of(context);
    
    return Semantics(
      label: finalSemanticLabel,
      toggled: value,
      child: Row(
        children: [
          Expanded(
            child: ExcludeSemantics( // Exclude semantics on the Text inside AccessibleToggle
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }
}

/// A screen reader announcement widget to announce important changes
class ScreenReaderAnnouncement extends StatelessWidget {
  /// Message to announce
  final String message;
  
  /// Child widget
  final Widget child;
  
  /// Mode of announcement
  final AnnouncementMode mode;
  
  /// Create a new screen reader announcement
  const ScreenReaderAnnouncement({
    Key? key,
    required this.message,
    required this.child,
    this.mode = AnnouncementMode.polite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      attributedLabel: AttributedString(message),
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Mode of screen reader announcement
enum AnnouncementMode {
  /// Polite announcement (non-interrupting)
  polite,
  
  /// Assertive announcement (interrupting)
  assertive,
}
