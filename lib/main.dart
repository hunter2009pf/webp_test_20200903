import 'dart:io';

import 'package:image/image.dart' as DownloadImage;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(EpubWidget());

class EpubWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EpubState();
  }
}

class EpubState extends State<EpubWidget> {

  final _urlController = TextEditingController();

  final BaseCacheManager _cacheManager = DefaultCacheManager();

  final List<String> _imgUrlList = ['http://192.168.0.113:8888/image/img0.webp', 'http://192.168.0.113:8888/image/model.webp'];

  File _file;

  int i =0;

  @override
  Widget build(BuildContext context) {

    //动态申请储存权限
    PermissionHandler().checkPermissionStatus(PermissionGroup.storage).then((pStatus){
      if(pStatus == PermissionStatus.granted){
        debugPrint("already get the right to save image on the phone");
        return;
      }else{
        PermissionHandler().requestPermissions(<PermissionGroup>[
          PermissionGroup.storage, // 在这里添加需要的权限
        ]);
      }
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Fetch Epub Example",
        home: new Material(
            child: Scaffold(
               body: Column(
                 children: <Widget>[
//                    Image.asset('assets/img0.webp'),
                    CachedNetworkImage(
                      imageUrl: _imgUrlList[1],
                    ),
                    Padding(
                     padding: const EdgeInsets.only(top: 60),
                     child: RaisedButton(
                       onPressed: () async{
                         if(i==0)i=1; else i=0;
                         FileInfo _fromMemory = _cacheManager.getFileFromMemory(_imgUrlList[1]);
                         debugPrint('file name is ${_fromMemory.file.path}');
                         //file name is /data/user/0/com.tianxun.readingepub/cache/libCachedImageData/4387fbf0-edaa-11ea-bd8d-a9a2f4af0b01.webp
                         DownloadImage.Image image = DownloadImage.decodeImage(File(_fromMemory.file.path).readAsBytesSync());

                         // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
                         DownloadImage.Image thumbnail = DownloadImage.copyResize(image, width: 120);

                         // Save the thumbnail as a JPG.
                         final dir = await getApplicationDocumentsDirectory();
//                         _file = File('${dir.path}/thumbnail.png')..writeAsBytesSync(DownloadImage.encodePng(thumbnail));
                         _file = File('${dir.path}/thumbnail.png')..writeAsBytesSync(DownloadImage.encodePng(image));
                         final result = await ImageGallerySaver.saveFile(_file.path);
                         print('result is $result');
                         setState(() { });
                       },
                       child: Text('download image'),
                     ),
                    ),
                    if(_file!=null)
                    Image.file(_file)
                 ],
               ),
           )
      )
    );
  }
}

