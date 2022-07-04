import 'package:google_place_picker/helpers/localization/response_phrases.dart';

/// To get the response phrases for a specific language
String getResponsePhrase(String key, String locale) {
  return '${responsePhrases[key]![locale]}';
}
