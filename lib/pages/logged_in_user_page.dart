import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:updater/updater.dart';

import '../classes/MessageClass.dart';
import '../main.dart';
import 'all_mentors_page.dart';
import 'reset_password_page.dart';

class LoggedInUserPage extends StatefulWidget {
  const LoggedInUserPage({Key? key}) : super(key: key);

  @override
  State<LoggedInUserPage> createState() => _LoggedInUserPageState();
}

class _LoggedInUserPageState extends State<LoggedInUserPage>
    with AutomaticKeepAliveClientMixin {
  dynamic version;
  late String id;
  late String? idCard;
  late String? name;
  late String? pass1;
  late String? pass2;
  late String? phone;
  late String? level;
  late String? authorized;
  late String? classes;

  @override
  bool get wantKeepAlive => true; // 是否需要缓存

  void _getMentorInfo() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id')!;
      idCard = prefs.getString('idCard')!;
      name = prefs.getString('name')!;
      pass1 = prefs.getString('pass1')!;
      pass2 = prefs.getString('pass2')!;
      phone = prefs.getString('phone')!;
      level = prefs.getString('level')!;
      authorized = prefs.getString('authorized')!;
      classes = prefs.getString('classes')!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getMentorInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用?
    return Scaffold(
        appBar: AppBar(
          title: const Text('辅导师已登录'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: Image.network('https://zfile.miaoyilin.com/s/zr9xil'),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    VersionModel model = await getAppVersion();
                    setState(() {
                      version = '${model.version}.${model.buildNumber}';
                    });
                  },
                  child: Text(
                    version ?? '获取当前软件版本',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Center(
                  child: Text('目前登录辅导师： $name',
                      style: const TextStyle(fontSize: 15))),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('退出此账号'),
                  onPressed: () => doUserLogout(context),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('查看所有辅导师'),
                  onPressed: () => showAllMentors(context),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('修改密码'),
                  onPressed: () => _navigateToResetPassword(),
                ),
              ),
            ],
          ),
        ));
  }

  void doUserLogout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedIn', 'no');

    Message.showSuccess(
        context: context,
        message: '成功退出用户!',
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (Route<dynamic> route) => false,
          );
        });
  }

  void showAllMentors(context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('level') == "1") {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) {
          return const AllMentorsPage();
        }),
      );
    } else {
      Message.showMessage(context, '只有1级辅导师才能查看其他辅导师的信息！');
      return;
    }
  }

  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
    );
  }
}
