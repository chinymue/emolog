import '../export/app_essential.dart';
import 'dart:async';
import '../widgets/default_scaffold.dart';
import '../widgets/message.dart';
import '../export/notelog_essential.dart';
import '../export/basic_utils.dart';
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
    final logProvider = c.read<LogProvider>();
    try {
      final savedLog = await logProvider.addLog();
      if (!c.mounted) return;
      ScaffoldMessenger.of(c)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('log ${savedLog.id} has been recorded'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => logProvider.deleteLog(id: savedLog.id),
            ),
          ),
        );
    } catch (e) {
      if (!c.mounted) return;
      ScaffoldMessenger.of(c)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Save failed: $e')));
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
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}
