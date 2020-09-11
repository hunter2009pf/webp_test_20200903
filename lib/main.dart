//import 'dart:io';
//
//import 'package:flutter_cube/flutter_cube.dart';
//import 'package:image/image.dart' as DownloadImage;
//
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//void main() => runApp(EpubWidget());
//
//class EpubWidget extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return new EpubState();
//  }
//}
//
//class EpubState extends State<EpubWidget> {
//
//  final _urlController = TextEditingController();
//
//  final BaseCacheManager _cacheManager = DefaultCacheManager();
//
//  final List<String> _imgUrlList = ['http://192.168.0.113:8888/image/img0.webp', 'http://192.168.0.113:8888/image/model.webp'];
//
//  File _file;
//
//  int i =0;
//
//  @override
//  Widget build(BuildContext context) {
//
//    //动态申请储存权限
//    PermissionHandler().checkPermissionStatus(PermissionGroup.storage).then((pStatus){
//      if(pStatus == PermissionStatus.granted){
//        debugPrint("already get the right to save image on the phone");
//        return;
//      }else{
//        PermissionHandler().requestPermissions(<PermissionGroup>[
//          PermissionGroup.storage, // 在这里添加需要的权限
//        ]);
//      }
//    });
//
//    return MaterialApp(
//        debugShowCheckedModeBanner: false,
//        title: "Fetch Epub Example",
//        home: Scaffold(
//          body: Center(
//            child: Cube(
//          onSceneCreated: (Scene scene) {
//      scene.world.add(Object(fileName: 'assets/cube/cube.obj'));}
//            ),
//          ),
//        )
//    );

//    return MaterialApp(
//        debugShowCheckedModeBanner: false,
//        title: "Fetch Epub Example",
//        home: new Material(
//            child: Scaffold(
//               body: Column(
//                 children: <Widget>[
////                    Image.asset('assets/img0.webp'),
//                    CachedNetworkImage(
//                      imageUrl: _imgUrlList[1],
//                    ),
//                    Padding(
//                     padding: const EdgeInsets.only(top: 60),
//                     child: RaisedButton(
//                       onPressed: () async{
//                         if(i==0)i=1; else i=0;
//                         FileInfo _fromMemory = _cacheManager.getFileFromMemory(_imgUrlList[1]);
//                         debugPrint('file name is ${_fromMemory.file.path}');
//                         //file name is /data/user/0/com.tianxun.readingepub/cache/libCachedImageData/4387fbf0-edaa-11ea-bd8d-a9a2f4af0b01.webp
//                         DownloadImage.Image image = DownloadImage.decodeImage(File(_fromMemory.file.path).readAsBytesSync());
//
//                         // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
//                         DownloadImage.Image thumbnail = DownloadImage.copyResize(image, width: 120);
//
//                         // Save the thumbnail as a JPG.
//                         final dir = await getApplicationDocumentsDirectory();
////                         _file = File('${dir.path}/thumbnail.png')..writeAsBytesSync(DownloadImage.encodePng(thumbnail));
//                         _file = File('${dir.path}/thumbnail.png')..writeAsBytesSync(DownloadImage.encodePng(image));
//                         final result = await ImageGallerySaver.saveFile(_file.path);
//                         print('result is $result');
//                         setState(() { });
//                       },
//                       child: Text('download image'),
//                     ),
//                    ),
//                    if(_file!=null)
//                    Image.file(_file),
//
//                 ],
//               ),
//           )
//      )
//    );

//  }
//}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:readingepub/dio_post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.dark(),
//      home: MyHomePage(title: 'Flutter Cube Home Page'),
      home: OneCube(),
    );
  }
}

class OneCube extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OneCubeState();
  }
}

class _OneCubeState extends State<OneCube>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
        return Scaffold(
          body: Center(
            child: Cube(
                onSceneCreated: (Scene scene) {
                  scene.world.add(Object(fileName: 'assets/cube/cube.obj'));}
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context){
                    return DioPost();
//                    return MyHomePage(title: 'cube-formed circle');
                  }
                )
              );
            },
          ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Scene _scene;
  Object _cube;
  AnimationController _controller;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 50;
    _cube = Object(scale: Vector3(2.0, 2.0, 2.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj');
    final int samples = 100;
    final double radius = 8;
    final double offset = 2 / samples;
    final double increment = pi * (3 - sqrt(5));
    for (var i = 0; i < samples; i++) {
      final y = (i * offset - 1) + offset / 2;
      final r = sqrt(1 - pow(y, 2));
      final phi = ((i + 1) % samples) * increment;
      final x = cos(phi) * r;
      final z = sin(phi) * r;
      final Object cube = Object(
        position: Vector3(x, y, z)..scale(radius),
        fileName: i<50?'assets/cube/cube.obj':'assets/cube/cube1.obj',
      );
      _cube.add(cube);
    }
    scene.world.add(_cube);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          _cube.rotation.y = _controller.value * 360;
          _cube.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}

