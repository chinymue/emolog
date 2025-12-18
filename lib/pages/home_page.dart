import 'package:emolog/isar/model/note_image.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/provider/user_pvd.dart';
// import 'package:emolog/widgets/template/image_picker_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../widgets/template/scaffold_template.dart';
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

class EmologForm extends StatefulWidget {
  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  late NoteImage image;

  Future<void> _saveLog(BuildContext c) async {
    final l10n = AppLocalizations.of(c)!;
    final logProvider = c.read<LogProvider>();
    final userUid = c.read<UserProvider>().user?.uid;
    if (userUid == null) {
      throw Exception("No user logged in");
    }
    try {
      final savedLogId = await logProvider.addLog(userUid);
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

      setState(() => image = NoteImage());
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
    child: SizedBox(
      height: MediaQuery.of(c).size.height,
      width: MediaQuery.of(c).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HelloLog(),
            const SizedBox(height: kPadding),
            // ImagePickerTemplate(
            //   maxHeight: 200,
            //   maxWidth: 400,
            //   onImageConfirmed: (noteImg) {
            //     // TODO: save cropped / edited image
            //     setState(() => image = noteImg);
            //   },
            // ),
            SizedBox(
              height: kFormMaxHeight + kSingleRowScrollHeight,
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
      ),
    ),
  );
}
