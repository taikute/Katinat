import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main() {
  final jwt = JWT({'id': '123'});
  final token = jwt.sign(SecretKey('123'));
  print(token);
  final decode = JWT.decode(token);
  print(decode.payload);
}
