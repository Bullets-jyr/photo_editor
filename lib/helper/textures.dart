import 'package:photo_editor/model/texture.dart';

class Textures {
  List<Texture> list() {
    return <Texture>[
      Texture(
        name: 't1',
        path: 'assets/images/t1.jpg'
      ),
      Texture(
        name: 't2',
        path: 'assets/images/t2.jpg'
      ),
      Texture(
        name: 't3',
        path: 'assets/images/t3.jpg'
      ),
      Texture(
        name: 't4',
        path: 'assets/images/t4.jpg'
      ),
      // Texture(
      //   name: 't5',
      //   path: 'assets/images/t5.jpg'
      // ),
      Texture(
        name: 't6',
        path: 'assets/images/t6.jpg'
      ),
    ];
  }
}