import 'package:flutter/material.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  AuthResponse? _authResponse;
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  AuthResponse? get authResponse => _authResponse;

  Future<void> register(String email, String password, String name) async {
    _authResponse = await _apiService.register(email, password, name);
    await _storageService.saveSessionId(_authResponse!.token);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _authResponse = await _apiService.login(email, password);
    await _storageService.saveSessionId(_authResponse!.token);
    notifyListeners();
  }

  Future<void> logout() async {
    _authResponse = null;
    await _storageService.clearSessionId();
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    final sessionId = await _storageService.getSessionId();
    return sessionId != null;
  }
}