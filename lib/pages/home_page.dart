import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/utils/data_utils.dart';
import 'package:emolog/widgets/template/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../widgets/template/scaffold_template.dart';
import '../widgets/message.dart';
import '../../provider/log_pvd.dart';
import '../utils/constant.dart';
import '../../widgets/detail_log/mood_picker.dart';
import '../../widgets/detail_log/quill_utils.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: EmologForm(),
      ),
    );
  }
}

class EmologForm extends StatefulWidget {
  EmologForm({super.key});

  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  DateTime _currentDate = DateTime.now();
  late final quill.QuillController _quillCtrl;

  @override
  void initState() {
    super.initState();
    _quillCtrl = quill.QuillController(
      document: docFromJson(""),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillCtrl.dispose();
    super.dispose();
  }

  String buildMessageByMoodLevel(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.awesome:
        return "Great! Keep it up!";
      case MoodLevel.good:
        return "Good to hear you're happy!";
      case MoodLevel.chill:
        return "Life is just keep going on.";
      case MoodLevel.not_good:
        return "Sorry to hear that. Hope things get better soon.";
      case MoodLevel.terrible:
        return "Take a deep breath. It's okay to lay down sometimes.";
    }
  }

  Future<void> _saveLog(BuildContext c) async {
    final l10n = AppLocalizations.of(c)!;
    final logProvider = c.read<LogProvider>();
    final userUid = c.read<UserProvider>().user?.uid;
    if (userUid == null) {
      throw Exception("No user logged in");
    }
    try {
      final savedMood = await logProvider.addLog(userUid, date: _currentDate);
      if (savedMood == null) {
        _replyMoodSelected(c, isSaved: false);
      } else {
        _replyMoodSelected(c, mood: savedMood);
        _quillCtrl.replaceText(
          0,
          _quillCtrl.document.length,
          '',
          const TextSelection.collapsed(offset: 0),
        );
      }
    } catch (e) {
      _replyMoodSelected(c, isSaved: false);
      print(e);
    }
  }

  void _replyMoodSelected(
    BuildContext c, {
    bool isSaved = true,
    MoodLevel? mood,
  }) {
    showDialog(
      context: c,
      builder: (c) => AlertDialog(
        title: isSaved ? Text("Saved successfully!") : Text("Saved failed!"),
        content: isSaved
            ? (mood != null
                  ? Text(buildMessageByMoodLevel(mood))
                  : Text("You have already logged for this date."))
            : Text("An error occurred while saving your log."),
        actions: [],
      ),
    );
  }

  @override
  Widget build(BuildContext c) => SizedBox(
    height: MediaQuery.of(c).size.height,
    width: MediaQuery.of(c).size.width,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HelloLog(),
            const SizedBox(height: kPadding),
            TimePickerExampleWidget(onChanged: (value) => _currentDate = value),
            const SizedBox(height: kPadding),
            MoodPicker(
              onMoodSelected: (mood) =>
                  c.read<LogProvider>().updateLabelMood(mood),
            ),
            DefaultQuillEditor(
              controller: _quillCtrl,
              onContentChanged: (doc) => c.read<LogProvider>().updateNote(doc),
            ),
            ElevatedButton(
              onPressed: () => _saveLog(c),
              child: Text(AppLocalizations.of(c)!.submit),
            ),
          ],
        ),
      ),
    ),
  );
}
