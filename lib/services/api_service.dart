import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.10.10:8000/api";

  // Inscription
  static Future<http.Response> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  // Connexion
  static Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: {
        'username': username,
        'password': password,
      },
    );
    return response;
  }

  // Création de tontine
  static Future<http.Response> createTontine(String token, String nom, double montant, int membres) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tontines/'),
      headers: {'Authorization': 'Token $token'},
      body: {
        'nom': nom,
        'montant': montant.toString(),
        'membres': membres.toString(),
      },
    );
    return response;
  }

  // Dashboard
  static Future<http.Response> getDashboard(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/members/dashboard/'),
      headers: {'Authorization': 'Token $token'},
    );
    return response;
  }

  // Dépôt
  static Future<http.Response> deposit(String token, double montant) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contributions/'),
      headers: {'Authorization': 'Token $token'},
      body: {'montant': montant.toString()},
    );
    return response;
  }

  // Retrait
  static Future<http.Response> withdraw(String token, double montant) async {
    final response = await http.post(
      Uri.parse('$baseUrl/withdrawals/'),
      headers: {'Authorization': 'Token $token'},
      body: {'montant': montant.toString()},
    );
    return response;
  }

  // Notifications
  static Future<http.Response> getNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/'),
      headers: {'Authorization': 'Token $token'},
    );
    return response;
  }
} 