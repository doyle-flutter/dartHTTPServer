import 'dart:io';

class JamesServer {
  int? _port;
  HttpServer? server;
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
  Set<HandlerModel> _handler = new Set();
  Future<void> get(String path, Function(HttpRequest req, HttpResponse res) cb) async => this._handler.add(new HandlerModel(path: path, method: "GET", cb: cb));
  Future<void> post(String path, Function(HttpRequest req, HttpResponse res) cb, {dynamic? data = null}) async => this._handler.add(new HandlerModel(path: path, method: "POST", cb: cb, data: data));
  Future<void> _handlerSetting() async => await this.server!.listen((HttpRequest event) async {
        if (this._handler.isEmpty) return;
        for (HandlerModel _hmodel in this._handler) {
          Function? c = _hmodel.cb;
          String? path = _hmodel.path;
          String? method = _hmodel.method;
          if (event.uri.toString() == path && event.method == method) {
            c!(event, event.response);
            await event.response.close();
            return;
          }
        }
        return;
      });
}

class HandlerModel {
  final String? path;
  final String? method;
  final dynamic? data;
  final Function(HttpRequest req, HttpResponse res)? cb;
  const HandlerModel({required this.path, required this.method, required this.cb, this.data});
}
