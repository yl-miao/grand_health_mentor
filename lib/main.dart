import 'package:flutter/material.dart';
import 'package:grand_health_mentor/pages/index.dart';
import 'package:grand_health_mentor/styles/index.dart';
import 'package:grand_health_mentor/utils/index.dart';
import 'package:grand_health_mentor/widgets/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大健康辅导师系统',
      theme: AppTheme.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //模板里是true
      extendBody: false, // 扩展到Scaffold的底部
      resizeToAvoidBottomInset: false, // 不允许键盘事件影响界面
      appBar: AppBar(
        title: const Text("大健康辅导师系统"),
      ),
      // PageController 控制 PageView 呈现页面
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 10),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(), //不允许左右滑动换页
          controller: pageController,
          onPageChanged: onIndexChanged,
          children: const [
            AllStudentsPage(),
            LearnPage(),
            AllAdHocsPage(),
            UserPage(),
          ],
        ),
      ),
      // 底部带凹下的导航
      bottomNavigationBar: BuildNavigation(
        currentIndex: currentIndex,
        items: [
          NavigationItemModel(
            label: "主页",
            icon: SvgIcon.layout,
          ),
          NavigationItemModel(
            label: "功课",
            icon: SvgIcon.marker,
          ),
          NavigationItemModel(
            label: "审批",
            icon: SvgIcon.chat,
            count: 3,
          ),
          NavigationItemModel(
            label: "用户",
            icon: SvgIcon.user,
          ),
        ],
        onTap: onIndexChanged, // 切换tab事件
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) {
              return const NewStudentPage();
            }),
          );
        },
        child: const Icon(Icons.add_circle_rounded, size: 50),
      ), // 浮动按钮
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 浮动按钮 停靠在底部中间位置
    );
  }
}
