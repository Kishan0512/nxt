import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nextapp/A_SQL_Trigger/sql_help_contact.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Wid.dart';

import '../../Constant/Con_Clr.dart';
import '../../OSFind.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool _val = false;
  final TextEditingController _txtvalue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Con_Wid.mAppBar("Contact Us"),
            ),
            body: _con_help(context),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                padding: EdgeInsetsDirectional.zero,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.back, color: Con_white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: App_Float_Back_Color,
                middle: const Text(
                  "Contact Us",
                  style: TextStyle(color: Con_white),
                )),
            child: Cupertino_con_help(context));
  }

  Widget _con_help(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextField(
            controller: _txtvalue,
            maxLines: 3,
            decoration: InputDecoration(
                hoverColor: Con_white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Con_grey)),
                hintText: "Tell us how we can help"),
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 15),
            value: _val,
            onChanged: (value) {
              setState(() {
                _val = value!;
              });
            },
            title: const Text("Include device information? (optional)"),
            subtitle: const Text(
                "Technical details like your model and settings can help us answer your question"),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomLeft,
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 0, right: 0),
              title: const Text("We will Respond to you in your chat."),
              trailing: ElevatedButton(
                child: const Text("Send"),
                onPressed: () {
                  if (_txtvalue.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Add your request",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                  sql_help_contact.InsertHelpContact(
                      _txtvalue.text.trim().trimLeft().trimRight());
                  Navigator.pop(context);
                },
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget Cupertino_con_help(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            onTapOutside: (event) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            placeholder: 'Tell us how we can help',
            placeholderStyle: TextStyle(color: Con_grey.shade400),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Con_grey),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            controller: _txtvalue,
            maxLines: 3,
          ),
          const SizedBox(
            height: 10,
          ),
          CupertinoListTile(
            padding: EdgeInsets.zero,
            trailing: CupertinoSwitch(
                value: _val,
                onChanged: (value) {
                  setState(() {
                    _val = value;
                  });
                },
                activeColor: App_IconColor),
            title: const Text("Include device information? (optional)"),
            subtitle: const Text(
                "Technical details like your model and settings can help us answer your question"),
          ),
          const Expanded(child: SizedBox()),
          CupertinoListTile(
            padding: EdgeInsets.zero,
            title: const Text("We will Respond to you in your chat."),
            trailing: CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text("Send"),
              onPressed: () {
                if (_txtvalue.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Add your request",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                sql_help_contact.InsertHelpContact(
                    _txtvalue.text.trim().trimLeft().trimRight());
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
