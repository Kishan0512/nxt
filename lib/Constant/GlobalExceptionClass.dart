import 'dart:io';

import 'package:intl/intl.dart';import 'package:path_provider/path_provider.dart';


class GlobalExceptionClass {
  List classError = [];
  List methodError = [];
  List error = [];

  globalExceptionClass(String className, String method, String text) async {
    var formatter = DateFormat('dd-MM-yyyy');
    var formatter1 = DateFormat('dd-MM-yyyy || HH:mm:ss');
    final Directory? directory = await getExternalStorageDirectory();
    final File file = File('${directory!.path}/Nxt_ExceptionFile.txt');
    classError.add(className);
    methodError.add(method);
    error.add(text);

    try {
      if (await file.exists()) {
        await file.writeAsString(
            "\n\nDate ==> ${formatter1.format(DateTime.now())} \n Class ==> $classError \n Method ==>$methodError \n Exception Error ==> \n $error",
            mode: FileMode.append);
      }
    } catch (e) {
      await file.writeAsString(
          "\n\nDate ==> ${DateTime.now()} \n Class ==> $classError \n Method ==>$methodError \n Exception Error ==> \n $error");
    }
  }

  deleteExceptionFile() async {
    final Directory? directory = await getExternalStorageDirectory();
    final File file = File('${directory!.path}/Nxt_ExceptionFile.txt');
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {}
  }
}
