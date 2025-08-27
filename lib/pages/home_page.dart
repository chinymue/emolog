import 'package:emolog/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../widgets/scaffold_template.dart';
import '../widgets/message.dart';
import '../../provider/log_pvd.dart';
import '../utils/constant.dart';
import '../widgets/detail_log/details_log.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 0,
      child: Padding(padding: const EdgeInsets.all(20), child: EmologForm()),
    );
  }
}

class EmologForm extends StatelessWidget {
  const EmologForm({super.key});
  Future<void> _saveLog(BuildContext c) async {
    final l10n = AppLocalizations.of(c)!;
    final logProvider = c.read<LogProvider>();
    try {
      final savedLogId = await logProvider.addLog();

      if (!c.mounted) return;
      ScaffoldMessenger.of(c)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.logRecorded(savedLogId)),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => logProvider.deleteLog(id: savedLogId),
            ),
          ),
        );
    } catch (e) {
      if (!c.mounted) return;
      ScaffoldMessenger.of(c)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
      print(e);
    }
  }

  @override
  Widget build(BuildContext c) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HelloLog(),
        const SizedBox(height: kPadding),
        SizedBox(
          height: kFormMaxHeight + kSingleRowScrollMaxHeight,
          width: kFormMaxWidth,
          child: DetailsLogContent(),
        ),
        const SizedBox(height: kPaddingLarge),
        ElevatedButton(
          onPressed: () => _saveLog(c),
          child: Text(AppLocalizations.of(c)!.submit),
        ),
      ],
    ),
  );
}
