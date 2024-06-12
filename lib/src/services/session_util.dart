import 'dart:html';

void saveUserSession(String token) {
  window.localStorage['userToken'] = token;
}

String? getUserSession() {
  return window.localStorage['userToken'];
}
