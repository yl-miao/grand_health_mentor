import 'dart:convert';

import 'package:http/http.dart' as http;

class AdHocProperty {
  final String type;
  final String from;
  final String to;
  final String message1;
  final String message2;
  final String finished;

  AdHocProperty({
    required this.type,
    required this.from,
    required this.to,
    required this.message1,
    required this.message2,
    required this.finished,
  });

  factory AdHocProperty.fromJson(Map<String, dynamic> json) {
    return AdHocProperty(
      type: json['type'].toString(),
      from: json['from'].toString(),
      to: json['to'].toString(),
      message1: json['message1'].toString(),
      message2: json['message2'].toString(),
      finished: json['finished'].toString(),
    );
  }
}

class AdHoc {
  final int id;
  final AdHocProperty property;

  AdHoc({
    required this.id,
    required this.property,
  });

  factory AdHoc.fromJson(Map<String, dynamic> parsedJson) {
    return AdHoc(
        id: parsedJson['id'],
        property: AdHocProperty.fromJson(parsedJson['attributes']));
  }

  static Future<http.Response> createAdHocMessage(
      Map<String, dynamic> adHocMessage) {
    return http.post(
      Uri.parse('https://strapi.miaoyilin.com/api/adhocs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
      },
      body: jsonEncode(adHocMessage),
    );
  }

  static Future<http.Response> updateAdHocMessage(
      Map<String, dynamic> adHocMessage, String id) {
    return http.put(
      Uri.parse('https://strapi.miaoyilin.com/api/adhocs/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
      },
      body: jsonEncode(adHocMessage),
    );
  }

  static Future<AdHocList> fetchAdHocs() async {
    final response = await http.get(
        Uri.parse('https://strapi.miaoyilin.com/api/adhocs'),
        headers: <String, String>{
          'Authorization':
              'Bearer 9064ae6a8fad6cdd09193b095c2abd6e2f06b799f15bd8ea95b22f3f29eef5263ab2fbc1bf9ab9f32d884d05234b714c7d3b710c19be6b6742d5b89ace04edc1a7ad6e57cdcbd7c613a77b25b0314d5e2ec727fdfdae759b3913eca1e69e13434d08c173cd12717eb4667b1416d027f97d851d094c7aeb7f2d15c58cb240be1b',
        });
    if (response.statusCode == 200) {
      return AdHocList.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load adhocs');
    }
  }
}

class AdHocList {
  final List<AdHoc> adHocs;

  AdHocList({
    required this.adHocs,
  });

  factory AdHocList.fromJson(List<dynamic> parsedJson) {
    List<AdHoc> adHocs = <AdHoc>[];
    adHocs = parsedJson.map((i) => AdHoc.fromJson(i)).toList();
    return AdHocList(
      adHocs: adHocs,
    );
  }
}
