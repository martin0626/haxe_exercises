import haxe.display.Protocol.Response;
import js.node.Http;

enum TodoStatus {
  Completed;
  Pending;
}

typedef Todos = {
  var name: String;
  var status: TodoStatus;
}

class Main {

  static var todos: Array<Todos> = [];
  
  static function getAllTodos(res: Dynamic) {

    todos.push({name: "Marto", status: Completed});

    var response = {
        data: todos,
        status: "success"
    };

    res.writeHead(200, {
      "Content-Type": "application/json"
    });

    res.end(haxe.Json.stringify(response));
  }


  static function main() {
    
    // Create HTTP server
    var server = Http.createServer(function(req, res) {
      var url = req.url; 
      trace(url);
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
      res.setHeader("Access-Control-Allow-Headers", "Content-Type");

      // Route: /data
      switch (url){
        case "/todos":
          getAllTodos(res);
        case _:
          res.writeHead(404, {
            "Content-Type": "text/plain"
          });
          res.end("Not Found");
      }
    });

    server.listen(3000, function() {
      trace("Server running at http://localhost:3000/");
    });
  }
}