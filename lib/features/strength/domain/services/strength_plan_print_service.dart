import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../repositories/strength_repository.dart';

class StrengthPlanPrintService {
  const StrengthPlanPrintService({
    required StrengthRepository repository,
  }) : _repository = repository;

  final StrengthRepository _repository;

  static const List<int> allowedSetsPerExercise = <int>[
    3,
    4,
    5,
    6,
    8,
    10,
    12,
  ];

  static const double _pageWidth = 1754;
  static const double _pageHeight = 1240;
  static const double _margin = 40;
  static const double _rowHeight = 140;
  static const double _headerHeight = 110;
  static const double _footerHeight = 24;
  static const double _globalDateRowHeight = 34;
  static const double _globalDateRowGap = 10;

  static const double _tableLeftOffset = 430;
  static const double _tableRightInset = 10;
  static const double _blockGap = 10;
  static const int _blockCount = 10;

  static const PdfColor _brandColor = PdfColor.fromInt(0xFF2F3855);
  static const PdfColor _rowFillColor = PdfColor.fromInt(0xFFF2EDE7);
  static const PdfColor _lineColor = PdfColor.fromInt(0xFF464646);
  static const PdfColor _faintTextColor = PdfColor.fromInt(0xFFB9B9B9);

  static const PdfPageFormat _pageFormat = PdfPageFormat(
    _pageWidth,
    _pageHeight,
  );

  static Future<Set<String>>? _exerciseAssetManifestFuture;

  Future<void> printSavedPlan({
    required String planName,
    required int setsPerExercise,
    required String languageCode,
    required String jobName,
    required String generatedAtLabel,
    required String dateLabel,
    required String kgLabel,
    required String repsLabel,
    required String Function(int pageNumber, int pageCount) pageLabelBuilder,
    String? comment,
  }) async {
    final cleanPlanName = planName.trim();
    final exerciseIds = await _repository.loadPlanExerciseIds(cleanPlanName);

    final cleanExerciseIds = (exerciseIds ?? const <String>[])
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList(growable: false);

    if (cleanPlanName.isEmpty || cleanExerciseIds.isEmpty) {
      throw const StrengthPlanPrintNoExercisesException();
    }

    final rows = <_StrengthPlanPrintRow>[];
    for (final exerciseId in cleanExerciseIds) {
      final exercise = await _repository.getExerciseById(exerciseId);
      final imageBytes = await _loadExerciseImageAsPng(exerciseId);

      rows.add(
        _StrengthPlanPrintRow(
          exerciseId: exerciseId,
          label: (exercise?.label.trim().isNotEmpty ?? false)
              ? exercise!.label.trim()
              : exerciseId,
          imageBytes: imageBytes,
        ),
      );
    }

    final pdfBytes = await _buildPdf(
      planName: cleanPlanName,
      rows: rows,
      setsPerExercise: setsPerExercise.clamp(1, 12),
      languageCode: languageCode,
      generatedAtLabel: generatedAtLabel,
      dateLabel: dateLabel,
      kgLabel: kgLabel,
      repsLabel: repsLabel,
      pageLabelBuilder: pageLabelBuilder,
      comment: comment,
    );

    await Printing.layoutPdf(
      name: jobName,
      format: _pageFormat,
      onLayout: (_) async => pdfBytes,
    );
  }

  Future<Uint8List> _buildPdf({
    required String planName,
    required List<_StrengthPlanPrintRow> rows,
    required int setsPerExercise,
    required String languageCode,
    required String generatedAtLabel,
    required String dateLabel,
    required String kgLabel,
    required String repsLabel,
    required String Function(int pageNumber, int pageCount) pageLabelBuilder,
    required String? comment,
  }) async {
    final document = pw.Document(
      title: planName,
      author: 'mTORQUE',
      creator: 'mTORQUE',
    );

    final usableTop =
        _margin + _headerHeight + _globalDateRowHeight + _globalDateRowGap;
    final usableBottom = _pageHeight - _margin - _footerHeight;
    final rowsPerPage =
    ((usableBottom - usableTop) / _rowHeight).floor().clamp(1, 99);
    final pageCount = ((rows.length + rowsPerPage - 1) / rowsPerPage)
        .floor()
        .clamp(1, 999);

    final generatedAt = _formatGeneratedAt(DateTime.now(), languageCode);
    final cleanComment = comment?.trim();

    final qrSvg = Barcode.qrCode(
      errorCorrectLevel: BarcodeQRCorrectionLevel.medium,
    ).toSvg(
      _encodePlanQrUri(
        planName: planName,
        exerciseIds: rows.map((row) => row.exerciseId).toList(growable: false),
      ),
      width: 600,
      height: 600,
      drawText: false,
    );

    for (var pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final start = pageIndex * rowsPerPage;
      final end = (start + rowsPerPage).clamp(0, rows.length);

      document.addPage(
        pw.Page(
          pageFormat: _pageFormat,
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.Stack(
              children: <pw.Widget>[
                pw.Positioned.fill(
                  child: pw.Container(color: PdfColors.white),
                ),
                _buildPageHeader(
                  planName: planName,
                  generatedAtText: generatedAtLabel.replaceAll(
                    '{date}',
                    generatedAt,
                  ),
                  comment: cleanComment,
                  qrSvg: qrSvg,
                ),
                _buildGlobalDateRow(dateLabel: dateLabel),
                for (var i = start; i < end; i++)
                  _buildExerciseRow(
                    top: usableTop + (i - start) * _rowHeight,
                    row: rows[i],
                    setsPerExercise: setsPerExercise,
                    kgLabel: kgLabel,
                    repsLabel: repsLabel,
                  ),
                _buildPageFooter(
                  pageLabel: pageLabelBuilder(pageIndex + 1, pageCount),
                ),
              ],
            );
          },
        ),
      );
    }

    return document.save();
  }

  pw.Widget _positionedBox({
    required double left,
    required double top,
    required double width,
    required double height,
    required pw.Widget child,
    double parentWidth = _pageWidth,
    double parentHeight = _pageHeight,
  }) {
    return pw.Positioned(
      left: left,
      top: top,
      right: parentWidth - left - width,
      bottom: parentHeight - top - height,
      child: child,
    );
  }

  pw.Widget _buildPageHeader({
    required String planName,
    required String generatedAtText,
    required String? comment,
    required String qrSvg,
  }) {
    final headerTop = _margin;
    final headerBottom = _margin + _headerHeight - 12;

    final qrTop = _margin;
    final qrBottom =
        _margin + _headerHeight + _globalDateRowHeight + _globalDateRowGap - 2;
    final qrSize = (qrBottom - qrTop).clamp(120, 1000).toDouble();
    final qrLeft = _margin;
    final qrRight = qrLeft + qrSize;

    final headerTextLeft = qrRight + 18;
    final brandRight = _pageWidth - _margin;
    final brandWidth = 520.0;
    final textRight = brandRight - brandWidth - 36;
    final availableTextWidth = (textRight - headerTextLeft).clamp(120, 900);

    return pw.Stack(
      children: <pw.Widget>[
        _positionedBox(
          left: qrLeft,
          top: qrTop,
          width: qrSize,
          height: qrSize,
          child: pw.SvgImage(svg: qrSvg),
        ),
        _positionedBox(
          left: headerTextLeft,
          top: headerTop + 6,
          width: availableTextWidth.toDouble(),
          height: headerBottom - headerTop,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                planName,
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                style: pw.TextStyle(
                  font: pw.Font.helveticaBold(),
                  fontSize: 30,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 9),
              pw.Text(
                generatedAtText,
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
                style: pw.TextStyle(
                  font: pw.Font.helvetica(),
                  fontSize: 18,
                  color: PdfColors.grey800,
                ),
              ),
              if (comment != null && comment.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  comment,
                  maxLines: 1,
                  overflow: pw.TextOverflow.clip,
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 17,
                    color: PdfColors.grey800,
                  ),
                ),
              ],
            ],
          ),
        ),
        _positionedBox(
          left: _pageWidth - _margin - brandWidth,
          top: headerTop,
          width: brandWidth,
          height: headerBottom - headerTop,
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'mTORQUE',
              style: pw.TextStyle(
                font: pw.Font.helveticaBold(),
                fontSize: 78,
                letterSpacing: -2,
                color: _brandColor,
              ),
            ),
          ),
        ),
        _positionedBox(
          left: headerTextLeft,
          top: headerBottom,
          width: _pageWidth - _margin - headerTextLeft,
          height: 2,
          child: pw.Container(color: _lineColor),
        ),
      ],
    );
  }

  pw.Widget _buildGlobalDateRow({
    required String dateLabel,
  }) {
    final left = _margin + _tableLeftOffset;
    final top = _margin + _headerHeight;
    final right = _pageWidth - _margin - _tableRightInset;
    final totalWidth = right - left;
    final blockWidth =
        (totalWidth - _blockGap * (_blockCount - 1)) / _blockCount;

    return pw.Stack(
      children: <pw.Widget>[
        for (var blockIndex = 0; blockIndex < _blockCount; blockIndex++)
          _positionedBox(
            left: left + blockIndex * (blockWidth + _blockGap),
            top: top,
            width: blockWidth,
            height: _globalDateRowHeight,
            child: pw.Container(
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(
                  color: _lineColor,
                  width: 2,
                ),
              ),
              child: pw.Text(
                dateLabel,
                style: pw.TextStyle(
                  font: pw.Font.helvetica(),
                  fontSize: 14,
                  color: _faintTextColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  pw.Widget _buildExerciseRow({
    required double top,
    required _StrengthPlanPrintRow row,
    required int setsPerExercise,
    required String kgLabel,
    required String repsLabel,
  }) {
    const cardGap = 8.0;

    final left = _margin;
    final right = _pageWidth - _margin;
    final cardTop = top + cardGap / 2;
    final cardBottom = top + _rowHeight - cardGap / 2;
    final cardHeight = cardBottom - cardTop;

    final tableLeft = left + _tableLeftOffset;
    final tableRight = right - _tableRightInset;
    final tableTop = cardTop + 14;
    final tableBottom = cardBottom - 14;

    final tableHeight = tableBottom - tableTop;
    final imageBoxSize = tableHeight < 96 ? tableHeight : 96.0;

    final imageLeft = left + 10;
    final imageTop = cardTop + (cardHeight - imageBoxSize) / 2;
    final imageRight = imageLeft + imageBoxSize;

    final textLeft = imageRight + 16;
    final textRight = left + 420;
    final textWidth = textRight - textLeft;

    return pw.Stack(
      children: <pw.Widget>[
        _positionedBox(
          left: left,
          top: cardTop,
          width: right - left,
          height: cardHeight,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              color: _rowFillColor,
              border: pw.Border.all(
                color: _lineColor,
                width: 2,
              ),
            ),
          ),
        ),
        _positionedBox(
          left: imageLeft,
          top: imageTop,
          width: imageBoxSize,
          height: imageBoxSize,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(
                color: _lineColor,
                width: 2,
              ),
            ),
            child: row.imageBytes == null
                ? pw.SizedBox()
                : pw.Image(
              pw.MemoryImage(row.imageBytes!),
              fit: pw.BoxFit.contain,
            ),
          ),
        ),
        _positionedBox(
          left: textLeft,
          top: cardTop + 20,
          width: textWidth,
          height: cardHeight - 24,
          child: pw.Text(
            _pdfSafeText(row.label),
            maxLines: 3,
            overflow: pw.TextOverflow.clip,
            style: pw.TextStyle(
              font: pw.Font.helveticaBold(),
              fontSize: 18,
              color: _brandColor,
              lineSpacing: 2,
            ),
          ),
        ),
        _positionedBox(
          left: tableLeft,
          top: tableTop,
          width: tableRight - tableLeft,
          height: tableBottom - tableTop,
          child: _buildSetTable(
            setsPerExercise: setsPerExercise,
            kgLabel: kgLabel,
            repsLabel: repsLabel,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSetTable({
    required int setsPerExercise,
    required String kgLabel,
    required String repsLabel,
  }) {
    final safeRowCount = setsPerExercise.clamp(1, 12);
    final cellFontSize = switch (safeRowCount) {
      >= 10 => 8.0,
      >= 8 => 9.0,
      >= 6 => 10.0,
      == 5 => 11.0,
      == 4 => 12.0,
      _ => 14.0,
    };

    return pw.LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints!.maxWidth;
        final tableHeight = constraints.maxHeight;

        final blockWidth =
            (tableWidth - _blockGap * (_blockCount - 1)) / _blockCount;
        final rowHeight = tableHeight / safeRowCount;

        pw.Widget localPositionedBox({
          required double left,
          required double top,
          required double width,
          required double height,
          required pw.Widget child,
          required double parentWidth,
          required double parentHeight,
        }) {
          return pw.Positioned(
            left: left,
            top: top,
            right: parentWidth - left - width,
            bottom: parentHeight - top - height,
            child: child,
          );
        }

        return pw.Stack(
          children: <pw.Widget>[
            for (var blockIndex = 0; blockIndex < _blockCount; blockIndex++)
              localPositionedBox(
                left: blockIndex * (blockWidth + _blockGap),
                top: 0,
                width: blockWidth,
                height: tableHeight,
                parentWidth: tableWidth,
                parentHeight: tableHeight,
                child: pw.Stack(
                  children: <pw.Widget>[
                    pw.Positioned.fill(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          border: pw.Border.all(
                            color: _lineColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    localPositionedBox(
                      left: blockWidth / 2,
                      top: 0,
                      width: 1.5,
                      height: tableHeight,
                      parentWidth: blockWidth,
                      parentHeight: tableHeight,
                      child: pw.Container(color: _lineColor),
                    ),
                    for (var rowIndex = 1; rowIndex < safeRowCount; rowIndex++)
                      localPositionedBox(
                        left: 0,
                        top: rowIndex * rowHeight,
                        width: blockWidth,
                        height: 1.5,
                        parentWidth: blockWidth,
                        parentHeight: tableHeight,
                        child: pw.Container(color: _lineColor),
                      ),
                    for (var rowIndex = 0; rowIndex < safeRowCount; rowIndex++)
                      localPositionedBox(
                        left: 0,
                        top: rowIndex * rowHeight,
                        width: blockWidth,
                        height: rowHeight,
                        parentWidth: blockWidth,
                        parentHeight: tableHeight,
                        child: pw.Row(
                          children: <pw.Widget>[
                            pw.Expanded(
                              child: pw.Center(
                                child: pw.Text(
                                  kgLabel,
                                  style: pw.TextStyle(
                                    font: pw.Font.helvetica(),
                                    fontSize: cellFontSize,
                                    color: _faintTextColor,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Center(
                                child: pw.Text(
                                  repsLabel,
                                  style: pw.TextStyle(
                                    font: pw.Font.helvetica(),
                                    fontSize: cellFontSize,
                                    color: _faintTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  pw.Widget _buildPageFooter({
    required String pageLabel,
  }) {
    return pw.Positioned(
      right: _margin,
      bottom: _margin - 4,
      child: pw.Text(
        pageLabel,
        style: pw.TextStyle(
          font: pw.Font.helvetica(),
          fontSize: 14,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  String _pdfSafeText(String value) {
    return value
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('−', '-');
  }

  String _encodePlanQrUri({
    required String planName,
    required List<String> exerciseIds,
  }) {
    final root = <String, dynamic>{
      'format': 'mtor-plan',
      'version': 1,
      'plan': <String, dynamic>{
        'name': planName.trim(),
        'exerciseIds': exerciseIds
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList(growable: false),
      },
    };

    final json = jsonEncode(root);
    final code = base64Url.encode(utf8.encode(json)).replaceAll('=', '');

    return Uri(
      scheme: 'mtorque',
      host: 'plan',
      path: '/import',
      queryParameters: <String, String>{
        'c': code,
      },
    ).toString();
  }

  String _formatGeneratedAt(DateTime value, String languageCode) {
    final dd = value.day.toString().padLeft(2, '0');
    final mm = value.month.toString().padLeft(2, '0');
    final yyyy = value.year.toString().padLeft(4, '0');
    final hh = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');

    if (languageCode.toLowerCase() == 'de') {
      return '$dd.$mm.$yyyy $hh:$min';
    }

    return '$yyyy-$mm-$dd $hh:$min';
  }

  Future<Uint8List?> _loadExerciseImageAsPng(String exerciseId) async {
    final assetPath = await _resolveExerciseAssetPath(exerciseId);
    if (assetPath == null || assetPath.isEmpty) return null;

    try {
      final byteData = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final pngData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      image.dispose();

      return pngData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<String?> _resolveExerciseAssetPath(String exerciseId) async {
    final normalized = exerciseId.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    final manifestAssets = await _loadExerciseAssetManifest();
    final candidates = _buildCandidateBaseNames(normalized);

    const extensions = <String>[
      'webp',
      'gif',
      'png',
      'jpg',
      'jpeg',
    ];

    for (final candidate in candidates) {
      for (final ext in extensions) {
        final path = 'assets/images/exercises/$candidate.$ext';
        if (manifestAssets.contains(path)) {
          return path;
        }
      }
    }

    return null;
  }

  Future<Set<String>> _loadExerciseAssetManifest() {
    return _exerciseAssetManifestFuture ??= _loadExerciseAssetManifestInternal();
  }

  Future<Set<String>> _loadExerciseAssetManifestInternal() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest
          .listAssets()
          .where((key) => key.startsWith('assets/images/exercises/'))
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  List<String> _buildCandidateBaseNames(String rawId) {
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

      final asInt = int.tryParse(digits);
      if (asInt != null) {
        add('ex_${asInt.toString().padLeft(4, '0')}');
      }

      if (digits.isNotEmpty && suffix.isNotEmpty) {
        add('ex_$digits$suffix');
      }
    }

    return result;
  }
}

class StrengthPlanPrintNoExercisesException implements Exception {
  const StrengthPlanPrintNoExercisesException();
}

class _StrengthPlanPrintRow {
  const _StrengthPlanPrintRow({
    required this.exerciseId,
    required this.label,
    required this.imageBytes,
  });

  final String exerciseId;
  final String label;
  final Uint8List? imageBytes;
}