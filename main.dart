import 'dart:async';
import 'dart:convert';
import 'dart:io';
import './JamesServer.dart';

Future main() async {
  JamesServer james = new JamesServer();
  await james.listen(4000);
  await james.get('/', (HttpRequest req, HttpResponse res) => res.write('Hello, JamesServer'));
  await james.get('/fs2', (HttpRequest req, HttpResponse res) async {
    HttpClient client = new HttpClient();
    HttpClientRequest req2 = await client.getUrl(Uri.parse("http://localhost:4000/"));
    HttpClientResponse res2 = await req2.close();
    String body = '';
    await Future(() async {
      res2.transform(utf8.decoder).listen((String contents) {
        body = contents;
      });
      return;
    });
    Map<String, String> data = {'data': "DORNEDER", "DATA": "적용중", "body": body};
    return await JamesServer.doRender(req: req, res: res, path: './my.do', data: data);
  });
  await james.get('/admin', (HttpRequest req, HttpResponse res) => res.write('Hello, JamesAdmin'));
  await james.get('/qs', (HttpRequest req, HttpResponse res) {
    print("ID : ${req.uri.pathSegments.toString()}");
    res.write('Hello, QueryString - ID : ${req.uri.queryParameters['id'].toString()}');
  });
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
  Map<String, List<Map<String, String>>> datas = {
    "data": [
      {"id": "1", "name": "James"},
      {"id": "2", "name": "Dev"},
      {"id": "3", "name": "JamesDEV"},
      {"id": "4", "name": "Flutter 2"},
      {"id": "5", "name": "WEB APP"},
      {"id": "6", "name": "WEB And IOS"}
    ]
  };
  await james.get('/contents', (req, res) => res.write(json.encode(datas)));
  await james.get('/lists', (req, res) async => await JamesServer.doRender(req: req, res: res, path: './views/lists.do'));
  await james.post('/', (HttpRequest req, HttpResponse res) => res.write('HI POST ? - JamseServer'));
  return;
}
