import js.Node;
import js.node.Http;

class Main {
  static function main() {
    var server = Http.createServer(function(req, res) {
      res.writeHead(200, {
        'Content-Type': 'text/plain'
      });
      res.end("Hello from Haxe and Node.js!\n");
    });

    server.listen(3000, function() {
      trace("Server running at http://localhost:3000/");
    });
  }
}