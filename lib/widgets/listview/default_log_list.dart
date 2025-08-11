import '../../export/app_essential.dart';
import 'dart:async';
import '../../export/notelog_essential.dart';
import '../../export/common_utils.dart';
import '../../widgets/detail_log/details_log.dart';

class DefaultList extends StatelessWidget {
  const DefaultList({super.key});

  @override
  Widget build(BuildContext c) {
    final logProvider = c.watch<LogProvider>();
    final logs = logProvider.logs;
    if (logs.isEmpty) {
      return Center(
        child: Text('No logs yet', style: Theme.of(c).textTheme.displayMedium),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: logs.length,
      itemBuilder: (c, i) {
        final log = logs[i];
        final colorScheme = Theme.of(c).colorScheme;

        void handleDissmis() => logProvider.deleteLog(id: log.id);
        void handleFavor() {
          logProvider.updateFavor(log: log);
          logProvider.updateLog(updatedLog: log);
        }

        Future<void> handleTap() async {
          final updated = await Navigator.push(
            c,
            MaterialPageRoute(builder: (c) => DetailsLog(logId: log.id)),
          );

          if (updated == true) {
            logProvider.updateLog(updatedLog: log);
          }
        }

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
          child: DefaultLogTile(
            logTile: log,
            onTap: () => handleTap(),
            onFavor: handleFavor,
          ),
        );
      },
    );
  }
}

class DefaultLogTile extends StatelessWidget {
  final NoteLog logTile;
  final VoidCallback? onTap;
  final VoidCallback? onFavor;

  const DefaultLogTile({
    super.key,
    required this.logTile,
    this.onTap,
    this.onFavor,
  });

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: IconButton(
        icon: Icon(
          Icons.monitor_heart,
          size: iconSize,
          color: logTile.isFavor
              ? colorScheme.primary
              : adjustLightness(colorScheme.primary, 0.4),
        ),
        onPressed: () => onFavor?.call(),
        splashRadius: kSplashRadius,
        tooltip: logTile.isFavor ? 'Unfavourite' : 'Favourite',
      ),
      title: Text(
        shortenText(plainTextFromDeltaJson(logTile.note)),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        formatShortDateTime(logTile.date),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
      trailing: Icon(
        moods[logTile.labelMood],
        size: iconSizeLarge,
        color: colorScheme.primary,
      ),
    );
  }
}
