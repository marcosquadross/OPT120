import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opt120/models/activity_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivityApi {
  static const String baseUrl = 'http://localhost:3000';
  static const storage = FlutterSecureStorage();

  Future<ActivityModel> getActivity(int id) async {
    final accessToken = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/getActivity/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ActivityModel.fromMap(data);
    } else {
      throw Exception('Failed to get activity');
    }
  }

  Future<List<ActivityModel>> getActivities() async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/listActivities'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ActivityModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to get activities');
    }
  }

  Future<String> create(ActivityModel activity) async {
    final accessToken = await storage.read(key: 'access_token');
    final Map<String, dynamic> requestBody = activity.toMap();
    requestBody.remove('id');

    if (requestBody['date'] is DateTime) {
      requestBody['date'] = (requestBody['date'] as DateTime).toIso8601String();
    }

    final response = await http.post(
      Uri.parse('$baseUrl/createActivity'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to create activity');
    }
  }

  Future<String> update(ActivityModel activity) async {
    int? id = activity.id;
    final accessToken = await storage.read(key: 'access_token');

    final Map<String, dynamic> requestBody = activity.toMap();
    requestBody.remove('id');

    if (requestBody['date'] is DateTime) {
      requestBody['date'] = (requestBody['date'] as DateTime).toIso8601String();
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updateActivity/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to create activity');
    }
  }

  Future<void> delete(int id) async {
    final accessToken = await storage.read(key: 'access_token');

    final response =
        await http.delete(Uri.parse('$baseUrl/deleteActivity/$id'), headers: {
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }
}
