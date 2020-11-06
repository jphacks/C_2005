import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:ichimai/src/models/user.dart';

class ConnectionService {
  Future<String> getToken(UserData userData, String channel) async {
    final String uid = userData.generateAgoraUid().toString();
    final response = await http.get(
        'http://oram.kr/jphacks/getToken/RtcTokenBuilderSample.php?channelName=$channel&uid=$uid');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
