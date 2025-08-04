### Gesture Handle

#### GestureDetector

- `GestureDetector` là một widget để phản hồi các hành động như nhấn, chạm, kéo thả.

| Nhóm hành vi      | Callbacks chính                                           |
| ----------------- | --------------------------------------------------------- |
| Tap               | `onTap`, `onTapDown`, `onTapUp`, `onTapCancel`            |
| Double Tap        | `onDoubleTap`, `onDoubleTapDown`, `onDoubleTapCancel`     |
| Long Press        | `onLongPress`, `onLongPressStart`, `onLongPressEnd`, etc. |
| Drag (Vertical)   | `onVerticalDragUpdate`, etc.                              |
| Drag (Horizontal) | `onHorizontalDragUpdate`, etc.                            |
| Pan               | `onPanStart`, `onPanUpdate`, etc.                         |
| Scale             | `onScaleStart`, `onScaleUpdate`, etc.                     |
| Force Press       | `onForcePressStart`, `onForcePressPeak`, etc.             |

- Ngoài ra các **button**, như `ElevatedButton`, `TextButton`, `CupertinoButton`, `IconButton` cũng được cài đặt sẵn một số hành vi phản hồi được.

  > Example `ElevatedButton` structure:

  ```
  required VoidCallback? onPressed,
  VoidCallback? onLongPress,
  ValueChanged<bool>? onHover,
  ValueChanged<bool>? onFocusChange,
  ```

### Dismissible

- là một widget cho phép người dùng swipe để xóa nội dung (khỏi một list).

  > Example `Dismissible`:

  ```
  Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: Key(item),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          items.removeAt(index);
        });

        // Then show a snackbar.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$item dismissed')));
      },
      child: ListTile(title: Text(item)),
    );
  ```
