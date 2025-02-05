import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';

class AppColorPicker {
  show(BuildContext context, {Color? backgroundColor, onPicked, bool alpha = false}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = backgroundColor!;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: HueRingPicker(
                    enableAlpha: alpha,
                    pickerColor: backgroundColor,
                    onColorChanged: (color) {
                      tempColor = color;
                    },
                ),
                // child: ColorPicker(
                //   enableAlpha: false,
                //   hexInputBar: true,
                //   paletteType: PaletteType.hueWheel,
                //   pickerColor: backgroundColor,
                //   onColorChanged: (color) {
                //     tempColor = color;
                //   },
                // ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    onPicked(tempColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
