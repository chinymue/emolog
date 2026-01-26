import 'package:flutter/material.dart';
import 'package:emolog/utils/constant.dart';
import '../../utils/color_utils.dart';

class DefaultSegmentedButton<T> extends StatelessWidget {
  const DefaultSegmentedButton({
    super.key,
    required this.values,
    required this.selected,
    required this.onPressed,
    required this.icons,
    required this.labels,
  });

  final List<T> values;
  final T selected;
  final void Function(T value) onPressed;
  final List<IconData> icons;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ToggleButtons(
      isSelected: values.map((e) => e == selected).toList(),
      onPressed: (index) {
        onPressed(values[index]);
      },
      borderRadius: BorderRadius.circular(kBorderRadiusXL),
      borderWidth: 1,
      constraints: const BoxConstraints(minHeight: 40, minWidth: 130),
      selectedBorderColor: colorScheme.primary,
      borderColor: colorScheme.outline,
      fillColor: colorScheme.errorContainer,
      selectedColor: colorScheme.onError,
      color: colorScheme.primary,
      children: List.generate(values.length, (i) {
        final selected = values[i] == this.selected;

        return Padding(
          padding: const EdgeInsets.all(kPaddingSmall),
          child: Row(
            children: [
              if (selected) ...[
                Icon(
                  Icons.check,
                  size: iconMinSize,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: kPadding),
              ],
              Icon(icons[i], size: iconSize, color: colorScheme.primary),
              Text(
                labels[i],
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
