import 'package:place_picker/helpers/localization/response_phrases.dart';

/// To get the phrases for a specific language
String getResponsePhrase(String key, String locale) {
  return '${responsePhrases[key]![locale]}';
}
