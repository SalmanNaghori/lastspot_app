import 'package:flutter/material.dart';

/// Uses EditableText's tap-region action, preserving selection and child gestures.
/// Controls that belong to an editor (Send, suggestions) use TextFieldTapRegion.
class AppKeyboardDismissal extends StatelessWidget {
  const AppKeyboardDismissal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Actions(
    actions: <Type, Action<Intent>>{
      EditableTextTapOutsideIntent:
          CallbackAction<EditableTextTapOutsideIntent>(
            onInvoke: (intent) {
              intent.focusNode.unfocus();
              return null;
            },
          ),
    },
    child: child,
  );
}
