import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseAssetResolver {
  ExerciseAssetResolver._();

  static const String _baseDir = 'assets/images/exercises';
  static const List<String> _extensions = <String>[
    'webp',
    'gif',
    'png',
    'jpg',
    'jpeg',
  ];

  static final Map<String, Future<String?>> _pathCache =
  <String, Future<String?>>{};

  static final Map<String, Future<ui.Image?>> _firstFrameCache =
  <String, Future<ui.Image?>>{};

  static Future<String?> resolveAssetPath(String exerciseId) {
    final normalized = exerciseId.trim().toLowerCase();
    return _pathCache.putIfAbsent(
      normalized,
          () => _resolveAssetPathInternal(normalized),
    );
  }

  // PATCH 4: Warm-up-Methode — startet den Cache-Lookup ohne auf das Ergebnis
  // zu warten. Wird aus dem PageView-itemBuilder für Nachbar-Pages aufgerufen,
  // damit der Asset-Pfad bereits gecacht ist, wenn die Page ins Bild scrollt.
  static void warmUp(String exerciseId) {
    resolveAssetPath(exerciseId);
  }

  static Future<ui.Image?> resolveFirstFrame(String assetPath) {
    return _firstFrameCache.putIfAbsent(
      assetPath,
          () => _resolveFirstFrameInternal(assetPath),
    );
  }

  static Future<String?> _resolveAssetPathInternal(String normalizedId) async {
    if (normalizedId.isEmpty) {
      return null;
    }

    final candidates = _buildCandidateBaseNames(normalizedId);

    for (final candidate in candidates) {
      for (final ext in _extensions) {
        final path = '$_baseDir/$candidate.$ext';
        final exists = await _assetExists(path);
        if (exists) {
          return path;
        }
      }
    }

    return null;
  }

  static Future<ui.Image?> _resolveFirstFrameInternal(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  static List<String> _buildCandidateBaseNames(String rawId) {
    final normalized = rawId.trim().toLowerCase();
    if (normalized.isEmpty) {
      return const <String>[];
    }

    final rx = RegExp(r'^([a-z])?(\d+)([mf])?$');
    final match = rx.firstMatch(normalized);

    final result = <String>[];

    void add(String value) {
      if (value.isNotEmpty && !result.contains(value)) {
        result.add(value);
      }
    }

    add('ex_$normalized');

    if (match != null) {
      final prefix = match.group(1) ?? '';
      final digits = match.group(2) ?? '';
      final suffix = match.group(3) ?? '';

      if (prefix.isNotEmpty || digits.isNotEmpty) {
        add('ex_$prefix$digits');
      }

      if (digits.isNotEmpty) {
        add('ex_$digits');
      }

      if (digits.isNotEmpty) {
        final asInt = int.tryParse(digits);
        if (asInt != null) {
          add('ex_${asInt.toString().padLeft(4, '0')}');
        }
      }

      if (digits.isNotEmpty && suffix.isNotEmpty) {
        add('ex_$digits$suffix');
      }
    }

    return result;
  }
}

class ExerciseAssetImage extends StatelessWidget {
  const ExerciseAssetImage({
    super.key,
    required this.exerciseId,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.placeholderIcon = Icons.image_outlined,
    this.animate = true,
  });

  final String exerciseId;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ExerciseAssetResolver.resolveAssetPath(exerciseId),
      builder: (context, snapshot) {
        final path = snapshot.data;

        Widget child;
        if (path == null || path.isEmpty) {
          child = _PlaceholderImage(
            width: width,
            height: height,
            icon: placeholderIcon,
          );
        } else if (animate) {
          child = Image.asset(
            path,
            width: width,
            height: height,
            fit: fit,
            filterQuality: FilterQuality.low,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) {
              return _PlaceholderImage(
                width: width,
                height: height,
                icon: placeholderIcon,
              );
            },
          );
        } else {
          child = FutureBuilder<ui.Image?>(
            future: ExerciseAssetResolver.resolveFirstFrame(path),
            builder: (context, frameSnapshot) {
              final image = frameSnapshot.data;
              if (image == null) {
                if (frameSnapshot.connectionState == ConnectionState.done) {
                  return _PlaceholderImage(
                    width: width,
                    height: height,
                    icon: placeholderIcon,
                  );
                }

                return SizedBox(
                  width: width,
                  height: height,
                );
              }

              return RawImage(
                image: image,
                width: width,
                height: height,
                fit: fit,
                filterQuality: FilterQuality.low,
              );
            },
          );
        }

        if (borderRadius != null) {
          return ClipRRect(
            borderRadius: borderRadius!,
            child: child,
          );
        }

        return child;
      },
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({
    required this.width,
    required this.height,
    required this.icon,
  });

  final double? width;
  final double? height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: (width != null && width! < 64) ? 24 : 40,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
      ),
    );
  }
}