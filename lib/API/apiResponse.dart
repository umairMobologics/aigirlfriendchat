// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:grammer_checker_app/API/Api_Key.dart';
// import 'package:grammer_checker_app/Helper/RemoteConfig/remoteConfigs.dart';
// import 'package:grammer_checker_app/utils/snackbar.dart';
// import 'package:http/http.dart' as http;

import 'dart:developer';
import 'dart:io';

import 'package:agora_new_updated/API/Api_Key.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class APIs {
  static Future<String> makeGeminiRequest(String promt) async {
    String result = '';

    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none)
    ];
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
        safetySettings: safetySettings,
      );
      final prompts = promt;
      final content = [Content.text(prompts)];
      final response = await model.generateContent(content);
      result = response.text ?? '';
      log("text is :    $result");
      return result;
    } on SocketException catch (e) {
      log("plantform exception $e");
      showToast(
        "Make sure your device is connected with internet",
      );
      return ('');
    } catch (e) {
      // Handle exceptions
      log("$e");
      // print('Response: ${response.body}');
      showToast("Something went wrong, please try again");
      return ('');
    }
  }
}

































// class APIs {
//   static Future<String> makeGeminiRequest(String promt) async {
//     String apiUrl = RemoteConfig.apiUrl + apiKey;
//     log("final api key $apiUrl");
//     // Replace the following JSON with your actual request payload
//     Map<String, dynamic> requestBody = {
//       "contents": [
//         {
//           "parts": [
//             {"text": promt}
//           ]
//         }
//       ]
//     };

//     try {
//       // Make a POST request
//       // log("sending responsee");
//       var response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         log("status ok");

//         log(response.body);
//         // Check if the 'candidates' array is present and not empty
//         try {
//           var jsonResponse = jsonDecode(response.body);
//           if (jsonResponse.containsKey('candidates') &&
//               jsonResponse['candidates'].isNotEmpty) {
//             var content = jsonResponse['candidates'][0]['content'];

//             // Check if the 'parts' array is present and not empty
//             if (content.containsKey('parts') && content['parts'].isNotEmpty) {
//               var generatedContent = content['parts'][0]['text'];

//               return (generatedContent);
//             } else {
//               log("incrrect output else");
//               CustomSnackbar.showSnackbar(
//                   "Something went wrong, please try again", SnackPosition.TOP);
//               return ('');
//             }
//           } else {
//             log("invalid response else");
//             CustomSnackbar.showSnackbar(
//                 "we could not response to this query.It may contain harmful words",
//                 SnackPosition.TOP);
//             return ('');
//           }
//         } catch (e) {
//           log("inner catch invalid response else");
//           CustomSnackbar.showSnackbar(
//               "we could not response to this query.It may contain harmful words",
//               SnackPosition.TOP);
//           return '';
//         }
//       } else {
//         // Handle error
//         // print('Response: ${response.body}');
//         CustomSnackbar.showSnackbar(
//             "Something went wrong, please try again", SnackPosition.TOP);
//         return ('');
//       }
//     } on SocketException catch (e) {
//       log("plantform exception $e");
//       CustomSnackbar.showSnackbar(
//           "Make sure your device is connected with internet",
//           SnackPosition.TOP);
//       return ('');
//     } catch (e) {
//       // Handle exceptions
//       log("$e");
//       // print('Response: ${response.body}');
//       CustomSnackbar.showSnackbar(
//           "Something went wrong, please try again", SnackPosition.TOP);
//       return ('');
//     }
//   }
// }
