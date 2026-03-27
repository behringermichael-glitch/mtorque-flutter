import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';
import 'package:mtorque_flutter/core/theme/app_theme.dart';
import 'package:mtorque_flutter/features/dashboard/data/motivation_quotes.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = 'dashboard';
  static const String routePath = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

enum _TrainingDayType {
  none,
  strength,
  endurance,
  both,
}

enum _StrengthGoalType {
  sessions,
  sets,
}

enum _EnduranceGoalType {
  sessions,
  distance,
  duration,
}

class _YouTubeVideo {
  const _YouTubeVideo({
    required this.id,
    required this.title,
    required this.publishedMs,
  });

  final String id;
  final String title;
  final int publishedMs;

  String get thumbnailUrl => 'https://i.ytimg.com/vi/$id/hqdefault.jpg';
  String get watchUrl => 'https://www.youtube.com/watch?v=$id';
}

class _DashboardPageState extends State<DashboardPage> {
  static const String _motivationImageLight =
      'assets/images/dashboard/bg_gym_motivation_light.webp';
  static const String _motivationImageDark =
      'assets/images/dashboard/bg_gym_motivation_dark.webp';
  static const String _gymKnowledgePortrait =
      'assets/images/dashboard/gym_knowledge_portrait.png';

  static const String _genericStrengthTile =
      'assets/images/exercises/tile_strength_generic.webp';
  static const String _genericEnduranceTile =
      'assets/images/exercises/tile_endurance_generic.webp';

  static const String _ytChannelId = 'UChnPwNEMihYq-pDRamEohgQ';

  late final Future<List<_YouTubeVideo>> _youtubeFuture;

  final List<_TrainingDayType> _weekStatuses = const [
    _TrainingDayType.strength,
    _TrainingDayType.strength,
    _TrainingDayType.none,
    _TrainingDayType.none,
    _TrainingDayType.none,
    _TrainingDayType.none,
    _TrainingDayType.none,
  ];

  _StrengthGoalType _strengthGoalType = _StrengthGoalType.sets;
  int _strengthGoalValue = 42;
  int _strengthCurrentValue = 30;

  _EnduranceGoalType _enduranceGoalType = _EnduranceGoalType.sessions;
  int _enduranceGoalValue = 2;
  int _enduranceCurrentValue = 0;

  int _stepsGoal = 8000;
  int _todaySteps = 141;

  final List<int> _weekSteps = const [4200, 2300, 900, 0, 0, 0, 0];

  int _strengthStreakMonths = 2;
  int _enduranceStreakMonths = 0;

  @override
  void initState() {
    super.initState();
    _youtubeFuture = _fetchLatestYouTubeVideos();
  }

  List<DateTime> _weekDates(DateTime now) {
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List<DateTime>.generate(
      7,
          (index) => DateTime(
        monday.year,
        monday.month,
        monday.day + index,
      ),
    );
  }

  int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }

  String _dailyQuote(AppLocalizations l10n) {
    final quotes = <String>[
      l10n.dashboardQuoteOne,
      l10n.dashboardQuoteTwo,
      l10n.dashboardQuoteThree,
      l10n.dashboardQuoteFour,
      l10n.dashboardQuoteFive,
    ];

    final now = DateTime.now();
    final index = _dayOfYear(now) % quotes.length;
    return quotes[index];
  }

  Color _statusColor(_TrainingDayType type) {
    switch (type) {
      case _TrainingDayType.none:
        return const Color(0xFFBDBDBD);
      case _TrainingDayType.strength:
        return AppTheme.strengthBlue;
      case _TrainingDayType.endurance:
        return AppTheme.enduranceRed;
      case _TrainingDayType.both:
        return AppTheme.bothViolet;
    }
  }

  double _safeProgress(int current, int target) {
    if (target <= 0) return 0;
    return (current / target).clamp(0.0, 1.0);
  }

  String _strengthGoalUnit(AppLocalizations l10n) {
    switch (_strengthGoalType) {
      case _StrengthGoalType.sessions:
        return l10n.goalUnitsSessions;
      case _StrengthGoalType.sets:
        return l10n.goalUnitsSets;
    }
  }

  String _enduranceGoalUnit(AppLocalizations l10n) {
    switch (_enduranceGoalType) {
      case _EnduranceGoalType.sessions:
        return l10n.goalUnitsSessions;
      case _EnduranceGoalType.distance:
        return l10n.goalUnitsDistanceShort;
      case _EnduranceGoalType.duration:
        return l10n.goalUnitsDurationShort;
    }
  }

  Iterable<XmlElement> _childrenByLocalName(XmlNode node, String localName) {
    return node.children.whereType<XmlElement>().where((e) => e.name.local == localName);
  }

  String? _firstChildTextByLocalName(XmlNode node, String localName) {
    final element = _childrenByLocalName(node, localName).cast<XmlElement?>().firstWhere(
          (e) => e != null,
      orElse: () => null,
    );
    return element?.innerText.trim();
  }

  Future<List<_YouTubeVideo>> _fetchLatestYouTubeVideos() async {
    try {
      final uri = Uri.parse(
        'https://www.youtube.com/feeds/videos.xml?channel_id=$_ytChannelId',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return const [];

      final document = XmlDocument.parse(response.body);
      final entries = document.descendants.whereType<XmlElement>().where(
            (e) => e.name.local == 'entry',
      );

      final videos = <_YouTubeVideo>[];
      for (final entry in entries) {
        final id = _firstChildTextByLocalName(entry, 'videoId');
        final title = _firstChildTextByLocalName(entry, 'title');
        final published = _firstChildTextByLocalName(entry, 'published');

        if (id == null || id.isEmpty || title == null || title.isEmpty) {
          continue;
        }

        final publishedMs =
            DateTime.tryParse(published ?? '')?.millisecondsSinceEpoch ?? 0;

        videos.add(
          _YouTubeVideo(
            id: id,
            title: title,
            publishedMs: publishedMs,
          ),
        );
      }

      videos.sort((a, b) => b.publishedMs.compareTo(a.publishedMs));
      return videos.take(2).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _openYoutubeVideo(_YouTubeVideo video) async {
    final uri = Uri.parse(video.watchUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dashboardYoutubeOpenFailed)),
      );
    }
  }

  Future<ui.Image> _loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<XFile> _createQuoteShareImage(String quoteRaw) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgAsset = isDark ? _motivationImageDark : _motivationImageLight;

    const width = 1440.0;
    const height = 640.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      const Rect.fromLTWH(0, 0, width, height),
    );

    final bgImage = await _loadUiImage(bgAsset);

    final src = Rect.fromLTWH(
      0,
      0,
      bgImage.width.toDouble(),
      bgImage.height.toDouble(),
    );

    final srcAspect = src.width / src.height;
    final dstAspect = width / height;

    Rect cropRect;
    if (srcAspect > dstAspect) {
      final cropWidth = src.height * dstAspect;
      final left = (src.width - cropWidth) / 2;
      cropRect = Rect.fromLTWH(left, 0, cropWidth, src.height);
    } else {
      final cropHeight = src.width / dstAspect;
      final top = (src.height - cropHeight) / 2;
      cropRect = Rect.fromLTWH(0, top, src.width, cropHeight);
    }

    canvas.drawImageRect(
      bgImage,
      cropRect,
      const Rect.fromLTWH(0, 0, width, height),
      Paint(),
    );

    final scrimRect = const Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(
      scrimRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x55000000),
            Color(0x99000000),
          ],
        ).createShader(scrimRect),
    );

    final intro = l10n.dashboardShareQuoteIntro;
    final quote = '“$quoteRaw”';
    final watermark = l10n.dashboardShareQuoteWatermark;

    const textWidth = width * 0.86;
    final left = (width - textWidth) / 2;

    final introPainter = TextPainter(
      text: TextSpan(
        text: intro,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Color(0x99000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: textWidth);

    double quoteFontSize = 75;
    TextPainter quotePainter() {
      return TextPainter(
        text: TextSpan(
          text: quote,
          style: TextStyle(
            color: Colors.white,
            fontSize: quoteFontSize,
            fontWeight: FontWeight.w700,
            height: 1.05,
            shadows: const [
              Shadow(
                color: Color(0xAA000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: textWidth);
    }

    var qPainter = quotePainter();
    while (qPainter.height > height * 0.46 && quoteFontSize > 43) {
      quoteFontSize -= 5;
      qPainter = quotePainter();
    }

    introPainter.paint(canvas, Offset(left, height * 0.16));
    qPainter.paint(
      canvas,
      Offset(left, (height * 0.56) - (qPainter.height / 2)),
    );

    final watermarkPainter = TextPainter(
      text: TextSpan(
        text: watermark,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 43,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    const badgePadX = width * 0.02;
    const badgePadY = height * 0.02;
    final badgeW = watermarkPainter.width + badgePadX * 2;
    final badgeH = watermarkPainter.height + badgePadY * 2;
    final badgeLeft = (width - badgeW) / 2;
    const badgeTop = height * 0.86;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(badgeLeft, badgeTop, badgeW, badgeH),
        const Radius.circular(999),
      ),
      Paint()..color = const Color.fromARGB(125, 0, 0, 0),
    );

    watermarkPainter.paint(
      canvas,
      Offset(
        (width - watermarkPainter.width) / 2,
        badgeTop + badgePadY,
      ),
    );

    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final dir = Directory('${(await getTemporaryDirectory()).path}/shares');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File('${dir.path}/quote_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes, flush: true);
    return XFile(file.path);
  }

  Future<void> _shareDailyQuoteImage(String quote) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final file = await _createQuoteShareImage(quote);
      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          text: l10n.dashboardShareQuoteMessage(quote),
          title: l10n.dashboardShareQuoteDialogTitle,
          subject: l10n.dashboardShareQuoteDialogTitle,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dashboardShareQuoteFailed)),
      );
    }
  }

  Future<void> _showWeekLegendDialog() async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.dashboardWeekLegendTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.dashboardWeekLegendIntro),
              const SizedBox(height: 16),
              _LegendRow(
                color: _statusColor(_TrainingDayType.strength),
                text: l10n.dashboardWeekLegendStrength,
              ),
              const SizedBox(height: 10),
              _LegendRow(
                color: _statusColor(_TrainingDayType.endurance),
                text: l10n.dashboardWeekLegendEndurance,
              ),
              const SizedBox(height: 10),
              _LegendRow(
                color: _statusColor(_TrainingDayType.both),
                text: l10n.dashboardWeekLegendBoth,
              ),
              const SizedBox(height: 10),
              _LegendRow(
                color: _statusColor(_TrainingDayType.none),
                text: l10n.dashboardWeekLegendNone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMotivationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final quote = dailyMotivationQuote();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.dashboardShareQuoteDialogTitle),
          content: Text(l10n.dashboardShareQuoteDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _shareDailyQuoteImage(quote);
              },
              child: Text(l10n.dashboardShareQuoteActionShare),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showStrengthGoalDialog() async {
    final l10n = AppLocalizations.of(context)!;

    var selectedType = _strengthGoalType;
    final sessionsController = TextEditingController(
      text: selectedType == _StrengthGoalType.sessions
          ? _strengthGoalValue.toString()
          : '8',
    );
    final setsController = TextEditingController(
      text: selectedType == _StrengthGoalType.sets
          ? _strengthGoalValue.toString()
          : '42',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text(l10n.goalStrengthTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GoalRadioField(
                    title: l10n.goalUnitsSessions,
                    selected: selectedType == _StrengthGoalType.sessions,
                    controller: sessionsController,
                    onSelected: () {
                      setLocalState(() {
                        selectedType = _StrengthGoalType.sessions;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _GoalRadioField(
                    title: l10n.goalUnitsSets,
                    selected: selectedType == _StrengthGoalType.sets,
                    controller: setsController,
                    onSelected: () {
                      setLocalState(() {
                        selectedType = _StrengthGoalType.sets;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    final value = selectedType == _StrengthGoalType.sessions
                        ? int.tryParse(sessionsController.text)
                        : int.tryParse(setsController.text);

                    if (value == null || value <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.goalInvalidNumber)),
                      );
                      return;
                    }

                    setState(() {
                      _strengthGoalType = selectedType;
                      _strengthGoalValue = value;
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEnduranceGoalDialog() async {
    final l10n = AppLocalizations.of(context)!;

    var selectedType = _enduranceGoalType;
    final distanceController = TextEditingController(
      text: selectedType == _EnduranceGoalType.distance
          ? _enduranceGoalValue.toString()
          : '15',
    );
    final durationController = TextEditingController(
      text: selectedType == _EnduranceGoalType.duration
          ? _enduranceGoalValue.toString()
          : '150',
    );
    final sessionsController = TextEditingController(
      text: selectedType == _EnduranceGoalType.sessions
          ? _enduranceGoalValue.toString()
          : '2',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text(l10n.goalEnduranceTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GoalRadioField(
                    title: '${l10n.goalUnitsDistance} (${l10n.goalUnitsKm})',
                    selected: selectedType == _EnduranceGoalType.distance,
                    controller: distanceController,
                    onSelected: () {
                      setLocalState(() {
                        selectedType = _EnduranceGoalType.distance;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _GoalRadioField(
                    title: '${l10n.goalUnitsDuration} (${l10n.goalUnitsMin})',
                    selected: selectedType == _EnduranceGoalType.duration,
                    controller: durationController,
                    onSelected: () {
                      setLocalState(() {
                        selectedType = _EnduranceGoalType.duration;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _GoalRadioField(
                    title: l10n.goalUnitsSessions,
                    selected: selectedType == _EnduranceGoalType.sessions,
                    controller: sessionsController,
                    onSelected: () {
                      setLocalState(() {
                        selectedType = _EnduranceGoalType.sessions;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    final value = switch (selectedType) {
                      _EnduranceGoalType.distance =>
                          int.tryParse(distanceController.text),
                      _EnduranceGoalType.duration =>
                          int.tryParse(durationController.text),
                      _EnduranceGoalType.sessions =>
                          int.tryParse(sessionsController.text),
                    };

                    if (value == null || value <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.goalInvalidNumber)),
                      );
                      return;
                    }

                    setState(() {
                      _enduranceGoalType = selectedType;
                      _enduranceGoalValue = value;
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showStepsGoalDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _stepsGoal.toString());

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.dashboardStepsGoalDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.dashboardStepsGoalDialogMessage),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: l10n.dashboardStepsGoalInputHint,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value == null || value <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.dashboardStepsGoalInvalid)),
                  );
                  return;
                }

                setState(() {
                  _stepsGoal = value;
                });

                Navigator.of(context).pop();
              },
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showStreakInfoDialog() async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.streakInfoTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.streakInfoDescription),
                const SizedBox(height: 16),
                _StreakInfoRow(
                  stars: 1,
                  title: l10n.streakLevel1Title,
                  months: l10n.streakLevel1Months,
                ),
                const SizedBox(height: 8),
                _StreakInfoRow(
                  stars: 2,
                  title: l10n.streakLevel2Title,
                  months: l10n.streakLevel2Months,
                ),
                const SizedBox(height: 8),
                _StreakInfoRow(
                  stars: 3,
                  title: l10n.streakLevel3Title,
                  months: l10n.streakLevel3Months,
                ),
                const SizedBox(height: 8),
                _StreakInfoRow(
                  stars: 4,
                  title: l10n.streakLevel4Title,
                  months: l10n.streakLevel4Months,
                ),
                const SizedBox(height: 8),
                _StreakInfoRow(
                  stars: 5,
                  title: l10n.streakLevel5Title,
                  months: l10n.streakLevel5Months,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dates = _weekDates(now);
    final quote = dailyMotivationQuote();
    final isDark = theme.brightness == Brightness.dark;
    final motivationBackground =
    isDark ? _motivationImageDark : _motivationImageLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
          children: [
            GestureDetector(
              onTap: _showWeekLegendDialog,
              child: _WeekOverviewCard(
                dates: dates,
                statuses: _weekStatuses,
                statusColor: _statusColor,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showMotivationDialog,
              child: _MotivationCard(
                backgroundAsset: motivationBackground,
                teaser: l10n.dashboardMotivationTeaser,
                quote: '“${quote.toUpperCase()}”',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showStrengthGoalDialog,
                    child: _GoalCard(
                      title: l10n.navStrength,
                      accentColor: AppTheme.strengthBlue,
                      progress:
                      _safeProgress(_strengthCurrentValue, _strengthGoalValue),
                      valueText: '${_strengthCurrentValue}/${_strengthGoalValue}',
                      unitText: _strengthGoalUnit(l10n),
                      footerText: l10n.dashboardTapToEdit,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _showEnduranceGoalDialog,
                    child: _GoalCard(
                      title: l10n.navEndurance,
                      accentColor: AppTheme.enduranceRed,
                      progress:
                      _safeProgress(_enduranceCurrentValue, _enduranceGoalValue),
                      valueText:
                      '${_enduranceCurrentValue}/${_enduranceGoalValue}',
                      unitText: _enduranceGoalUnit(l10n),
                      footerText: l10n.dashboardTapToEdit,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showStepsGoalDialog,
                    child: _StepsCard(
                      title: l10n.dashboardStepsTitle,
                      value: _todaySteps.toString(),
                      goalText: l10n.dashboardStepsGoalFormat(_stepsGoal),
                      weekSteps: _weekSteps,
                      goal: _stepsGoal,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _showStreakInfoDialog,
                    child: _StreaksCard(
                      title: l10n.dashboardStreaksTitle,
                      hint: l10n.dashboardStreaksHint,
                      strengthLabel: l10n.navStrength,
                      enduranceLabel: l10n.navEndurance,
                      strengthMonths: _strengthStreakMonths,
                      enduranceMonths: _enduranceStreakMonths,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _QuickStartSection(
              title: l10n.dashboardQuickStartTitle,
              strengthTitle: l10n.navStrength,
              enduranceTitle: l10n.navEndurance,
              strengthSubtitle: l10n.dashboardQuickStartStrengthSubtitle,
              enduranceSubtitle: l10n.dashboardQuickStartEnduranceSubtitle,
              strengthImageAsset: _genericStrengthTile,
              enduranceImageAsset: _genericEnduranceTile,
            ),
            const SizedBox(height: 12),
            _GymKnowledgeCard(
              title: l10n.dashboardGymKnowledgeTitle,
              portraitAsset: _gymKnowledgePortrait,
              youtubeFuture: _youtubeFuture,
              onVideoTap: _openYoutubeVideo,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekOverviewCard extends StatelessWidget {
  const _WeekOverviewCard({
    required this.dates,
    required this.statuses,
    required this.statusColor,
  });

  final List<DateTime> dates;
  final List<_TrainingDayType> statuses;
  final Color Function(_TrainingDayType type) statusColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.weekdayMonShort,
      l10n.weekdayTueShort,
      l10n.weekdayWedShort,
      l10n.weekdayThuShort,
      l10n.weekdayFriShort,
      l10n.weekdaySatShort,
      l10n.weekdaySunShort,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Row(
              children: List.generate(labels.length, (index) {
                final date = dates[index];
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        labels[index],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}.${date.month}.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor(statuses[index]),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dashboardWeekOverviewHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  const _MotivationCard({
    required this.backgroundAsset,
    required this.teaser,
    required this.quote,
  });

  final String backgroundAsset;
  final String teaser;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 160,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                );
              },
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x44000000),
                    Color(0x99000000),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    teaser.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Center(
                      child: _AdaptiveQuoteText(
                        quote: quote,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdaptiveQuoteText extends StatelessWidget {
  const _AdaptiveQuoteText({
    required this.quote,
  });

  final String quote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const maxFontSize = 26.0;
        const minFontSize = 16.0;
        const step = 1.0;
        const maxLines = 3;

        double fontSize = maxFontSize;

        TextPainter buildPainter(double size) {
          return TextPainter(
            text: TextSpan(
              text: quote,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size,
                height: 1.02,
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: maxLines,
          )..layout(maxWidth: constraints.maxWidth);
        }

        var painter = buildPainter(fontSize);

        while ((painter.didExceedMaxLines ||
            painter.height > constraints.maxHeight) &&
            fontSize > minFontSize) {
          fontSize -= step;
          painter = buildPainter(fontSize);
        }

        return Text(
          quote,
          textAlign: TextAlign.center,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            height: 1.02,
          ),
        );
      },
    );
  }
}

class _AutoSizeQuoteText extends StatelessWidget {
  const _AutoSizeQuoteText({
    required this.quote,
    this.maxLines = 3,
    this.maxFontSize = 26,
    this.minFontSize = 16,
  });

  final String quote;
  final int maxLines;
  final double maxFontSize;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = 24;
        const minFontSize = 14.0;

        TextPainter buildPainter(double size) {
          return TextPainter(
            text: TextSpan(
              text: quote,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.04,
                fontSize: size,
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: maxLines,
          )..layout(maxWidth: constraints.maxWidth);
        }

        var painter = buildPainter(fontSize);
        while ((painter.didExceedMaxLines || painter.height > constraints.maxHeight) &&
            fontSize > minFontSize) {
          fontSize -= 1;
          painter = buildPainter(fontSize);
        }

        return Text(
          quote,
          textAlign: TextAlign.center,
          maxLines: maxLines,
          overflow: TextOverflow.clip,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.04,
            fontSize: fontSize,
          ),
        );
      },
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.title,
    required this.accentColor,
    required this.progress,
    required this.valueText,
    required this.unitText,
    required this.footerText,
  });

  final String title;
  final Color accentColor;
  final double progress;
  final String valueText;
  final String unitText;
  final String footerText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            _ArcGauge(
              progress: progress,
              color: accentColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valueText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unitText,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              footerText,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcGauge extends StatelessWidget {
  const _ArcGauge({
    required this.progress,
    required this.color,
    required this.child,
  });

  final double progress;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: CustomPaint(
        painter: _ArcGaugePainter(
          progress: progress,
          color: color,
          trackColor: Theme.of(context).dividerColor,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _ArcGaugePainter extends CustomPainter {
  _ArcGaugePainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    const startAngle = math.pi * 0.75;
    const totalSweep = math.pi * 1.5;

    final rect = Offset.zero & size;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = const Color(0xFFD6D6D6);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      totalSweep,
      false,
      trackPaint,
    );
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      totalSweep * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({
    required this.title,
    required this.value,
    required this.goalText,
    required this.weekSteps,
    required this.goal,
  });

  final String title;
  final String value;
  final String goalText;
  final List<int> weekSteps;
  final int goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.directions_walk,
                  size: 18,
                  color: AppTheme.settingsGreen,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              goalText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 86,
              child: _StepsBars(
                values: weekSteps,
                goal: goal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.dashboardTapToEdit,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepsBars extends StatelessWidget {
  const _StepsBars({
    required this.values,
    required this.goal,
  });

  final List<int> values;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.weekdayMonShort.replaceAll('.', ''),
      l10n.weekdayTueShort.replaceAll('.', ''),
      l10n.weekdayWedShort.replaceAll('.', ''),
      l10n.weekdayThuShort.replaceAll('.', ''),
      l10n.weekdayFriShort.replaceAll('.', ''),
      l10n.weekdaySatShort.replaceAll('.', ''),
      l10n.weekdaySunShort.replaceAll('.', ''),
    ];

    final maxValue = values.fold<int>(1, (prev, e) => math.max(prev, e));

    // Ziel-Linie soll wie im Original im oberen Bereich liegen,
    // aber dennoch Luft nach oben lassen.
    const desiredGoalFraction = 0.78; // 78 % der Höhe
    final chartMaxFromGoal = goal > 0 ? (goal / desiredGoalFraction).ceil() : 1;
    final chartMaxFromValues = (maxValue * 1.08).ceil();
    final chartMax = math.max(chartMaxFromGoal, chartMaxFromValues);

    final goalFraction =
    chartMax <= 0 ? 0.0 : (goal / chartMax).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        const chartHeight = 58.0;
        final lineTop = (1 - goalFraction) * chartHeight;

        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: lineTop.clamp(0.0, chartHeight - 1.4),
              child: Container(
                height: 1.4,
                color: Colors.grey.shade600,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final fraction =
                chartMax <= 0 ? 0.0 : (values[index] / chartMax).clamp(0.0, 1.0);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: chartHeight,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  width: 12,
                                  height: chartHeight,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD6D6D6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: chartHeight * fraction,
                                  decoration: BoxDecoration(
                                    color: AppTheme.settingsGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _StreaksCard extends StatelessWidget {
  const _StreaksCard({
    required this.title,
    required this.hint,
    required this.strengthLabel,
    required this.enduranceLabel,
    required this.strengthMonths,
    required this.enduranceMonths,
  });

  final String title;
  final String hint;
  final String strengthLabel;
  final String enduranceLabel;
  final int strengthMonths;
  final int enduranceMonths;

  int _starCount(int months) => months.clamp(0, 5);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 18,
                  color: AppTheme.statsOrange,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CompactStreakRow(
              label: strengthLabel,
              stars: _starCount(strengthMonths),
              trailing: l10n.dashboardMonthsShort(strengthMonths),
            ),
            const SizedBox(height: 8),
            _CompactStreakRow(
              label: enduranceLabel,
              stars: _starCount(enduranceMonths),
              trailing: l10n.dashboardMonthsShort(enduranceMonths),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactStreakRow extends StatelessWidget {
  const _CompactStreakRow({
    required this.label,
    required this.stars,
    required this.trailing,
  });

  final String label;
  final int stars;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 1,
                runSpacing: 1,
                children: List.generate(5, (index) {
                  final filled = index < stars;
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 18,
                    color:
                    filled ? AppTheme.statsOrange : Theme.of(context).dividerColor,
                  );
                }),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              trailing,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStartSection extends StatelessWidget {
  const _QuickStartSection({
    required this.title,
    required this.strengthTitle,
    required this.enduranceTitle,
    required this.strengthSubtitle,
    required this.enduranceSubtitle,
    required this.strengthImageAsset,
    required this.enduranceImageAsset,
  });

  final String title;
  final String strengthTitle;
  final String enduranceTitle;
  final String strengthSubtitle;
  final String enduranceSubtitle;
  final String strengthImageAsset;
  final String enduranceImageAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _QuickStartTile(
                title: strengthTitle,
                subtitle: strengthSubtitle,
                imageAsset: strengthImageAsset,
                accentColor: AppTheme.strengthBlue,
                fallbackIcon: Icons.fitness_center,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickStartTile(
                title: enduranceTitle,
                subtitle: enduranceSubtitle,
                imageAsset: enduranceImageAsset,
                accentColor: AppTheme.enduranceRed,
                fallbackIcon: Icons.favorite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStartTile extends StatelessWidget {
  const _QuickStartTile({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.accentColor,
    required this.fallbackIcon,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
  final Color accentColor;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 136,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: accentColor.withValues(alpha: 0.12),
                  child: Center(
                    child: Icon(
                      fallbackIcon,
                      color: accentColor,
                      size: 34,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GymKnowledgeCard extends StatelessWidget {
  const _GymKnowledgeCard({
    required this.title,
    required this.portraitAsset,
    required this.youtubeFuture,
    required this.onVideoTap,
  });

  final String title;
  final String portraitAsset;
  final Future<List<_YouTubeVideo>> youtubeFuture;
  final Future<void> Function(_YouTubeVideo video) onVideoTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final portraitWidth = totalWidth * 0.34;
                final rightWidth = totalWidth - portraitWidth - 10;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: portraitWidth,
                      child: FutureBuilder<List<_YouTubeVideo>>(
                        future: youtubeFuture,
                        builder: (context, snapshot) {
                          final videos = snapshot.data ?? const [];
                          final shownVideos = videos.take(2).toList();

                          // Solange noch keine Videos da sind, Fallback-Höhe
                          final fallbackHeight = 260.0;

                          double estimatedTileHeight() {
                            // 16:9 Thumbnail + Titelbereich + Padding
                            final thumbHeight = rightWidth / (16 / 9);
                            const titleArea = 44.0;
                            return thumbHeight + titleArea;
                          }

                          final tileHeight = estimatedTileHeight();
                          final totalHeight = shownVideos.length >= 2
                              ? (tileHeight * 2) + 8
                              : fallbackHeight;

                          return Container(
                            height: totalHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1ECE7),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                portraitAsset,
                                fit: BoxFit.cover,
                                alignment: const Alignment(0.0, 0.15),
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.person_outline, size: 34),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FutureBuilder<List<_YouTubeVideo>>(
                        future: youtubeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                l10n.dashboardYoutubeLoading,
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          }

                          final videos = snapshot.data ?? const [];
                          if (videos.isEmpty) {
                            return Text(
                              l10n.dashboardYoutubeUnavailable,
                              style: theme.textTheme.bodySmall,
                            );
                          }

                          final shownVideos = videos.take(2).toList();

                          return Column(
                            children: [
                              for (var i = 0; i < shownVideos.length; i++) ...[
                                _YoutubePreviewTile(
                                  video: shownVideos[i],
                                  onTap: () => onVideoTap(shownVideos[i]),
                                ),
                                if (i != shownVideos.length - 1)
                                  const SizedBox(height: 8),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _YoutubePreviewTile extends StatelessWidget {
  const _YoutubePreviewTile({
    required this.video,
    required this.onTap,
  });

  final _YouTubeVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFF1ECE7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 34,
                          color: theme.colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _GoalRadioField extends StatelessWidget {
  const _GoalRadioField({
    required this.title,
    required this.selected,
    required this.controller,
    required this.onSelected,
  });

  final String title;
  final bool selected;
  final TextEditingController controller;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: selected,
            onChanged: (_) => onSelected(),
          ),
          Expanded(
            child: Text(title),
          ),
          SizedBox(
            width: 90,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
              ),
              onTap: onSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakInfoRow extends StatelessWidget {
  const _StreakInfoRow({
    required this.stars,
    required this.title,
    required this.months,
  });

  final int stars;
  final String title;
  final String months;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            final filled = index < stars;
            return Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 18,
              color: filled ? AppTheme.statsOrange : Theme.of(context).dividerColor,
            );
          }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$title $months',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}