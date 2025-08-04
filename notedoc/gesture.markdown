### Gesture Handle

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
