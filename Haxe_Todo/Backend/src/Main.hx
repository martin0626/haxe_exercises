import js.html.svg.Number;
import haxe.Json;
import js.node.http.ServerResponse;
import js.node.http.IncomingMessage;
import haxe.display.Protocol.Response;
import js.node.Http;

enum TodoStatus {
  Completed;
  Pending;
}

typedef TodoType = {
  var id: Int;
  var name: String;
  var status: String;
}

class Main {

  static var todos: Array<TodoType> = [];
  static var count = 0;
  

  static function getAllTodos(res: Dynamic) {

    // todos.push({name: "Marto", status: "Completed"});
    var response = {
        data: todos,
        status: "success"
    };

    res.writeHead(200, {
      "Content-Type": "application/json"
    });

    res.end(haxe.Json.stringify(response));
  }


  static function createTodo(req:IncomingMessage, res:ServerResponse):Void {
    // var data: TodoType = "";
    var data: TodoType;
    req.on("data", function(chunk) {
      data = Json.parse(chunk);
      
      data.id = count;
      count++;
      todos.push(data);
      
      //TODO Add validation for the data from FE
      // if(data.name && data.status){
        
      // }
    });
    
    req.on("end", function() {
      res.writeHead(201, {"Content-Type": "application/json"});
      res.end('{"success": true}');
    });
  }


  static function updateTodo(req:IncomingMessage, res:ServerResponse, id: Int) {
    var data: {status: String};

    req.on("data", function(chunk) {
      data = Json.parse(chunk);
      
      todos = todos.map(todo -> {
        if(todo.id == id){
          todo.status = data.status;
        }
        return todo;
      });
    });
    
    req.on("end", function() {
      res.writeHead(201, {"Content-Type": "application/json"});
      res.end('{"success": true}');
    });
  }

  static function deleteTodo(res:ServerResponse, id: Int) {
      todos = todos.filter(t -> t.id != id);
      res.writeHead(200, {"Content-Type": "application/json"});
      res.end('{"success": true}');
  }

  static function main() {
    
    // Create HTTP server
    var server = Http.createServer(function(req, res) {
      var url = req.url; 
      var method = req.method;
      trace(url);
      res.setHeader("Access-Control-Allow-Origin", "*");
      res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
      res.setHeader("Access-Control-Allow-Headers", "Content-Type");

      if (method == "OPTIONS") {
          res.writeHead(200);
          res.end();
          return;
      }

      trace(method);
      // Route: /data
      switch (url){
        case "/todos" if (method == 'GET'):
          getAllTodos(res);

        case "/todos" if (method == "POST"):
          createTodo(req, res);

        case urlStr if(Std.parseInt(urlStr.split('id=')[1]) != null && method=='DELETE'):
          var currentId = Std.parseInt(urlStr.split('id=')[1]);
          deleteTodo(res, currentId);

        case urlStr if(Std.parseInt(urlStr.split('id=')[1]) != null):
          trace(method);
          var currentId = Std.parseInt(urlStr.split('id=')[1]);
          updateTodo(req, res, currentId);

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