import 'package:flutter/material.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            onPressed: () {},
            child: Text('Save'),
          ),
        ],
      ),
      body: Center(
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
