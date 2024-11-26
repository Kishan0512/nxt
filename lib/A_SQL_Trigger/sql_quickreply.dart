import 'package:http/http.dart' as http;
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../A_Local_DB/Sync_Database.dart';

class sql_quickreply_tran {
  static SetQuickReplyDetail(
      String pstruserQuickValue, int pintuserQuickOrd) async {
    final response =
        await http.post(Uri.parse(ConstantApi.QuickReplyInsertData), body: {
      "user_mast_id": Constants_Usermast.user_id.toString(),
      "user_quick_value": pstruserQuickValue,
      "user_quick_ord": pintuserQuickOrd.toString(),
    });
    if (response.statusCode == 200) {
      SyncDB.SyncTable(Constants.Table_QuickReplies, false);
    } else {
      throw Exception('Failed to load SetQuickReplyDetail');
    }
  }

  static DelQuickReplyDetail(String pStrid) async {
    final response = await http.post(Uri.parse(ConstantApi.QuickReplyDelete),
        body: {"id": pStrid.toString()});
    if (response.statusCode == 200) {
      SyncJSon.user_quick_rep_delete(pStrid);
    } else {
      throw Exception('Failed to load DelQuickReplyDetail');
    }
  }
}
