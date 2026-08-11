import 'package:flutter/material.dart';

class AnimatedGameButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool isCorrect;
  final bool isWrong;
  final bool isCorrectAnswer;
  final bool disabled;

  const AnimatedGameButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
    this.icon,
    this.isCorrect = false,
    this.isWrong = false,
    this.isCorrectAnswer = false,
    this.disabled = false,
  });

  @override
  State<AnimatedGameButton> createState() => _AnimatedGameButtonState();
}

class _AnimatedGameButtonState extends State<AnimatedGameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    if (widget.isCorrect) return Colors.green.shade100;
    if (widget.isWrong) return Colors.red.shade100;
    if (widget.isCorrectAnswer) return Colors.green.shade100;
    return widget.color ?? Colors.white;
  }

  Color get _borderColor {
    if (widget.isCorrect) return Colors.green;
    if (widget.isWrong) return Colors.red;
    if (widget.isCorrectAnswer) return Colors.green;
    return widget.color != null ? widget.color!.withOpacity(0.5) : Colors.brown.shade200;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.disabled ? null : (_) => _controller.forward(),
      onTapUp: widget.disabled ? null : (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: widget.disabled ? null : () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: _borderColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: widget.textColor ?? Colors.brown.shade800, size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor ?? Colors.brown.shade900,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              if (widget.isCorrect)
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
              if (widget.isWrong)
                const Icon(Icons.cancel, color: Colors.red, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ModeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const ModeCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.brown.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
