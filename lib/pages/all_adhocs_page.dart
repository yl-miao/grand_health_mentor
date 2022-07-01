import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/AdHocClass.dart';
import '../classes/MentorClass.dart';
import '../classes/MessageClass.dart';
import '../main.dart';

class AllAdHocsPage extends StatefulWidget {
  const AllAdHocsPage({Key? key}) : super(key: key);

  @override
  State<AllAdHocsPage> createState() => _AllAdHocsPageState();
}

class _AllAdHocsPageState extends State<AllAdHocsPage> {
  final _biggerFont = const TextStyle(fontSize: 18);
  List<AdHoc> _allAdHocs = <AdHoc>[];

  @override
  void initState() {
    super.initState();
    _customizeActions();
  }

  void _customizeActions() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedIn') == 'yes') {
      final adHocsList = await AdHoc.fetchAdHocs();
      setState(() {
        List<AdHoc> tmp = adHocsList.adHocs;
        tmp.removeWhere((element) {
          if (element.property.finished == "yes") {
            return true;
          } else {
            return false;
          }
        });
        _allAdHocs = tmp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目前所有需要批准的请求：'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.list),
        //     onPressed: _pushSaved,
        //     tooltip: 'Saved Suggestions',
        //   ),
        // ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _allAdHocs.length * 2, //不知道为啥这里要+2(+3的话最底下也有个分割线)
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;

          return ListTile(
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(
              _allAdHocs[index].property.type,
              style: _biggerFont,
            ),
            onTap: () {
              AdHoc _adHoc = _allAdHocs[index];
              var text1 = Text('');
              var text2 = Text('');
              if (_adHoc.property.type == "重设密码申请") {
                text1 = const Text("申请更改成新的一级密码：");
                text2 = const Text("申请更改成新的二级密码：");
              } else if (_adHoc.property.type == "新辅导师注册申请") {
                text1 = const Text("该辅导师姓名：");
                text2 = const Text("该辅导师身份证号：");
              }
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) {
                    final tiles = <Widget>[
                      ListTile(
                        title: const Text('申请人手机号:'),
                        subtitle: Text(_adHoc.property.from),
                      ),
                      ListTile(
                        title: const Text('到:'),
                        subtitle: Text(_adHoc.property.to),
                      ),
                      ListTile(
                        title: text1,
                        subtitle: Text(_adHoc.property.message1),
                      ),
                      ListTile(
                        title: text2,
                        subtitle: Text(_adHoc.property.message2),
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('同意'),
                          // onPressed: () => doAgree(),
                          onPressed: () {
                            if (_adHoc.property.type == "重设密码申请") {
                              doAgreeResetPassWord(
                                  _adHoc.id.toString(),
                                  _adHoc.property.from,
                                  _adHoc.property.message1,
                                  _adHoc.property.message2);
                            } else if (_adHoc.property.type == "新辅导师注册申请") {
                              doAgreeNewMentor(
                                  _adHoc.id.toString(),
                                  _adHoc.property.from,
                                  _adHoc.property.message1,
                                  _adHoc.property.message2);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('拒绝'),
                          // onPressed: () => doDecline(),
                          onPressed: () {
                            if (_adHoc.property.type == "重设密码申请") {
                              doDeclineResetPassWord(
                                  _adHoc.id.toString(),
                                  _adHoc.property.from,
                                  _adHoc.property.message1,
                                  _adHoc.property.message2);
                            } else if (_adHoc.property.type == "新辅导师注册申请") {
                              doDeclineNewMentor(
                                  _adHoc.id.toString(),
                                  _adHoc.property.from,
                                  _adHoc.property.message1,
                                  _adHoc.property.message2);
                            }
                          },
                        ),
                      )
                    ];
                    final divided = tiles.isNotEmpty
                        ? ListTile.divideTiles(
                            context: context,
                            tiles: tiles,
                          ).toList()
                        : <Widget>[];

                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('此辅导师信息'),
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
    );
  }

  void doAgreeResetPassWord(
      String adHocID, String phone, String pass1, String pass2) async {
    MentorsList allMentors = await Mentor.fetchMentors();
    late int mentorID;
    var testMentor = <String, Map<String, String>>{};
    testMentor["data"] = <String, String>{};

    for (int i = 0; i < allMentors.mentors.length; i++) {
      if (allMentors.mentors[i].property.phone == phone) {
        mentorID = allMentors.mentors[i].id;
        testMentor["data"]!["idCard"] = allMentors.mentors[i].property.idCard;
        testMentor["data"]!["name"] = allMentors.mentors[i].property.name;
        testMentor["data"]!["pass1"] = pass1; //修改的是这里
        testMentor["data"]!["pass2"] = pass2; //修改的是这里
        testMentor["data"]!["phone"] = allMentors.mentors[i].property.phone;
        testMentor["data"]!["authorized"] =
            allMentors.mentors[i].property.authorized;
        testMentor["data"]!["level"] = allMentors.mentors[i].property.level;
        testMentor["data"]!["classes"] = allMentors.mentors[i].property.classes;
        break;
      }
    }
    Mentor.updateMentor(testMentor, mentorID.toString());

    var testAdHocMessage = <String, Map<String, String>>{};
    testAdHocMessage["data"] = <String, String>{};

    testAdHocMessage["data"]!["type"] = "重设密码申请-已被批准"; //修改的是这里
    testAdHocMessage["data"]!["from"] = phone;
    testAdHocMessage["data"]!["to"] = "管理员";
    testAdHocMessage["data"]!["message1"] = pass1;
    testAdHocMessage["data"]!["message2"] = pass2;
    testAdHocMessage["data"]!["finished"] = "yes"; //修改的是这里
    AdHoc.updateAdHocMessage(testAdHocMessage, adHocID);

    Message.showSuccess(
        context: context,
        message: '已同意该用户的重设密码请求！',
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        });
  }

  void doAgreeNewMentor(
      String adHocID, String phone, String name, String idCard) async {
    //在这里加个弹窗选择辅导师级别。然后update一下authorize和level和adhoc。
    var resultLevel = await _showTextInputDialog(context);
    if (resultLevel == null) {
      Message.showError(context: context, message: '必须指定等级！');
      return;
    }

    MentorsList allMentors = await Mentor.fetchMentors();
    late int mentorID;
    var testMentor = <String, Map<String, String>>{};
    testMentor["data"] = <String, String>{};

    for (int i = 0; i < allMentors.mentors.length; i++) {
      if (allMentors.mentors[i].property.phone == phone) {
        mentorID = allMentors.mentors[i].id;
        testMentor["data"]!["idCard"] = allMentors.mentors[i].property.idCard;
        testMentor["data"]!["name"] = allMentors.mentors[i].property.name;
        testMentor["data"]!["pass1"] = allMentors.mentors[i].property.pass1;
        testMentor["data"]!["pass2"] = allMentors.mentors[i].property.pass2;
        testMentor["data"]!["phone"] = allMentors.mentors[i].property.phone;
        testMentor["data"]!["authorized"] = "yes"; //修改的是这里
        testMentor["data"]!["level"] = resultLevel; //修改的是这里
        testMentor["data"]!["classes"] = allMentors.mentors[i].property.classes;
        break;
      }
    }
    Mentor.updateMentor(testMentor, mentorID.toString());

    var testAdHocMessage = <String, Map<String, String>>{};
    testAdHocMessage["data"] = <String, String>{};
    testAdHocMessage["data"]!["type"] = "新辅导师注册申请-已被批准"; //修改的是这里
    testAdHocMessage["data"]!["from"] = phone;
    testAdHocMessage["data"]!["to"] = "管理员";
    testAdHocMessage["data"]!["message1"] = name;
    testAdHocMessage["data"]!["message2"] = idCard;
    testAdHocMessage["data"]!["finished"] = "yes"; //修改的是这里
    AdHoc.updateAdHocMessage(testAdHocMessage, adHocID);

    Message.showSuccess(
        context: context,
        message: '已同意该用户的注册新辅导师请求！',
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        });
  }

  void doDeclineResetPassWord(
      String adHocID, String phone, String pass1, String pass2) {
    var testAdHocMessage = <String, Map<String, String>>{};
    testAdHocMessage["data"] = <String, String>{};

    testAdHocMessage["data"]!["type"] = "重设密码申请-已被拒绝"; //修改的是这里
    testAdHocMessage["data"]!["from"] = phone;
    testAdHocMessage["data"]!["to"] = "管理员";
    testAdHocMessage["data"]!["message1"] = pass1;
    testAdHocMessage["data"]!["message2"] = pass2;
    testAdHocMessage["data"]!["finished"] = "yes"; //修改的是这里
    AdHoc.updateAdHocMessage(testAdHocMessage, adHocID);
    Message.showSuccess(
        context: context,
        message: '已拒绝该辅导师的重设密码请求！\n改辅导师的密码将保持不变。',
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        });
  }

  void doDeclineNewMentor(
      String adHocID, String phone, String name, String idCard) async {
    MentorsList allMentors = await Mentor.fetchMentors();
    late int mentorID;
    for (int i = 0; i < allMentors.mentors.length; i++) {
      if (allMentors.mentors[i].property.phone == phone) {
        mentorID = allMentors.mentors[i].id;
        break;
      }
    }
    Mentor.deleteMentor(mentorID.toString());

    var testAdHocMessage = <String, Map<String, String>>{};
    testAdHocMessage["data"] = <String, String>{};
    testAdHocMessage["data"]!["type"] = "新辅导师注册申请-已被拒绝"; //修改的是这里
    testAdHocMessage["data"]!["from"] = phone;
    testAdHocMessage["data"]!["to"] = "管理员";
    testAdHocMessage["data"]!["message1"] = name;
    testAdHocMessage["data"]!["message2"] = idCard;
    testAdHocMessage["data"]!["finished"] = "yes"; //修改的是这里
    AdHoc.updateAdHocMessage(testAdHocMessage, adHocID);
    Message.showSuccess(
        context: context,
        message: '已拒绝该用户的注册新辅导师请求！',
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
            title: const Text('请指定该辅导师的等级(1-3)必填'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "请指定该辅导师的等级(1-3)必填"),
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
