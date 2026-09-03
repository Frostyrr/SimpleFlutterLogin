import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Small uppercase label matching reference
        Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: const Color(0xFF8E8E93),
          ),
        ),
        const SizedBox(height: 8.0),

        // Input container with 150ms border highlight
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F12), // Subtle dark graphite fill
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: _isFocused
                  ? const Color(0xFF52525B) // Highlighted on focus
                  : const Color(0xFF1F1F24), // Hairline graphite border
              width: 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _isObscured,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF3F3F46),
                fontSize: 14.0,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      size: 18.0,
                      color: _isFocused
                          ? const Color(0xFFA1A1AA)
                          : const Color(0xFF52525B),
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      splashRadius: 18.0,
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18.0,
                        color: const Color(0xFF71717A),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
