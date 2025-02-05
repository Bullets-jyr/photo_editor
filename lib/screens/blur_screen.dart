import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Blur',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          centerTitle: true,
          leading: CloseButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                Uint8List? bytes = await screenshotController.capture();
                imageProvider.changeImage(bytes!);
                if (!mounted) return;
                navigator.pop();
              },
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  if (value.currentImage != null) {
                    return Screenshot(
                      controller: screenshotController,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: sigmaX,
                          sigmaY: sigmaY,
                          tileMode: tileMode,
                        ),
                        child: Image.memory(
                          value.currentImage!,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'X:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: slider(
                            value: sigmaX,
                            onChanged: (value) {
                              // print('===== value:: $value');
                              setState(() {
                                sigmaX = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Y:',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: slider(
                            value: sigmaY,
                            onChanged: (value) {
                              // print('===== value:: $value');
                              setState(() {
                                sigmaY = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Colors.black,
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _bottomBarItem(
                    'Decal',
                    color: tileMode == TileMode.decal ? Colors.blue : null,
                    onPressed: () {
                      setState(() {
                        tileMode = TileMode.decal;
                      });
                    },
                  ),
                  _bottomBarItem(
                    'Clamp',
                    color: tileMode == TileMode.clamp ? Colors.blue : null,
                    onPressed: () {
                      setState(() {
                        tileMode = TileMode.clamp;
                      });
                    },
                  ),
                  _bottomBarItem(
                    'Mirror',
                    color: tileMode == TileMode.mirror ? Colors.blue : null,
                    onPressed: () {
                      setState(() {
                        tileMode = TileMode.mirror;
                      });
                    },
                  ),
                  _bottomBarItem(
                    'Repeated',
                    color: tileMode == TileMode.repeated ? Colors.blue : null,
                    onPressed: () {
                      setState(() {
                        tileMode = TileMode.repeated;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _bottomBarItem(
    String title, {
    Color? color,
    required onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 10,
      min: 0.1,
      onChanged: onChanged,
    );
  }
}
