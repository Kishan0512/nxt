import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:external_path/external_path.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/Con_Usermast.dart';

class Folder {
  static var aud, vid, img, doc, baseDir;
  static Directory audio = Directory(""),
      video = Directory(""),
      images = Directory(""),
      Document = Directory(""),
      sentdocument = Directory("${baseDir.path}/document/sent"),
      sentMedia = Directory("${baseDir.path}/Image/sent"),
      sentVideo = Directory("${baseDir.path}/video/sent"),
      wallpaper = Directory("${baseDir.path}/Image/wallpapers");

  static createdir() async {
    try {
      if (await _reqStoragePermission() ||
          (await reqPhotosPermission() &&
              await reqVideoPermission() &&
              await reqAudioPermission())) {
        List<String> externalpath =
            await ExternalPath.getExternalStorageDirectories();
        Directory base = Directory(File(externalpath[0]).path);
        var dire = join(base.path, "Nxt");
        SharedPreferences diref = await SharedPreferences.getInstance();
        Directory a = Directory(diref.getString("audio").toString());
        Directory b = Directory(diref.getString("video").toString());
        Directory c = Directory(diref.getString("images").toString());
        Directory d = Directory(diref.getString("document").toString());
        if (a.path == "null") {
          aud = join(dire, "Nxt Audio");
          audio = Directory(aud);
          if (await audio.exists() == false) {
            await audio.create(recursive: true);
          }
        } else {
          aud = a.path;
          audio.rename(aud);
          if (await audio.exists() == false) {
            await audio.create(recursive: true);
          }
        }
        if (b.path == "null") {
          vid = join(dire, "Nxt Video");
          video = Directory(vid);
          if (await video.exists() == false) {
            await video.create(recursive: true);
          }
        } else {
          vid = b.path;
          video = Directory(vid);
          if (await video.exists() == false) {
            await video.create(recursive: true);
          }
        }
        if (c.path == "null") {
          img = join(dire, "Nxt Images");
          images = Directory(img);
          if (await images.exists() == false) {
            await images.create(recursive: true);
          }
        } else {
          img = c.path;
          images = Directory(img);
          if (await images.exists() == false) {
            await images.create(recursive: true);
          }
        }
        if (d.path == "null") {
          doc = join(dire, "Nxt Document");
          Document = Directory(doc);
          if (await Document.exists() == false) {
            await Document.create(recursive: true);
          }
        } else {
          doc = d.path;
          Document = Directory(doc);
          if (await Document.exists() == false) {
            Document.create(recursive: true);
          }
        }
      }
    } catch (e) {}
  }

  static Future<bool> _reqpermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> _reqStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 29) {
        if (await _reqpermission(Permission.storage) == false) {
          return await _reqpermission(Permission.storage);
        } else {
          return true;
        }
      } else {
        if (await _reqpermission(Permission.manageExternalStorage) == false) {
          return await _reqpermission(Permission.manageExternalStorage);
        } else {
          return true;
        }
      }
    } else {
      return false;
    }
  }

  static Future reqPermission() async {
    await reqPhotosPermission().then((value) async => await reqVideoPermission()
        .then((value) async => await reqAudioPermission().then((value) async =>
            await reqMicrophonePermission()
                .then((value) async => await reqCameraPermission()))));
  }

  static Future<bool> reqPhotosPermission() async {
    if (await _reqpermission(Permission.photos) == false) {
      return await _reqpermission(Permission.photos);
    } else {
      return true;
    }
  }

  static Future<bool> reqVideoPermission() async {
    if (await _reqpermission(Permission.videos) == false) {
      return await _reqpermission(Permission.videos);
    } else {
      return true;
    }
  }

  static Future<bool> reqAudioPermission() async {
    if (await _reqpermission(Permission.audio) == false) {
      return await _reqpermission(Permission.audio);
    } else {
      return true;
    }
  }

  static Future<bool> reqMicrophonePermission() async {
    if (await _reqpermission(Permission.microphone) == false) {
      return await _reqpermission(Permission.microphone);
    } else {
      return true;
    }
  }

  static Future<bool> reqCameraPermission() async {
    if (await _reqpermission(Permission.camera) == false) {
      return await _reqpermission(Permission.camera);
    } else {
      return true;
    }
  }

  static getpath() async {
    if ((await _reqpermission(Permission.photos) &&
            await _reqpermission(Permission.videos) &&
            await _reqpermission(Permission.audio)) ||
        await _reqStoragePermission()) {
      baseDir = await getApplicationSupportDirectory();
      Constants_Usermast.dbpath = baseDir;
      var ProfileImagePath = join(baseDir.path, "Image/Profile/");
      var sentImagePath = join(baseDir.path, "Image", "sent");
      var wallpaperPath = join(baseDir.path, "Image", "wallpapers");
      var fs = const LocalFileSystem();
      var ProfileDirectory = fs.directory((ProfileImagePath));
      var sentImageDirectory = fs.directory((sentImagePath));
      var wallpaperDirectory = fs.directory((wallpaperPath));
      await sentImageDirectory.create(recursive: true);
      await wallpaperDirectory.create(recursive: true);
      await ProfileDirectory.create(recursive: true);
    } else {
      await Folder.reqPermission().then((value) => getpath());
    }
  }
}
