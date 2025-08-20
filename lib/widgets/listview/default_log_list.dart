import '../../export/package/app_essential.dart';
import 'dart:async';
import '../../export/provider/log_provider.dart';
import '../../provider/log_view_pvd.dart';
import '../../export/common_utils.dart';
import '../../widgets/detail_log/details_log.dart';

class DefaultList extends StatelessWidget {
  const DefaultList({super.key});

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    final textTheme = Theme.of(c).textTheme;
    final logViewPvd = c.watch<LogViewProvider>();
    final logs = logViewPvd.allLogs;

    if (logs.isEmpty && logViewPvd.isFetchedLogs) {
      return Center(
        child: Text(
          'No logs yet',
          style: textTheme.displayMedium?.copyWith(color: colorScheme.primary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: logs.length,
      itemBuilder: (c, i) {
        final log = logs[i];

        void handleDissmis() => c.read<LogProvider>().deleteLog(id: log.id);

        return Dismissible(
          key: ValueKey(log.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => handleDissmis(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: kPaddingLarge),
            color: colorScheme.errorContainer,
            child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
          ),
          child: DefaultLogTile(logId: log.id),
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

    void handleFavor() {
      c.read<LogProvider>().updateLogFavor(id: logId);
      c.read<LogProvider>().saveUpdatedLog(id: logId);
    }

    Future<void> handleTap() async => await Navigator.push(
      c,
      MaterialPageRoute(builder: (c) => DetailsLog(logId: logId)),
    );

    return ListTile(
      onTap: () => handleTap(),
      leading: IconButton(
        icon: Icon(
          Icons.monitor_heart,
          size: iconSize,
          color: log.isFavor
              ? colorScheme.primary
              : adjustLightness(colorScheme.primary, 0.4),
        ),
        onPressed: () => handleFavor(),
        splashRadius: kSplashRadius,
        tooltip: log.isFavor ? 'Unfavourite' : 'Favourite',
      ),
      title: Text(
        shortenText(plainTextFromDeltaJson(log.note)),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        formatShortDateTime(log.date),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
      trailing: Icon(
        moods[log.labelMood],
        size: iconSizeLarge,
        color: colorScheme.primary,
      ),
    );
  }
}
