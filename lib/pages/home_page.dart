import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/default_scaffold.dart';
import '../widgets/message.dart';
import '../export/notelog_essential.dart';
import '../export/basic_utils.dart';
import '../widgets/detail_log/details_log.dart';

class HomePage extends StatelessWidget {
  final isarService = IsarService();

  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: EmologForm(isarService: isarService),
      ),
    );
  }
}

class EmologForm extends StatefulWidget {
  const EmologForm({super.key, required this.isarService});
  final IsarService isarService;
  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  NoteLog _newLog = NoteLog();

  Future<void> _saveLog() async {
    final savedNote = await widget.isarService.saveNote(_newLog);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('log ${savedNote.id} has been recorded'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await widget.isarService.deleteNoteById(savedNote.id);
            },
          ),
        ),
      );
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
          child: DetailsLogContent(
            isarService: widget.isarService,
            onLogUpdated: (updatedLog) => _newLog = updatedLog,
          ),
        ),
        const SizedBox(height: kPaddingLarge),
        ElevatedButton(
          onPressed: () async => _saveLog(),
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}
