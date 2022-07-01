import 'dart:convert';

import 'package:http/http.dart' as http;

class StudentProperty {
  final String name;
  final String pass;
  final String idCard;
  final String answer;
  final String note;
  final String phone;
  final String authorized;
  final String mentorID;
  final String mentorName;
  final String classes;

  StudentProperty({
    required this.name,
    required this.pass,
    required this.idCard,
    required this.answer,
    required this.note,
    required this.phone,
    required this.authorized,
    required this.mentorID,
    required this.mentorName,
    required this.classes,
  });

  factory StudentProperty.fromJson(Map<String, dynamic> json) {
    return StudentProperty(
      name: json['name'].toString(),
      pass: json['pass'].toString(),
      idCard: json['idCard'].toString(),
      answer: json['answer'].toString(),
      note: json['note'].toString(),
      phone: json['phone'].toString(),
      authorized: json['authorized'].toString(),
      mentorID: json['mentorID'].toString(),
      mentorName: json['mentorName'].toString(),
      classes: json['classes'].toString(),
    );
  }
}

class Student {
  final int id;
  final StudentProperty property;

  Student({
    required this.id,
    required this.property,
  });

  factory Student.fromJson(Map<String, dynamic> parsedJson) {
    return Student(
        id: parsedJson['id'],
        property: StudentProperty.fromJson(parsedJson['attributes']));
  }
  static Future<StudentsList> fetchStudents() async {
    final response = await http.get(
        Uri.parse('https://strapi.miaoyilin.com/api/students'),
        headers: <String, String>{
          'Authorization':
              'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
        });
    if (response.statusCode == 200) {
      return StudentsList.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load students');
    }
  }

  static Future<http.Response> createStudent(Map<String, dynamic> newStudent) {
    return http.post(
      Uri.parse('https://strapi.miaoyilin.com/api/students'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
      },
      body: jsonEncode(newStudent),
    );
  }

  static Future<http.Response> updateStudent(
      Map<String, dynamic> student, String id) {
    return http.put(
      Uri.parse('https://strapi.miaoyilin.com/api/students/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
      },
      body: jsonEncode(student),
    );
  }
}

class StudentsList {
  final List<Student> students;

  StudentsList({
    required this.students,
  });

  factory StudentsList.fromJson(List<dynamic> parsedJson) {
    List<Student> students = <Student>[];
    students = parsedJson.map((i) => Student.fromJson(i)).toList();
    return StudentsList(
      students: students,
    );
  }
}
