import 'package:flutter/material.dart';

import '../classes/AdHocClass.dart';
import '../classes/MentorClass.dart';
import '../classes/MessageClass.dart';
import '../main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final controllerName = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerIDCard = TextEditingController();
  final controllerPass1 = TextEditingController();
  final controllerPass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('注册新的辅导师'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200,
                  child: Image.network('https://zfile.miaoyilin.com/s/zr9xil'),
                ),
                TextField(
                  controller: controllerName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '姓名'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPhone,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '手机号'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerIDCard,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '身份证号'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPass1,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '一级密码'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPass2,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '二级密码'),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('注册'),
                    onPressed: () => doUserRegistration(),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void doUserRegistration() async {
    final name = controllerName.text.trim();
    final phone = controllerPhone.text.trim();
    final idCard = controllerIDCard.text.trim();
    final pass1 = controllerPass1.text.trim();
    final pass2 = controllerPass2.text.trim();

    if (name == "" ||
        phone == "" ||
        idCard == "" ||
        pass1 == "" ||
        pass2 == "") {
      Message.showMessage(context, '有空行没输入！');
      return;
    }

    MentorsList allMentors = await Mentor.fetchMentors();
    for (int i = 0; i < allMentors.mentors.length; i++) {
      if (allMentors.mentors[i].property.idCard == idCard ||
          allMentors.mentors[i].property.phone == phone ||
          allMentors.mentors[i].property.name == name) {
        Message.showMessage(
            context, '相同的身份证号或手机号或姓名已经被申请注册过了，请勿重复申请注册！\n有疑问请联系管理员提问！');
        return;
      }
    }

    var newMentor = <String, Map<String, String>>{};
    newMentor["data"] = <String, String>{};

    newMentor["data"]!["idCard"] = idCard;
    newMentor["data"]!["name"] = name;
    newMentor["data"]!["pass1"] = pass1;
    newMentor["data"]!["pass2"] = pass2;
    newMentor["data"]!["phone"] = phone;
    newMentor["data"]!["classes"] = "";
    // newMentor["data"]!["authorized"]="yes";
    // newMentor["data"]!["level"]="1";
    var resetPasswordAdHocMessage = <String, Map<String, String>>{};
    resetPasswordAdHocMessage["data"] = <String, String>{};

    resetPasswordAdHocMessage["data"]!["type"] = "新辅导师注册申请";
    resetPasswordAdHocMessage["data"]!["from"] = phone;
    resetPasswordAdHocMessage["data"]!["to"] = "管理员";
    resetPasswordAdHocMessage["data"]!["message1"] = name;
    resetPasswordAdHocMessage["data"]!["message2"] = idCard;
    resetPasswordAdHocMessage["data"]!["finished"] = "no";

    var res = await AdHoc.createAdHocMessage(resetPasswordAdHocMessage);
    final response = await Mentor.createMentor(newMentor);

    if (response.statusCode == 200) {
      Message.showSuccess(
          context: context,
          message: '成功申请注册新辅导师!\n通知管理员审核并赋予辅导员权限后方可使用！\n请勿重复申请注册！',
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
            );
          });
    } else {
      Message.showError(
          context: context,
          message: '申请注册新辅导师失败!\n请重试或联系管理员！',
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
            );
          });
    }
  }
}
