import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:provider/provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final controller = CropController(
    /// If not specified, [aspectRatio] will not be enforced.
    aspectRatio: 1,

    /// Specify in percentages (1 means full width and height). Defaults to the full image.
    defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  late AppImageProvider imageProvider;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
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
          'Crop',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              ui.Image bitmap = await controller.croppedBitmap();
              ByteData? data = await bitmap.toByteData(format: ImageByteFormat.png);
              Uint8List bytes = data!.buffer.asUint8List();
              imageProvider.changeImage(bytes);
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
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              return CropImage(
                controller: controller,
                image: Image.memory(
                  value.currentImage!,
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
        height: 60,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBarItem(
                  child: Icon(
                    Icons.rotate_90_degrees_ccw_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.rotateLeft();
                  },
                ),
                _bottomBarItem(
                  child: Icon(
                    Icons.rotate_90_degrees_cw_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.rotateRight();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    color: Colors.white70,
                    height: 30,
                    width: 1,
                  ),
                ),
                _bottomBarItem(
                  child: Text(
                    'Free',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = null;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '1:1',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 1;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '2:1',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 2;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '1:2',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 1 / 2;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '4:3',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 4 / 3;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '3:4',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 3 / 4;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '16:9',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 16 / 9;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
                _bottomBarItem(
                  child: Text(
                    '9:16',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.aspectRatio = 9 / 16;
                    controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem({
    required child,
    required onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
