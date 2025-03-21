import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  final Dio dio = Dio(BaseOptions(
    followRedirects: true,
    validateStatus: (status) => status! < 500,
  ));

  Future<bool> login(String username, String password) async {
    final loginUrl = 'https://siga.cps.sp.gov.br/aluno/login.aspx';

    try {
      /*
      * Get Request to fetch the login page
      */
      final getResponse = await dio.get(loginUrl);
      if (getResponse.statusCode == 200) {
        /*
        * Extracting GXState using regex
        */
        String extractGXState(String html) {
          int startIndex = html.indexOf('name="GXState" value="');
          if (startIndex == -1) return '';
          startIndex += 22; // Move to actual value
          int endIndex = html.indexOf('"', startIndex);
          return endIndex != -1 ? html.substring(startIndex, endIndex) : '';
        }

        String gxState = extractGXState(getResponse.data);

        if (kDebugMode) {
          print("Extracted GXState: $gxState"); // Debugging
        }

        if (gxState.isEmpty) {
          if (kDebugMode) {
            print('Failed to extract GXState'); // Debugging
          }
          return false;
        }

        /*
        * POST Request with login credentials
        */
        final postResponse = await dio.post(
          loginUrl,
          data: {
            'vSIS_USUARIOID': username,
            'vSIS_USUARIOSENHA': password,
            'BTCONFIRMA': 'Confirmar',
            'GXState': gxState,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
          ),
        );

        /*
        * Check if login was successful
        */
        if (postResponse.statusCode == 200 && postResponse.data.contains('home.aspx')) {
          if (kDebugMode) {
            print('Login successful!');
          }
          return true;
        } else {
          if (kDebugMode) {
            print('Login failed. Check credentials.');
          }
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
    }
    return false;
  }
}