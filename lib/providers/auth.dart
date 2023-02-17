import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;

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

  String? get userId{
    return _userId;
  }

  Future<void> _authenticated(
      String email, String password, String urlSegment) async {
    const params = {'key': 'AIzaSyDqxgQgYbdKZ-B6sXXzEU7Hnbx_gvzUrjY'};
    var url = Uri.https(
        'identitytoolkit.googleapis.com', '/v1/accounts:$urlSegment', params);

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      debugPrint(response.body);
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
      debugPrint('token: $_token');
      debugPrint('userId: $_userId');
      debugPrint('expireData: $_expireDate');

      notifyListeners();

    } catch (error) {
      //for network
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticated(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticated(email, password, 'signInWithPassword');
  }
}
