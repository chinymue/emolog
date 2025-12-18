import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/widgets/detail_log/mood_picker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../isar/model/notelog.dart';
import '../../provider/log_pvd.dart';
import '../../provider/log_view_pvd.dart';
import '../../utils/constant.dart';
import '../../utils/data_utils.dart';
import '../../widgets/detail_log/details_log.dart';
import '../../provider/relax_view_pvd.dart';
import '../../provider/relax_pvd.dart';

class DefaultList extends StatelessWidget {
  const DefaultList({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    final textTheme = Theme.of(c).textTheme;
    late List<dynamic> data;
    if (type == "log") {
      final logViewPvd = c.watch<LogViewProvider>();
      final logs = logViewPvd.allLogs;

      if (logs.isEmpty && logViewPvd.isFetchedLogs) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Text(
              AppLocalizations.of(c)!.logNotFound,
              style: textTheme.displayMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        );
      } else {
        data = logs;
      }
    } else if (type == "relax") {
      final relaxViewPvd = c.watch<RelaxViewProvider>();
      final relaxs = relaxViewPvd.allRelaxs;
      if (relaxs.isEmpty && relaxViewPvd.isFetchedRelaxs) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Text(
              "Chưa có phiên tập trung nào được ghi lại",
              style: textTheme.displayMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        );
      } else {
        data = relaxs;
      }
    } else {
      data = [];
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: data.length,
      itemBuilder: (c, i) {
        final item = data[i];

        void handleDissmis() {
          if (type == "log") {
            c.read<LogProvider>().deleteLog(id: item.id);
          } else if (type == "relax") {
            c.read<RelaxProvider>().deleteRelax(id: item.id);
          }
        }

        Widget showListTile() {
          if (type == "log") {
            return DefaultLogTile(logId: item.id);
          } else if (type == "relax") {
            return ListTile(title: Text(item.id.toString()));
            // DefaultRelaxTile(relaxId: item.id);
          } else {
            return ListTile(title: Text("Unknown type"));
          }
        }

        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => handleDissmis(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: kPaddingLarge),
            color: colorScheme.errorContainer,
            child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
          ),
          child: showListTile(),
        );
      },
    );
  }
}

class DefaultLogTile extends StatelessWidget {
  final int logId;

  const DefaultLogTile({super.key, required this.logId});

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final log = c.select<LogProvider, NoteLog>(
      (provider) => provider.logs.firstWhere((l) => l.id == logId),
    );

    void handleFavor() async =>
        await c.read<LogProvider>().updateLogFavor(id: logId, isSaved: true);

    Future<void> handleTap() async => await Navigator.push(
      c,
      MaterialPageRoute(builder: (c) => DetailsLog(logId: logId)),
    );

    final l10n = AppLocalizations.of(c)!;

    return ListTile(
      onTap: () => handleTap(),
      leading: IconButton(
        icon: Icon(
          log.isFavor ? Icons.favorite : Icons.favorite_border,
          size: iconSize,
          color: colorScheme.primary,
        ),
        onPressed: () => handleFavor(),
        splashRadius: kSplashRadius,
        tooltip: log.isFavor ? l10n.logUnfavor : l10n.logFavor,
      ),
      title: Text(
        shortenText(plainTextFromDeltaJson(log.note)),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        formatShortDateTime(log.date),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
      trailing: Tooltip(
        message: localizedMood(l10n, log.labelMood!),
        child: Icon(
          moods[log.labelMood],
          size: iconSizeLarge,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

// class DefaultRelaxTile extends StatelessWidget {
//   final int relaxId;

//   const DefaultRelaxTile({super.key, required this.relaxId});

//   @override
//   Widget build(BuildContext c) {
//     final textTheme = Theme.of(c).textTheme;
//     final colorScheme = Theme.of(c).colorScheme;
//     final relax = c.select<RelaxProvider, Relax>(
//       (provider) => provider.relaxs.firstWhere((l) => l.id == relaxId),
//     );

//     void handleFavor() async =>
//         await c.read<RelaxProvider>().updateRelaxFavor(id: relaxId, isSaved: true);

//     Future<void> handleTap() async => await Navigator.push(
//       c,
//       MaterialPageRoute(builder: (c) => DetailsLog(logId: relaxId)),
//     );

//     final l10n = AppLocalizations.of(c)!;

//     return ListTile(
//       onTap: () => handleTap(),
//       leading: IconButton(
//         icon: Icon(
//           log.isFavor ? Icons.favorite : Icons.favorite_border,
//           size: iconSize,
//           color: colorScheme.primary,
//         ),
//         onPressed: () => handleFavor(),
//         splashRadius: kSplashRadius,
//         tooltip: log.isFavor ? l10n.logUnfavor : l10n.logFavor,
//       ),
//       title: Text(
//         shortenText(plainTextFromDeltaJson(log.note)),
//         style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
//       ),
//       subtitle: Text(
//         formatShortDateTime(log.date),
//         style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
//       ),
//       trailing: Tooltip(
//         message: localizedMood(l10n, log.labelMood!),
//         child: Icon(
//           moods[log.labelMood],
//           size: iconSizeLarge,
//           color: colorScheme.primary,
//         ),
//       ),
//     );
//   }
// }
