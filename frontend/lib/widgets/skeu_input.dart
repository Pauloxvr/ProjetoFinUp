import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Campo de input skeuomorphic com efeito inset
class SkeuInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const SkeuInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<SkeuInput> createState() => _SkeuInputState();
}

class _SkeuInputState extends State<SkeuInput> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff475569),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: const Color(0xfff1f5f9),
            borderRadius: BorderRadius.circular(AppTheme.inputRadius),
            border: Border.all(
              color: _isFocused ? AppTheme.primaryBlue : const Color(0xffe2e8f0),
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: [
              // Sombra interna superior
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -1,
              ),
              // Brilho inferior
              if (_isFocused)
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  offset: const Offset(0, 0),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.inputRadius),
            child: Stack(
              children: [
                // Gradiente sutil no topo
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.02),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // TextField
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  onChanged: widget.onChanged,
                  maxLines: widget.maxLines,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1e293b),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: widget.prefixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16, right: 12),
                            child: widget.prefixIcon,
                          )
                        : null,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    suffixIcon: widget.suffixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: widget.suffixIcon,
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 0 : 20,
                      vertical: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown skeuomorphic
class SkeuDropdown<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const SkeuDropdown({
    super.key,
    this.label,
    required this.hint,
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff475569),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xfff1f5f9),
            borderRadius: BorderRadius.circular(AppTheme.inputRadius),
            border: Border.all(
              color: const Color(0xffe2e8f0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -1,
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff1e293b),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xff94a3b8),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.inputRadius),
          ),
        ),
      ],
    );
  }
}
