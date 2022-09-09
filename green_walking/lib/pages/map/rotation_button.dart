import 'package:flutter/material.dart';

class RotationButton extends StatelessWidget {
  const RotationButton(
      {super.key, required this.rotation, required this.onPressed});

  final ValueNotifier<bool> rotation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: rotation,
      builder: (context, value, child) {
        return Visibility(
            visible: value,
            child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 140),
                  child: MaterialButton(
                    onPressed: onPressed,
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.rotate_right,
                      size: 22,
                    ),
                  ),
                )));
      },
    );
  }
}
