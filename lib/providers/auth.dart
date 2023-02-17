import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import '../models/http_exception.dart';
import '../constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticated(String email, String password,
      String urlSegment) async {
    var url = Uri.https(
        'identitytoolkit.googleapis.com', '/v1/accounts:$urlSegment', params_k);

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      // debugPrint(response.body);
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(
            responseData['error']['message']); //for firebase related errors
      }
      //no error - store the token
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();

      // debugPrint('token: $_token');
      // debugPrint('userId: $_userId');
      // debugPrint('expireData: $_expireDate');

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      //use json.encode -> always a String
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate?.toIso8601String(),
      });
      prefs.setString('userData', userData);

    } catch (error) {
      //for network
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticated(email, password, 'signUp');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String?, dynamic>;
    final expireDate = DateTime.parse(extractedUserData['expireDate']);
    if(expireDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = extractedUserData['expireDate'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> login(String email, String password) async {
    return _authenticated(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();

  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpire = _expireDate
        ?.difference(DateTime.now())
        .inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire!), logout);
  }

}
