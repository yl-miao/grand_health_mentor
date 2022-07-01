import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/MentorClass.dart';
import '../classes/MessageClass.dart';
import '../main.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  String classes = "";

  @override
  void initState() {
    super.initState();
    _customizeActions();
  }

  void _customizeActions() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedIn') == 'yes') {
      MentorsList allMentors = await Mentor.fetchMentors();
      setState(() {
        String tmpclasses = "";
        for (int i = 0; i < allMentors.mentors.length; i++) {
          if (allMentors.mentors[i].property.name == prefs.getString('name') &&
              allMentors.mentors[i].property.pass1 ==
                  prefs.getString('pass1') &&
              allMentors.mentors[i].property.pass2 ==
                  prefs.getString('pass2')) {
            tmpclasses = allMentors.mentors[i].property.classes; //修改的是这里
            break;
          }
        }
        classes = tmpclasses;
      });
    } else {
      setState(() {
        classes = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); // 必须调用?
    return Scaffold(
      extendBody: false, // 扩展到Scaffold的底部
      resizeToAvoidBottomInset: false, // 不允许键盘事件影响界面
      appBar: AppBar(
        title: const Text('当前登录辅导师自己的功课修行记录'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: Image.network('https://zfile.miaoyilin.com/s/zr9xil'),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                child: const Text('记录本日学习功课'),
                onPressed: () => doAddClassesMentor(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                classes,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doAddClassesMentor() async {
    var resultClasses = await _showTextInputDialog(context);
    if (resultClasses == null || resultClasses == "") {
      Message.showError(context: context, message: '必须输入本次要添加的学习功课记录！');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedIn') == 'yes') {
    } else {
      Message.showError(context: context, message: '请先登录！');
      return;
    }
    DateTime now = DateTime.now();
//   print("当前时间：$now");
    MentorsList allMentors = await Mentor.fetchMentors();
    late int mentorID;
    var testMentor = <String, Map<String, String>>{};
    testMentor["data"] = <String, String>{};

    for (int i = 0; i < allMentors.mentors.length; i++) {
      if (allMentors.mentors[i].property.name == prefs.getString('name') &&
          allMentors.mentors[i].property.pass1 == prefs.getString('pass1') &&
          allMentors.mentors[i].property.pass2 == prefs.getString('pass2')) {
        mentorID = allMentors.mentors[i].id;
        testMentor["data"]!["idCard"] = allMentors.mentors[i].property.idCard;
        testMentor["data"]!["name"] = allMentors.mentors[i].property.name;
        testMentor["data"]!["pass1"] = allMentors.mentors[i].property.pass1;
        testMentor["data"]!["pass2"] = allMentors.mentors[i].property.pass2;
        testMentor["data"]!["phone"] = allMentors.mentors[i].property.phone;
        testMentor["data"]!["authorized"] =
            allMentors.mentors[i].property.authorized;
        testMentor["data"]!["level"] = allMentors.mentors[i].property.level;
        testMentor["data"]!["classes"] =
            "${now.year}-${now.month}-${now.day}(${now.hour}:${now.minute}): " +
                resultClasses +
                '\n' +
                allMentors.mentors[i].property.classes; //修改的是这里
        break;
      }
    }
    Mentor.updateMentor(testMentor, mentorID.toString());

    Message.showSuccess(
        context: context,
        message: '添加本次学习功课记录成功！',
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
            title: const Text('请输入本次的学习功课记录'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                  hintText: "请输入本次的学习功课记录：(无需写时间，系统会自动记录时间)"),
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
