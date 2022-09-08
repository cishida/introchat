import 'package:http/io_client.dart';
import 'package:http/http.dart';

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  // static final GoogleHttpClient _instance = GoogleHttpClient._internal();
  // GoogleHttpClient._internal();

  // factory GoogleHttpClient({Map<String, String> headers}) {
  //   _instance._headers = headers;
  //   return _instance;
  // }

  // // GoogleHttpClient._privateConstructor(this._headers) : super();

  // // static final GoogleHttpClient _instance =
  // //     GoogleHttpClient._privateConstructor();

  // // static GoogleHttpClient get instance => _instance;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
