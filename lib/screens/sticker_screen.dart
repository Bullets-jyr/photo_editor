import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/helper/stickers.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({super.key});

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  late AppImageProvider imageProvider;
  late LindiController controller;

  int index = 0;

  // List<Widget> widgets = [
  //   // SizedBox(
  //   //   height: 100,
  //   //   width: 100,
  //   //   child: Image.network('https://picsum.photos/200/200'),
  //   // ),
  //   // const Icon(Icons.favorite, color: Colors.red, size: 50),
  //   Text('Hello World'),
  // ];

  @override
  void initState() {
    controller = LindiController(
      // borderColor: Colors.black87,
      icons: [
        LindiStickerIcon(
            icon: Icons.done,
            alignment: Alignment.topRight,
            onTap: () {
              controller.selectedWidget!.done();
            }),
        LindiStickerIcon(
            icon: Icons.lock_open,
            lockedIcon: Icons.lock,
            alignment: Alignment.topCenter,
            type: IconType.lock,
            onTap: () {
              controller.selectedWidget!.lock();
            }),
        LindiStickerIcon(
            icon: Icons.close,
            alignment: Alignment.topLeft,
            onTap: () {
              controller.selectedWidget!.delete();
            }),
        // LindiStickerIcon(
        //     icon: Icons.edit,
        //     alignment: Alignment.centerLeft,
        //     onTap: () {
        //       controller.selectedWidget!
        //           .edit(const Icon(Icons.star, size: 50, color: Colors.yellow));
        //     }),
        // LindiStickerIcon(
        //     icon: Icons.layers,
        //     alignment: Alignment.centerRight,
        //     onTap: () {
        //       controller.selectedWidget!.stack();
        //     }),
        LindiStickerIcon(
            icon: Icons.flip,
            alignment: Alignment.bottomLeft,
            onTap: () {
              controller.selectedWidget!.flip();
            }),
        LindiStickerIcon(
            icon: Icons.crop_free,
            alignment: Alignment.bottomRight,
            type: IconType.resize),
      ],
    );

    // controller.addAll(widgets);

    controller.onPositionChange((index) {
      debugPrint(
          "widgets size: ${controller.widgets.length}, current index: $index");
    });

    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sticker',
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
              Uint8List? image = await controller.saveAsUint8List();
              imageProvider.changeImage(image!);
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
              return LindiStickerWidget(
                controller: controller,
                child: Center(
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
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 160,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Stickers().list()[index].length,
                    itemBuilder: (BuildContext context, int idx) {
                      String sticker = Stickers().list()[index][idx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: InkWell(
                                  onTap: () {
                                    controller
                                        .add(Image.asset(sticker, width: 100));
                                  },
                                  child: Image.asset(sticker),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Row(
                  children: [
                    for (int i = 0; i < Stickers().list().length; i++)
                      _bottomBatItem(i, Stickers().list()[i][0], onPress: () {
                        setState(() {
                          index = i;
                        });
                      })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(
    int idx,
    String icon, {
    Color? color,
    required onPress,
  }) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                color: index == idx ? Colors.blue : Colors.transparent,
                height: 2,
                width: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon, width: 30),
            ),
          ],
        ),
      ),
    );
  }
}
