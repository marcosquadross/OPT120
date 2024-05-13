import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opt120/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserApi {
  static const String baseUrl = 'http://localhost:3000';
  static const storage = FlutterSecureStorage();

  Future<UserModel> getUser(int id) async {
    final accessToken = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/getUser/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserModel.fromMap(data);
    } else {
      throw 'Failed to get user';
    }
  }

  Future<List<UserModel>> getUsers() async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/listUsers'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => UserModel.fromMap(item)).toList();
    } else {
      throw 'Failed to get users';
    }
  }

  Future<String> create(UserModel user) async {
    final Map<String, dynamic> requestBody = user.toMap();
    requestBody.remove('id');

    final response = await http.post(
      Uri.parse('$baseUrl/registerUser'),
      headers: {
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

  Future<String> update(UserModel user) async {
    final accessToken = await storage.read(key: 'access_token');
    int? id = user.id;
    final Map<String, dynamic> requestBody = user.toMap();
    requestBody.remove('id');

    final response = await http.put(
      Uri.parse('$baseUrl/updateUser/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody), // Serialize o mapa para JSON
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  Future<void> delete(int id) async {
    final accessToken = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/deleteUser/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      throw 'Failed to delete user';
    }
  }

  Future<String> login(String email, String password) async {
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      await storage.write(
          key: 'access_token', value: jsonDecode(response.body)['accessToken']);
      return jsonDecode(response.body)['message'];
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'access_token');
  }
}
