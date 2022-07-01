import 'package:flutter/material.dart';

import '../classes/MentorClass.dart';

class AllMentorsPage extends StatefulWidget {
  const AllMentorsPage({Key? key}) : super(key: key);

  @override
  State<AllMentorsPage> createState() => _AllMentorsPageState();
}

class _AllMentorsPageState extends State<AllMentorsPage> {
  final _biggerFont = const TextStyle(fontSize: 18);
  List<Mentor> _allMentors = <Mentor>[];

  @override
  void initState() {
    super.initState();
    _customizeActions();
  }

  void _customizeActions() async {
    WidgetsFlutterBinding.ensureInitialized();
    final mentorsList = await Mentor.fetchMentors();
    // print(mentorsList.mentors.length);
    setState(() {
      _allMentors = mentorsList.mentors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目前所有辅导师'),
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
        itemCount: _allMentors.length * 2, //不知道为啥这里要+2(+3的话最底下也有个分割线)
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;

          return ListTile(
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(
              _allMentors[index].property.name,
              style: _biggerFont,
            ),
            onTap: () {
              Mentor _mentor = _allMentors[index];
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) {
                    final tiles = <Widget>[
                      ListTile(
                        title: const Text('姓名:'),
                        subtitle: Text(_mentor.property.name),
                      ),
                      ListTile(
                        title: const Text('身份证:'),
                        subtitle: Text(_mentor.property.idCard),
                      ),
                      ListTile(
                        title: const Text('电话:'),
                        subtitle: Text(_mentor.property.phone),
                      ),
                      ListTile(
                        title: const Text('是否已被授权:'),
                        subtitle: Text(_mentor.property.authorized),
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
}
