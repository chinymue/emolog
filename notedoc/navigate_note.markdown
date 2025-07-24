### Navigate

#### Navigator back & forth

- is a widget and navigate each screen as widgets, work like a **stack** of widget to show.
- `Navigator.push()` to add a `Route` (ur custom widget) in stack and `Navigator.pop()` to remove current `Route`.
- should create platform-specific route for better animation.
- other method to try:
  - `pushAndRemoveUntil`: Adds a navigation route to the stack and then removes the most recent routes from the stack until a condition is met.
  - `pushReplacement`: Replaces the current route on the top of the stack with a new one.
  - `replace`: Replace a route on the stack with another route.
    ` `replaceRouteBelow`: Replace the route below a specific route on the stack.
  - `popUntil`: Removes the most recent routes that were added to the stack of navigation routes until a condition is met.
  - `removeRoute`: Remove a specific route from the stack.
    removeRouteBelow: Remove the route below a specific route on the stack.
  - `restorablePush`: Restore a route that was removed from the stack.
