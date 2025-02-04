import 'dart:io';
import 'dart:typed_data';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/helper/app_color_picker.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/helper/pixel_color_image.dart';
import 'package:photo_editor/helper/textures.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:photo_editor/model/texture.dart' as t;

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  late t.Texture currentTexture;
  late List<t.Texture> textures;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? currentImage;
  Uint8List? backgroundImage;
  Color backgroundColor = Colors.white;

  int x = 1;
  int y = 1;

  double blur = 0;

  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showTexture = false;

  bool showColorBackground = true;
  bool showImageBackground = false;
  bool showTextureBackground = false;

  @override
  void initState() {
    textures = Textures().list();
    currentTexture = textures[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  showActiveWidget({r, b, c, t}) {
    showRatio = r != null ? true : false;
    showBlur = b != null ? true : false;
    showColor = c != null ? true : false;
    showTexture = t != null ? true : false;
    setState(() {});
  }

  showBackgroundWidget({c, i, t}) {
    showColorBackground = c != null ? true : false;
    showImageBackground = i != null ? true : false;
    showTextureBackground = t != null ? true : false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        title: Text(
          'Fit',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              // Uint8List? bytes = await screenshotController.capture();
              // imageProvider.changeImage(bytes!);
              // if (!mounted) return;
              navigator.pop();
            },
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              currentImage = value.currentImage;
              backgroundImage ??= value.currentImage;
              return AspectRatio(
                aspectRatio: x / y,
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      if (showColorBackground)
                        Container(
                          // color: Colors.white,
                          color: backgroundColor,
                        ),
                      if (showImageBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(
                                backgroundImage!,
                              ),
                            ),
                          ),
                        ).blurred(
                          colorOpacity: 0,
                          blur: blur,
                        ),
                      if (showTextureBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(currentTexture.path!),
                            ),
                          ),
                        ),
                      Center(
                        child: Image.memory(
                          value.currentImage!,
                        ),
                      ),
                    ],
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
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (showRatio) ratioWidget(),
                    if (showBlur) blurWidget(),
                    if (showColor) colorWidget(),
                    if (showTexture) textureWidget(),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _bottomBarItem(
                      Icons.aspect_ratio,
                      'Ratio',
                      onPressed: () {
                        showActiveWidget(r: true);
                      },
                    ),
                  ),
                  Expanded(
                    child: _bottomBarItem(
                      Icons.blur_linear,
                      'Blur',
                      onPressed: () {
                        showBackgroundWidget(i: true);
                        showActiveWidget(b: true);
                      },
                    ),
                  ),
                  Expanded(
                    child: _bottomBarItem(
                      Icons.color_lens_outlined,
                      'Color',
                      onPressed: () {
                        showBackgroundWidget(c: true);
                        showActiveWidget(c: true);
                      },
                    ),
                  ),
                  Expanded(
                    child: _bottomBarItem(
                      Icons.texture,
                      'Texture',
                      onPressed: () {
                        showBackgroundWidget(t: true);
                        showActiveWidget(t: true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(
    IconData icon,
    String title, {
    required onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ratioWidget() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 1;
                      y = 1;
                    });
                  },
                  child: Text(
                    '1:1',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 2;
                      y = 1;
                    });
                  },
                  child: Text(
                    '2:1',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 1;
                      y = 2;
                    });
                  },
                  child: Text(
                    '1:2',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 4;
                      y = 3;
                    });
                  },
                  child: Text(
                    '4:3',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 3;
                      y = 4;
                    });
                  },
                  child: Text(
                    '3:4',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 16;
                      y = 9;
                    });
                  },
                  child: Text(
                    '16:9',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      x = 9;
                      y = 16;
                    });
                  },
                  child: Text(
                    '9:16',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget blurWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                AppImagePicker(source: ImageSource.gallery).pick(
                  onPick: (File? image) async {
                    // print(image!.path);
                    // imageProvider.changeImageFile(image!);
                    // Navigator.of(context).pushReplacementNamed('/home');
                    backgroundImage = await image!.readAsBytes();
                    setState(() {});
                  },
                );
              },
              icon: Icon(
                Icons.photo_library_outlined,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Slider(
                label: blur.toStringAsFixed(2),
                value: blur,
                max: 100,
                min: 0,
                onChanged: (value) {
                  setState(() {
                    blur = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                AppColorPicker().show(context, backgroundColor: backgroundColor,
                    onPicked: (color) {
                  setState(() {
                    backgroundColor = color;
                  });
                });
              },
              icon: Icon(
                Icons.color_lens_outlined,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                PixelColorImage().show(context,
                    backgroundColor: backgroundColor,
                    image: currentImage, onPicked: (color) {
                  setState(() {
                    backgroundColor = color;
                  });
                });
              },
              icon: Icon(
                Icons.colorize,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textureWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: textures.length,
          itemBuilder: (BuildContext context, int index) {
            t.Texture texture = textures[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentTexture = texture;
                          });
                        },
                        child: Image.asset(
                          texture.path!,
                          // fit: BoxFit.fill,
                          // width: 40,
                          // height: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
