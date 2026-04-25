import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/services/strength_plan_print_service.dart';

class StrengthPlanPrintDialogs {
  const StrengthPlanPrintDialogs._();

  static Future<String?> selectPlan(
      BuildContext context, {
        required List<dynamic> plans,
      }) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthPrintPlanSelectTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: plans.isEmpty
                ? Text(l10n.strengthNoPlansAvailable)
                : ListView.builder(
              shrinkWrap: true,
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final name = plan.name.toString();

                return ListTile(
                  title: Text(name),
                  onTap: () => Navigator.of(dialogContext).pop(name),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.strengthCommonCancel),
            ),
          ],
        );
      },
    );
  }

  static Future<int?> selectSetsPerExercise(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(l10n.strengthPrintPlanSetsTitle),
          children: [
            for (final sets
            in StrengthPlanPrintService.allowedSetsPerExercise)
              SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext).pop(sets),
                child: Text(l10n.strengthPrintSetsOption(sets)),
              ),
          ],
        );
      },
    );
  }

  static Future<String?> enterOptionalComment(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    return showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthPrintPlanCommentTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.strengthPrintPlanCommentMessage),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: l10n.strengthPrintPlanCommentHint,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(l10n.strengthPrintPlanCommentSkip),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.of(dialogContext).pop(text.isEmpty ? null : text);
              },
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }
}