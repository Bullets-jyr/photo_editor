import 'package:flutter/material.dart';

// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppImageProvider imageProvider;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  _savePhoto() async {
    final result = await ImageGallerySaverPlus.saveImage(
      imageProvider.currentImage!,
      quality: 100,
      name: "${DateTime.now().millisecondsSinceEpoch}",
    );
    if (!mounted) return false;
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to Gallery'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo Editor',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        centerTitle: true,
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _savePhoto();
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return Image.memory(
                    value.currentImage!,
                    // fit: BoxFit.fill,
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, Widget? child) {
              return Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        imageProvider.undo();
                      },
                      icon: Icon(
                        Icons.undo,
                        color: imageProvider.canUndo
                            ? Colors.white
                            : Colors.white10,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        imageProvider.redo();
                      },
                      icon: Icon(
                        Icons.redo,
                        color: imageProvider.canRedo
                            ? Colors.white
                            : Colors.white10,
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
      // body: Center(
      //   child: Consumer<AppImageProvider>(
      //     builder: (BuildContext context, value, Widget? child) {
      //       if (value.currentImage != null) {
      //         return Image.memory(
      //           value.currentImage!,
      //           // fit: BoxFit.fill,
      //         );
      //       }
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     },
      //   ),
      // ),
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
                  Icons.crop_rotate,
                  'Crop',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/crop');
                  },
                ),
                _bottomBarItem(
                  Icons.filter_vintage_outlined,
                  'Filters',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/filter');
                  },
                ),
                _bottomBarItem(
                  Icons.tune,
                  'Adjust',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/adjust');
                  },
                ),
                _bottomBarItem(
                  Icons.fit_screen_sharp,
                  'Fit',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/fit');
                  },
                ),
                _bottomBarItem(
                  Icons.border_color_outlined,
                  'Tint',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/tint');
                  },
                ),
                _bottomBarItem(
                  Icons.blur_circular,
                  'Blur',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/blur');
                  },
                ),
                _bottomBarItem(
                  Icons.emoji_emotions_outlined,
                  'Sticker',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/sticker');
                  },
                ),
                _bottomBarItem(
                  Icons.text_fields,
                  'Text',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/text');
                  },
                ),
                _bottomBarItem(
                  Icons.draw,
                  'Draw',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/draw');
                  },
                ),
                _bottomBarItem(
                  Icons.star_border,
                  'Mask',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/mask');
                  },
                ),
              ],
            ),
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
}
