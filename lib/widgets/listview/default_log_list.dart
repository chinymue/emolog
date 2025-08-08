import 'package:flutter/material.dart';
import 'dart:async';
import '../../export/notelog_essential.dart';
import '../../export/common_utils.dart';
import '../../widgets/detail_log/details_log.dart';

class DefaultList extends StatefulWidget {
  const DefaultList({
    super.key,
    required this.logs,
    required this.isarService,
    required this.onLogUpdated,
  });
  final List<NoteLog> logs;
  final IsarService isarService;

  /// Callback để thông báo log đã được cập nhật
  final void Function(NoteLog updatedLog, int index, String action)
  onLogUpdated;

  @override
  State<DefaultList> createState() => _DefaultListState();
}

class _DefaultListState extends State<DefaultList> {
  @override
  Widget build(BuildContext c) {
    if (widget.logs.isEmpty) return const Center(child: Text('No logs yet'));
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: widget.logs.length,
      itemBuilder: (c, i) {
        final log = widget.logs[i];
        final colorScheme = Theme.of(c).colorScheme;
        return Dismissible(
          key: ValueKey(log.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => widget.onLogUpdated(log, i, 'removed'),
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: kPaddingLarge),
            color: colorScheme.errorContainer,
            child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
          ),
          child: DefaultLogTile(
            isarService: widget.isarService,
            logTile: log,
            index: i,
            onLogUpdated: (updatedLog, action) =>
                widget.onLogUpdated(updatedLog, i, action),
          ),
        );
      },
    );
  }
}

class DefaultLogTile extends StatefulWidget {
  const DefaultLogTile({
    super.key,
    required this.isarService,
    required this.logTile,
    required this.index,
    required this.onLogUpdated,
  });
  final IsarService isarService;
  final NoteLog logTile;
  final int index;

  /// Callback để thông báo log đã được cập nhật
  final void Function(NoteLog updatedLog, String action) onLogUpdated;

  @override
  State<DefaultLogTile> createState() => _DefaultLogTileState();
}

class _DefaultLogTileState extends State<DefaultLogTile> {
  Future<void> _toggleFavorite(NoteLog log) async {
    setState(() {
      log.isFavor = !log.isFavor;
    });
    widget.onLogUpdated(log, 'updated');
  }

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    return ListTile(
      onTap: () async {
        final updated = await Navigator.push(
          c,
          MaterialPageRoute(
            builder: (c) => DetailsLog(
              isarService: widget.isarService,
              content: widget.logTile,
              onLogUpdated: (updatedLog, action) =>
                  widget.onLogUpdated(updatedLog, action),
            ),
          ),
        );
        if (updated == true && widget.index != -1) {
          widget.onLogUpdated(widget.logTile, 'updated');
        }
      },
      leading: IconButton(
        icon: Icon(
          Icons.monitor_heart,
          size: iconSize,
          color: widget.logTile.isFavor
              ? colorScheme.primary
              : adjustLightness(colorScheme.primary, 0.4),
        ),
        onPressed: () => _toggleFavorite(widget.logTile),
        splashRadius: kSplashRadius,
        tooltip: widget.logTile.isFavor ? 'Unfavourite' : 'Favourite',
      ),
      title: Text(
        shortenText(widget.logTile.note!),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        formatShortDateTime(widget.logTile.date),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
      trailing: Icon(
        moods[widget.logTile.labelMood],
        size: iconSizeLarge,
        color: colorScheme.primary,
      ),
    );
  }
}
