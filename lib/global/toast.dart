import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tylunch/global/color.dart';

// Call sites keep passing `toastLength: Toast.LENGTH_LONG`.
export 'package:fluttertoast/fluttertoast.dart' show Toast;

// Set on MaterialApp so a toast can be shown from anywhere, services included.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

OverlayEntry? _current;

// Native Android toasts ignore every style on Android 11+, so they render as
// grey text on a white page and vanish after 2s. These draw our own instead.
void showToast({required String msg, Toast? toastLength}) {
  _show(msg, toastLength, const _Style(
    background: Color(0xFFE3EBFF),
    border: kcPrimaryLight,
    text: kcPrimary,
  ));
}

// For "you skipped a step" nudges: nothing failed, the user just has to act.
void showWarning({required String msg, Toast? toastLength}) {
  _show(msg, toastLength, const _Style(
    background: Color(0xFFFFF3D6),
    border: Color(0xFFF59E0B),
    text: Color(0xFF7A4B00),
  ));
}

void showError({required String msg, Toast? toastLength}) {
  _show(msg, toastLength, const _Style(
    background: Color(0xFFFFE0E0),
    border: Color(0xFFD32F2F),
    text: Color(0xFFB00020),
  ));
}

void _show(String msg, Toast? toastLength, _Style style) {
  final OverlayState? overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) {
    Fluttertoast.showToast(msg: msg, toastLength: toastLength);
    return;
  }
  _current?.remove();
  final OverlayEntry entry = OverlayEntry(
    builder: (context) => _ToastBox(msg: msg, style: style, onTap: _dismiss),
  );
  _current = entry;
  overlay.insert(entry);
  final int seconds = toastLength == Toast.LENGTH_LONG ? 8 : 5;
  Future.delayed(Duration(seconds: seconds), () {
    if (_current == entry) _dismiss();
  });
}

void _dismiss() {
  _current?.remove();
  _current = null;
}

class _Style {
  final Color background;
  final Color border;
  final Color text;
  const _Style({required this.background, required this.border, required this.text});
}

class _ToastBox extends StatelessWidget {
  final String msg;
  final _Style style;
  final VoidCallback onTap;
  const _ToastBox({required this.msg, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Sit above the keyboard when it is open, otherwise in the lower part of the
    // screen near the buttons that trigger most messages.
    final MediaQueryData media = MediaQuery.of(context);
    final double keyboard = media.viewInsets.bottom;
    final double bottom =
        keyboard > 0 ? keyboard + 16 : media.size.height * 0.15;
    return Positioned(
      left: 24,
      right: 24,
      bottom: bottom,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: style.background,
              border: Border.all(color: style.border, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: style.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
