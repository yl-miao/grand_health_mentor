import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:updater/updater.dart';

import '../classes/MessageClass.dart';
import '../classes/StudentClass.dart';
import '../main.dart';
import 'browser_page.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({Key? key}) : super(key: key);

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  // with AutomaticKeepAliveClientMixin
  // @override
  // bool get wantKeepAlive => true; // 是否需要缓存

  final _biggerFont = const TextStyle(fontSize: 18);
  List<Student> _allStudents = <Student>[];

  @override
  void initState() {
    super.initState();
    _customizeActions();
  }

  _checkUpdate() async {
    bool isAvailable = await Updater(
      context: context,
      // delay: const Duration(milliseconds: ),
      url: 'https://zfile.miaoyilin.com/file/1/updater.json',
      titleText: '请更新软件',
      backgroundDownload: false,
      // backgroundDownload: false,
      allowSkip: false,
      contentText: '软件更新已发布，请务必更新软件后再使用.',
      confirmText: '自动更新',

      callBack:
          (versionName, versionCode, contentText, minSupport, downloadUrl) {
        debugPrint(versionName);
        debugPrint(versionCode.toString());
        debugPrint(contentText);
      },
      // controller: controller,
    ).check();
  }

  void _customizeActions() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      await _checkUpdate();
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedIn') == 'yes') {
      final studentsList = await Student.fetchStudents();
      if (prefs.getString('level') == "1") {
        setState(() {
          _allStudents = studentsList.students;
        });
      } else {
        setState(() {
          List<Student> tmp = studentsList.students;
          tmp.removeWhere((element) {
            if (element.property.mentorName == prefs.getString('name')) {
              return false;
            } else {
              return true;
            }
          });
          _allStudents = tmp;
        });
      }
    }

    // final studentsList = await Student.fetchStudents();
    // setState(() {
    //   _allStudents = studentsList.students;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); // 必须调用?
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('目前所有学员：'),
      //   // actions: [
      //   //   IconButton(
      //   //     icon: const Icon(Icons.list),
      //   //     onPressed: _pushSaved,
      //   //     tooltip: 'Saved Suggestions',
      //   //   ),
      //   // ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Image.network('https://zfile.miaoyilin.com/s/zr9xil'),
            ),

            ///this is causing problem! But i need listview here
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: _allStudents.length * 2, //不知道为啥这里要+2(+3的话最底下也有个分割线)
              itemBuilder: (context, i) {
                if (i.isOdd) return const Divider();

                final index = i ~/ 2;

                return ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(
                    _allStudents[index].property.name,
                    style: _biggerFont,
                  ),
                  onTap: () {
                    Student _student = _allStudents[index];
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          final tiles = <Widget>[
                            ListTile(
                              title: const Text('姓名:'),
                              subtitle: Text(_student.property.name),
                            ),
                            ListTile(
                              title: const Text('电话:'),
                              subtitle: Text(_student.property.phone),
                            ),
                            ListTile(
                              title: const Text('该学员指定的辅导师:'),
                              subtitle: Text(_student.property.mentorName),
                            ),
                            ListTile(
                              title: const Text('辅导师对该学员的特殊备注(治疗方案与治疗记录等等):'),
                              subtitle: Text(_student.property.note),
                            ),
                            ListTile(
                              title: const Text('该学员的功课诊疗记录:'),
                              subtitle: Text(_student.property.classes),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                child: const Text('查看该学员的问卷调查结果'),
                                onPressed: () => doShowResults(),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                child: const Text('添加对该学员的功课诊疗记录'),
                                onPressed: () => doAddClasses(
                                    _student.property.name,
                                    _student.property.phone,
                                    _student.property.mentorName),
                              ),
                            ),
                          ];
                          final divided = tiles.isNotEmpty
                              ? ListTile.divideTiles(
                                  context: context,
                                  tiles: tiles,
                                ).toList()
                              : <Widget>[];

                          return Scaffold(
                            appBar: AppBar(
                              title: const Text('此学员(患者)信息'),
                            ),
                            body: ListView(children: divided),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void doShowResults() {
    // Message.showSuccess(
    //     context: context, message: '请在新窗口中再次确认该学员姓名，您的姓名和查询密码！');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const BrowserPage(
                url: "https://surveyking.miaoyilin.com/s/FvbSuE/result/gMLVew",
                title: "查看该学员的问卷调查结果",
              )),
    );
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (_) {
    //   return new Browser(
    //     url: "https://flutter-io.cn/",
    //     title: "Flutter 中文社区",
    //   );
    // })
  }

  void doAddClasses(String name, String phone, String mentorName) async {
    var resultClasses = await _showTextInputDialog(context);
    if (resultClasses == null || resultClasses == "") {
      Message.showError(context: context, message: '必须输入本次要添加的诊疗/恢复/功课记录！');
      return;
    }

    StudentsList allStudents = await Student.fetchStudents();
    late int studentID;
    var newStudent = <String, Map<String, String>>{};
    newStudent["data"] = <String, String>{};

    DateTime now = DateTime.now();
//   print("当前时间：$now");

    for (int i = 0; i < allStudents.students.length; i++) {
      if (allStudents.students[i].property.name == name &&
          allStudents.students[i].property.phone == phone &&
          allStudents.students[i].property.mentorName == mentorName) {
        studentID = allStudents.students[i].id;
        newStudent["data"]!["name"] = allStudents.students[i].property.name;
        newStudent["data"]!["pass"] = allStudents.students[i].property.pass;
        newStudent["data"]!["idCard"] = allStudents.students[i].property.idCard;
        newStudent["data"]!["answer"] = allStudents.students[i].property.answer;
        newStudent["data"]!["note"] = allStudents.students[i].property.note;
        newStudent["data"]!["phone"] = allStudents.students[i].property.phone;
        newStudent["data"]!["authorized"] =
            allStudents.students[i].property.authorized;
        newStudent["data"]!["mentorID"] =
            allStudents.students[i].property.mentorID;
        newStudent["data"]!["mentorName"] =
            allStudents.students[i].property.mentorName;
        newStudent["data"]!["classes"] =
            "${now.year}-${now.month}-${now.day}(${now.hour}:${now.minute}): " +
                resultClasses +
                '\n' +
                allStudents.students[i].property.classes; //修改的是这里
        break;
      }
    }

    Student.updateStudent(newStudent, studentID.toString());

    Message.showSuccess(
        context: context,
        message: '添加本次诊疗/恢复/功课记录成功！',
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        });
  }

  final _textFieldController = TextEditingController();
  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('请输入本次添加的诊疗记录'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                  hintText: "请输入本次诊疗/恢复/功课的记录：(无需写时间，系统会自动记录时间)"),
              maxLines: 3,
            ),
            actions: <Widget>[
              // ElevatedButton(
              //   child: const Text("取消"),
              //   onPressed: () => Navigator.pop(context),
              // ),
              ElevatedButton(
                child: const Text('好的'),
                onPressed: () =>
                    Navigator.pop(context, _textFieldController.text),
              ),
            ],
          );
        });
  }
}
