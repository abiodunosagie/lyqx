import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyqx/theme/app_colors.dart';

// Custom Text Field
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightGray,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : _isFocused
                  ? AppColors.accentGold
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: _isFocused
                ? [
              BoxShadow(
                color: AppColors.accentGold.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              labelStyle: TextStyle(
                color: hasError
                    ? AppColors.error
                    : _isFocused
                    ? AppColors.accentGold
                    : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                fontSize: _isFocused ? 14 : 16,
              ),
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary.withOpacity(0.5)
                    : AppColors.textSecondary.withOpacity(0.5),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              counterText: '',
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Search Field
class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String hint;
  final bool enabled;
  final VoidCallback? onClear;

  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint = 'Search...',
    this.enabled = true,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightGray,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary.withOpacity(0.5)
                : AppColors.textSecondary.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
            onPressed: () {
              controller?.clear();
              onClear?.call();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}

// Password Field with Toggle
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool showStrengthIndicator;

  const PasswordField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.showStrengthIndicator = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  double _strength = 0;

  void _calculateStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    setState(() {
      _strength = strength;
    });
  }

  Color _getStrengthColor() {
    if (_strength <= 0.25) return AppColors.error;
    if (_strength <= 0.5) return AppColors.warning;
    if (_strength <= 0.75) return AppColors.info;
    return AppColors.success;
  }

  String _getStrengthText() {
    if (_strength <= 0.25) return 'Weak';
    if (_strength <= 0.5) return 'Fair';
    if (_strength <= 0.75) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: widget.label,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: (value) {
            if (widget.showStrengthIndicator) {
              _calculateStrength(value);
            }
            widget.onChanged?.call(value);
          },
          obscureText: _obscureText,
          prefixIcon: const Icon(Icons.lock_outline, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.showStrengthIndicator && widget.controller?.text.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _strength,
                          minHeight: 4,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getStrengthText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStrengthColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Dropdown Field
class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final void Function(T?)? onChanged;
  final String Function(T) displayText;
  final Widget? prefixIcon;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.displayText,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(displayText(item)),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: TextStyle(
          fontSize: 16,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
        icon: Icon(
          Icons.arrow_drop_down,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

// OTP Input Field
class OTPField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final void Function(String)? onChanged;

  const OTPField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.accentGold,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.length - 1) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }

              widget.onChanged?.call(_otp);

              if (_otp.length == widget.length) {
                widget.onCompleted(_otp);
              }
            },
          ),
        );
      }),
    );
  }
}