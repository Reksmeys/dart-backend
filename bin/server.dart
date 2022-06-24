
import 'package:shelf/shelf_io.dart' as io;

import 'user.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
  
  // server ready for serve because it has hanler for request, hostname and port
  var server = await io.serve(Users().handler, _hostname, 9090);
  print('Serving at http://${server.address.host}:${server.port}');
}

    
