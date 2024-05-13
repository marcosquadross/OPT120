import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_activity_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserActivityApi {
  static const String baseUrl = 'http://localhost:3000';
  static const storage = FlutterSecureStorage();

  Future<List<UserActivityModel>> getUserActivityByUser(int id) async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/listUserActivityByUser/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => UserActivityModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to get activity');
    }
  }

  Future<List<UserActivityModel>> getUserActivities() async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/listUserActivity'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => UserActivityModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to get activities');
    }
  }

  Future<String> create(UserActivityModel activity) async {
    final accessToken = await storage.read(key: 'access_token');

    final Map<String, dynamic> requestBody = activity.toMap();

    if (requestBody['delivery_date'] is DateTime) {
      requestBody['delivery_date'] =
          (requestBody['delivery_date'] as DateTime).toIso8601String();
    }

    final response = await http.post(
      Uri.parse('$baseUrl/createUserActivity'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  Future<void> updateScore(int userId, int activityId, double score) async {
    final accessToken = await storage.read(key: 'access_token');

    Map<String, dynamic> requestBody = {
      'user_id': userId,
      'activity_id': activityId,
      'score': score
    };

    final response = await http.put(
      Uri.parse('$baseUrl/updateScore'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update activity');
    }
  }

  Future<void> delete(int userId, int activityId) async {
    final accessToken = await storage.read(key: 'access_token');

    Map<String, dynamic> requestBody = {
      'user_id': userId,
      'activity_id': activityId,
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/deleteUserActivity'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar nota');
    }
  }
}
