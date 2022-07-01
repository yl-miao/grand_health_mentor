import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/MessageClass.dart';
import '../classes/StudentClass.dart';
import '../main.dart';

class NewStudentPage extends StatefulWidget {
  const NewStudentPage({Key? key}) : super(key: key);

  @override
  State<NewStudentPage> createState() => _NewStudentPageState();
}

class _NewStudentPageState extends State<NewStudentPage> {
  final controllerName = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerMentorName = TextEditingController();
  final controllerPass = TextEditingController();
  final controllerNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('添加新学员'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 160,
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
                      labelText: '要添加的学员的姓名'),
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
                      labelText: '该学员的手机号'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerMentorName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '该学员的辅导师(你自己)的姓名'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPass,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '学员的密码'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerNote,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: '对此学员的其他特殊备注'),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('添加新学员'),
                    onPressed: () => doStudentRegistration(),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void doStudentRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedIn') == 'yes') {
    } else {
      Message.showError(
          context: context,
          message: '需要先登录辅导师账号才有权限添加新学员!\n请先登录辅导师账号！',
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
            );
          });
    }
    final name = controllerName.text.trim();
    final phone = controllerPhone.text.trim();
    final mentorName = controllerMentorName.text.trim();
    final pass = controllerPass.text.trim();
    final note = controllerNote.text.trim();

    if (name == "" ||
        phone == "" ||
        mentorName == "" ||
        pass == "" ||
        note == "") {
      Message.showMessage(context, '有空行没输入！');
      return;
    }
    if (prefs.getString('name') != mentorName) {
      Message.showMessage(context,
          '${prefs.getString('name')},您只应该添加辅导师为自己的学员！\n如果该学员指定为别的辅导师，需要对应的辅导师添加。');
      return;
    }

    StudentsList allStudents = await Student.fetchStudents();
    for (int i = 0; i < allStudents.students.length; i++) {
      if (allStudents.students[i].property.phone == phone ||
          allStudents.students[i].property.name == name) {
        Message.showMessage(
            context, '相同的身份证号或手机号或姓名已经被某学员申请注册过了，请勿重复申请注册！\n有疑问请联系管理员提问！');
        return;
      }
    }

    var newStudent = <String, Map<String, String>>{};
    newStudent["data"] = <String, String>{};

    newStudent["data"]!["name"] = name;
    newStudent["data"]!["phone"] = phone;
    newStudent["data"]!["mentorName"] = mentorName;
    newStudent["data"]!["pass"] = pass;
    newStudent["data"]!["note"] = note;
    newStudent["data"]!["classes"] = "";

    // newMentor["data"]!["authorized"]="yes";
    // newMentor["data"]!["level"]="1";

    final response = await Student.createStudent(newStudent);

    if (response.statusCode == 200) {
      Message.showSuccess(
          context: context,
          message: '成功申请注册新学员!\n请通知该学员填写调查问卷！\n请勿重复申请注册！',
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
          message: '申请注册新学员失败!\n请重试或联系管理员！',
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (Route<dynamic> route) => false,
            );
          });
    }
    //
    // var resetPasswordAdHocMessage = <String, Map<String, String>>{};
    // resetPasswordAdHocMessage["data"] = <String, String>{};
    //
    // resetPasswordAdHocMessage["data"]!["type"] = "新辅导师注册申请";
    // resetPasswordAdHocMessage["data"]!["from"] = phone;
    // resetPasswordAdHocMessage["data"]!["to"] = "管理员";
    // resetPasswordAdHocMessage["data"]!["message1"] = name;
    // resetPasswordAdHocMessage["data"]!["message2"] = idCard;
    // resetPasswordAdHocMessage["data"]!["finished"] = "no";
    //
    // var res = await AdHoc.createAdHocMessage(resetPasswordAdHocMessage);
  }
}
