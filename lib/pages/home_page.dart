import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../widgets/default_scaffold.dart';
import '../widgets/message.dart';
import '../utils/constant.dart';
import '../export/log_essential.dart';

class HomePage extends StatelessWidget {
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
  late final quill.QuillController _controller;
  String _selectedLabelMood = 'chill';
  // int _selectedNumericMood = 0;
  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      _controller.clear();
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
          MoodPicker(
            selectedMood: _selectedLabelMood,
            onMoodSelected: (mood) => setState(() => _selectedLabelMood = mood),
          ),
          const SizedBox(height: kPaddingLarge),
          SizedBox(
            height: kFormMaxHeight,
            width: kFormMaxWidth,
            child: DefaultQuillEditor(
              controller: _controller,
              hintText: 'Tell me your feelings',
            ),
          ),
          const SizedBox(height: kPaddingLarge),
          ElevatedButton(onPressed: _submitForm, child: const Text('Submit')),
        ],
      ),
    ),
  );
}
