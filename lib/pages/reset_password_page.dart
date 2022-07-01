import 'package:flutter/material.dart';

import '../classes/AdHocClass.dart';
import '../classes/MessageClass.dart';
import '../main.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controllerPhone = TextEditingController();
  final controllerPass1 = TextEditingController();
  final controllerPass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('重设密码'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controllerPhone,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: '您的电话号码'),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: controllerPass1,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: '想设置的新的一级密码'),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: controllerPass2,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: '想设置的新的二级密码'),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('申请重设密码'),
                  onPressed: () => doUserResetPassword(),
                ),
              )
            ],
          ),
        ));
  }

  void doUserResetPassword() async {
    final String phone = controllerPhone.text.trim();
    final String pass1 = controllerPass1.text.trim();
    final String pass2 = controllerPass2.text.trim();
    if (phone == '') {
      Message.showMessage(context, '请输入您的电话号码！');
      return;
    }

    var resetPasswordAdHocMessage = <String, Map<String, String>>{};
    resetPasswordAdHocMessage["data"] = <String, String>{};

    resetPasswordAdHocMessage["data"]!["type"] = "重设密码申请";
    resetPasswordAdHocMessage["data"]!["from"] = phone;
    resetPasswordAdHocMessage["data"]!["to"] = "管理员";
    resetPasswordAdHocMessage["data"]!["message1"] = pass1;
    resetPasswordAdHocMessage["data"]!["message2"] = pass2;
    resetPasswordAdHocMessage["data"]!["finished"] = "no";

    var res = await AdHoc.createAdHocMessage(resetPasswordAdHocMessage);
    if (res.statusCode == 200) {
      Message.showSuccess(
          context: context,
          message: '手机号为$phone的辅导师,你的重设密码申请成功!\n管理员同意后你的密码会更改成功！',
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
            );
          });
    } else {
      Message.showMessage(context, '重设密码申请失败，请重试！');
    }
  }
}
