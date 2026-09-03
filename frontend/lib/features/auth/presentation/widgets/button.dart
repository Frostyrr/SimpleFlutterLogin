import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.985 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: double.infinity,
            height: 48.0,
            decoration: BoxDecoration(
              color: isEnabled
                  ? (_isPressed
                      ? const Color(0xFFE4E4E7)
                      : const Color(0xFFEDEDF0)) // Crisp high-contrast white/silver
                  : const Color(0xFF1F1F24),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: isEnabled
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF27272A),
                width: 1.0,
              ),
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: isEnabled
                                ? const Color(0xFF09090B)
                                : const Color(0xFF71717A),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16.0,
                          color: isEnabled
                              ? const Color(0xFF09090B)
                              : const Color(0xFF71717A),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
