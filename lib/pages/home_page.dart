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
      child: Padding(padding: const EdgeInsets.all(20), child: EmologForm()),
    );
  }
}

class EmologForm extends StatefulWidget {
  const EmologForm({super.key});
  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final isarService = IsarService();
      final savedNote = await isarService.saveNote(
        NoteLog()
          ..note = plainTextToDelta(_controller.document)
          ..labelMood = _selectedLabelMood
          ..date = DateTime.now(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
        ..showSnackBar(
          SnackBar(
            content: Text('log ${savedNote.id} has been recorded'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await isarService.deleteNoteById(savedNote.id);
              },
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext c) => Form(
    key: _formKey,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          HelloLog(),
          const SizedBox(height: kPadding),
          SizedBox(
            height: kFormMaxHeight + kSingleRowScrollMaxHeight,
            width: kFormMaxWidth,
            child: DetailsLog(),
          ),
          const SizedBox(height: kPaddingLarge),
          ElevatedButton(onPressed: _submitForm, child: const Text('Submit')),
        ],
      ),
    ),
  );
}
