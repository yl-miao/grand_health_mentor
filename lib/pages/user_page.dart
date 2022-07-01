import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/MentorClass.dart';
import '../classes/MessageClass.dart';
import 'logged_in_user_page.dart';
import 'reset_password_page.dart';
import 'sign_up_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // with AutomaticKeepAliveClientMixin
  //      with AutomaticKeepAliveClientMixin
  // @override
  // bool get wantKeepAlive => true; // 是否需要缓存

  bool isLoggedIn = false;

  final controllerIDCard = TextEditingController();
  final controllerFirstPassword = TextEditingController();
  final controllerSecondPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customizeActions();
  }

  void _customizeActions() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('loggedIn') == 'yes') {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const LoggedInUserPage();
    } else {
      // super.build(context); // 必须调用?
      return Scaffold(
        extendBody: false, // 扩展到Scaffold的底部
        resizeToAvoidBottomInset: false, // 不允许键盘事件影响界面
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Image.network('https://zfile.miaoyilin.com/s/zr9xil'),
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
                controller: controllerFirstPassword,
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
                controller: controllerSecondPassword,
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
                height: 16,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('登录'),
                  onPressed: () => _doUserLogin(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('注册'),
                  onPressed: () => _navigateToSignUp(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('忘记密码'),
                  onPressed: () => _navigateToResetPassword(),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void _doUserLogin() async {
    final idCard = controllerIDCard.text.trim();
    final pass1 = controllerFirstPassword.text.trim();
    final pass2 = controllerSecondPassword.text.trim();
    MentorsList allMentors = await Mentor.fetchMentors();
    final prefs = await SharedPreferences.getInstance();
    String success = "false";
    for (int i = 0; i < allMentors.mentors.length; i++) {
      if (allMentors.mentors[i].property.idCard == idCard) {
        if (allMentors.mentors[i].property.pass1 == pass1) {
          if (allMentors.mentors[i].property.pass2 == pass2) {
            if (allMentors.mentors[i].property.authorized == "yes") {
            } else {
              success = "unauthorized";
              break;
            }
            await prefs.setString('loggedIn', 'yes');
            await prefs.setString('id', i.toString());
            await prefs.setString(
                'idCard', allMentors.mentors[i].property.idCard);
            await prefs.setString('name', allMentors.mentors[i].property.name);
            await prefs.setString(
                'pass1', allMentors.mentors[i].property.pass1);
            await prefs.setString(
                'pass2', allMentors.mentors[i].property.pass2);
            await prefs.setString(
                'phone', allMentors.mentors[i].property.phone);
            await prefs.setString(
                'level', allMentors.mentors[i].property.level);
            await prefs.setString(
                'authorized', allMentors.mentors[i].property.authorized);
            await prefs.setString(
                'classes', allMentors.mentors[i].property.classes);
            success = "true";
            break;
          }
        }
      }
    }
    if (success == "true") {
      setState(() {
        isLoggedIn = true;
      });
    } else if (success == "false") {
      Message.showMessage(context, '身份证或密码错误！');
      return;
    } else if (success == "unauthorized") {
      Message.showMessage(context, '账号密码正确但账户未经1级辅导师同意！\n请通知1级辅导师审批后再登陆！');
      return;
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
    );
  }
}
