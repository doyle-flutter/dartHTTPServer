import 'dart:io';
import './JamesServer.dart';

Future main() async {
  JamesServer james = new JamesServer();
  await james.listen(4000);
  await james.get('/', (HttpRequest req, HttpResponse res) => res.write('Hello, JamesServer'));
  await james.get('/admin', (HttpRequest req, HttpResponse res) => res.write('Hello, JamesAdmin'));
  await james.get('/view', (HttpRequest req, HttpResponse res) {
    res.headers.contentType = ContentType.html;
    res.write('''
      <!doctype html>
      <head><title>제임쓰 DART 서버</title></head>
      <body>
        <h1>JamesServer TEST_HTML</h1>
      </body>
    ''');
  });
  await james.post('/', (HttpRequest req, HttpResponse res) => res.write('HI POST ? - JamseServer'));
  return;
}
