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
import '../app_messenger.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 0,
      child: Builder(
        builder: (scaffoldContext) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: EmologForm(scaffoldContext: scaffoldContext),
          );
        },
      ),
    );
  }
}

class EmologForm extends StatelessWidget {
  final BuildContext scaffoldContext;
  const EmologForm({super.key, required this.scaffoldContext});
  // late NoteImage image;
  Future<void> _saveLog() async {
    final l10n = AppLocalizations.of(scaffoldContext)!;
    final logProvider = scaffoldContext.read<LogProvider>();
    final userUid = scaffoldContext.read<UserProvider>().user?.uid;
    if (userUid == null) {
      throw Exception("No user logged in");
    }
    try {
      final savedLogId = await logProvider.addLog(userUid);
      appMessengerKey.currentState!
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(l10n.logRecorded(savedLogId)),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => logProvider.deleteLog(id: savedLogId),
            ),
          ),
        );

      // setState(() => image = NoteImage());
    } catch (e) {
      appMessengerKey.currentState!
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
              onPressed: () => _saveLog(),
              child: Text(AppLocalizations.of(scaffoldContext)!.submit),
            ),
          ],
        ),
      ),
    ),
  );
}
