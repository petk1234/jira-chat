import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jira_project/features/auth/data/services/auth_service.dart';

class AuthServiceImpl implements AuthService{
  final String API_KEY = dotenv.env['API_KEY']!;
  final String BASE_URL = dotenv.env['BASE_URL']!;
  final _storage = const FlutterSecureStorage();

  @override
  Future<User?> loginToJira(String email) async {
    try {
      final String url = "$BASE_URL/user/search?query=$email";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
        'Basic ${base64.encode(utf8.encode('$email:$API_KEY'))}'
      };
      print("SJDJ ${email} ${API_KEY}");
      final response = await http.get(URIData, headers: requestHeaders);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        await _storage.write(key: 'email', value: email);
        final User user = User.fromJson(jsonDecode(response.body)[0]);
        return user;
      } else {
        throw ('User not found');
      }
    } catch (err) {
      throw ('Login Error: $err');
    }
  }
}