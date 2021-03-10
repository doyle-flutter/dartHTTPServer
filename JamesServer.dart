import 'dart:io';

class JamesServer {
  int? _port;
  HttpServer? server;
  Set<HandlerModel> _handler = new Set();
  JamesServer();

  Future<void> listen(int port, [Function(void)? cb]) async => await Future<void>.microtask(() async {
        this._port = port;
        if (cb == null)
          print("ServerStart : ${this._port}");
        else
          cb(null);
        this.server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
        return;
      }).then<void>((_) async => await _handlerSetting());

  Future<void> get(String path, Function(HttpRequest req, HttpResponse res) cb) async => this._handler.add(new HandlerModel(path: path, method: "GET", cb: cb));
  Future<void> post(String path, Function(HttpRequest req, HttpResponse res) cb, {dynamic? data = null}) async => this._handler.add(new HandlerModel(path: path, method: "POST", cb: cb, data: data));
  Future<void> _handlerSetting() async => await this.server!.listen((HttpRequest event) async {
        // - CORS
        event.response.headers.add("Access-Control-Allow-Origin", "*");
        event.response.headers.add("Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS");
        // -
        if (this._handler.isEmpty) return;
        for (HandlerModel _hmodel in this._handler) {
          Function? c = _hmodel.cb;
          String? path = _hmodel.path;
          String? method = _hmodel.method;
          if (event.uri.path.toString() == path && event.method == method) {
            await c!(event, event.response);
            await event.response.close();
            return;
          }
        }
        return;
      });

  static Future<void> doRender({required HttpRequest req, required HttpResponse res, required String path, Map<String, String>? data}) async {
    final File _file = File(path);
    final String _readData = await _file.readAsString();
    String _result = _readData;
    if (data != null) {
      data.keys.toList().forEach((String key) {
        _result = _result.replaceAll("<do>$key</do>", data[key].toString());
        _result = _result.replaceAll("<do> $key </do>", data[key].toString());
      });
    }
    res.headers.contentType = ContentType.html;
    res.write(_result);
    return;
  }
}

class HandlerModel {
  final String? path;
  final String? method;
  final dynamic? data;
  final Function(HttpRequest req, HttpResponse res)? cb;
  const HandlerModel({required this.path, required this.method, required this.cb, this.data});
}
