import 'package:flutter/material.dart';

class EnduranceSportCard extends StatelessWidget {
  const EnduranceSportCard({
    super.key,
    required this.label,
    required this.assetPath,
    required this.fallbackIcon,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  static const Color _cardBackground = Colors.white;
  static const Color _contentColor = Color(0xFF2F3855);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: _cardBackground,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: _contentColor.withValues(alpha: 0.08),
        highlightColor: _contentColor.withValues(alpha: 0.05),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: _cardBackground,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.medium,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                fallbackIcon,
                                size: 72,
                                color: _contentColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 34,
                    child: Center(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _contentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isDark)
              IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}