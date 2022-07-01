import 'dart:convert';

import 'package:http/http.dart' as http;

class MentorProperty {
  final String idCard;
  final String name;
  final String pass1;
  final String pass2;
  final String phone;
  final String level;
  final String authorized;
  final String classes;

  MentorProperty({
    required this.idCard,
    required this.name,
    required this.pass1,
    required this.pass2,
    required this.phone,
    required this.level,
    required this.authorized,
    required this.classes,
  });

  factory MentorProperty.fromJson(Map<String, dynamic> json) {
    return MentorProperty(
      idCard: json['idCard'].toString(),
      name: json['name'].toString(),
      pass1: json['pass1'].toString(),
      pass2: json['pass2'].toString(),
      phone: json['phone'].toString(),
      level: json['level'].toString(),
      authorized: json['authorized'].toString(),
      classes: json['classes'].toString(),
    );
  }
}

class Mentor {
  final int id;
  final MentorProperty property;

  Mentor({
    required this.id,
    required this.property,
  });

  factory Mentor.fromJson(Map<String, dynamic> parsedJson) {
    return Mentor(
        id: parsedJson['id'],
        property: MentorProperty.fromJson(parsedJson['attributes']));
  }
  static Future<MentorsList> fetchMentors() async {
    final response = await http.get(
        Uri.parse('https://strapi.miaoyilin.com/api/mentors'),
        headers: <String, String>{
          'Authorization':
              'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
        });
    if (response.statusCode == 200) {
      return MentorsList.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load mentors');
    }
  }

  static Future<http.Response> createMentor(Map<String, dynamic> mentor) {
    return http.post(
      Uri.parse('https://strapi.miaoyilin.com/api/mentors'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
      },
      body: jsonEncode(mentor),
    );
  }

  static Future<http.Response> updateMentor(
      Map<String, dynamic> mentor, String id) {
    return http.put(
      Uri.parse('https://strapi.miaoyilin.com/api/mentors/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
      },
      body: jsonEncode(mentor),
    );
  }

  static Future<http.Response> deleteMentor(String id) {
    return http.delete(
        Uri.parse('https://strapi.miaoyilin.com/api/mentors/${id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
        });
  }
}

class MentorsList {
  final List<Mentor> mentors;

  MentorsList({
    required this.mentors,
  });

  factory MentorsList.fromJson(List<dynamic> parsedJson) {
    List<Mentor> mentors = <Mentor>[];
    mentors = parsedJson.map((i) => Mentor.fromJson(i)).toList();
    return MentorsList(
      mentors: mentors,
    );
  }
}
