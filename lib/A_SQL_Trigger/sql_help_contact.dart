import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';

class sql_help_contact {
  static InsertHelpContact(String pStrMessage) async {
    final response =
        await http.post(Uri.parse(ConstantApi.InsertHelpContacts), body: {
      "user_id": Constants_Usermast.user_id,
      "user_message": pStrMessage,
    });
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty && response.body != "[]") {
        Fluttertoast.showToast(
          msg: response.body.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }
    }
  }
}
