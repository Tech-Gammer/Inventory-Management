//
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   // static const String baseUrl = 'http://your-server-ip:3000/api/auth';
//   static const String baseUrl = 'http://localhost:3000/api/auth';
//
//   static Future<bool> logout() async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/logout'),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Logout error: $e');
//       return false;
//     }
//   }
//
//   static Future<Map<String, dynamic>> getProfile() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//
//       final response = await http.get(
//         Uri.parse('$baseUrl/profile'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//       throw Exception('Failed to load profile');
//     } catch (e) {
//       throw Exception('Error fetching profile: $e');
//     }
//   }
//
//   static Future<bool> updateProfile(Map<String, dynamic> data) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//
//       final response = await http.put(
//         Uri.parse('$baseUrl/profile'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(data),
//       );
//
//       if (response.statusCode == 200) {
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Update profile error: $e');
//       return false;
//     }
//   }
//
//   static Future<String?> getToken() async {
//     try {
//       // Initialize SharedPreferences
//       await SharedPreferences.getInstance();
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString('auth_token');
//     } on PlatformException catch (e) {
//       print('PlatformException: $e');
//       return null;
//     } catch (e) {
//       print('Error getting token: $e');
//       return null;
//     }
//   }
//   // In your ProfilePage:
//   Future<void> _loadProfileData() async {
//     try {
//       final token = await AuthService.getToken();
//
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
//
//       final response = await http.get(
//         Uri.parse('http://your-server-ip:3000/api/auth/profile'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _userData = data['user'];
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load profile');
//       }
//     } catch (e) {
//       print('Profile load error: $e');
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading profile: ${e.toString()}')),
//       );
//     }
//   }
// }
//
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrls = 'http://$baseUrl/api/auth'; // For Android emulator

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } on PlatformException catch (e) {
      print('PlatformException: $e');
      return null;
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  static Future<bool> logout() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrls/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrls/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrls/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}