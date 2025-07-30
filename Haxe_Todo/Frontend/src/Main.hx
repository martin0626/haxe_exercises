import js.html.Event;
import js.Browser;
import TodoCreator;
import haxe.Http;

enum TodoStatus {
  Completed;
  Pending;
}

typedef TodoType = {
  var name: String;
  var status: String;
}


class Main {

	static var todos: Array<TodoType>;

	static function alertMessage(message: String) {
		Browser.alert(message);
	}

	static function handleForm(e: Event) {
		e.preventDefault();
		TodoCreator.createOnPage();
	}

	static function main() {
		//Load data
		var http = new Http('http://localhost:3000/todos');

		http.onData = function(data: String) {
			var todosData = haxe.Json.parse(data).data;
			todos = todosData.map(todoEl ->  {"name": todoEl.name, "status": todoEl.status});
			TodoCreator.loadAll(todos);
		}

		http.onError = function(error:String) {
			trace("Error: " + error);
		}

		http.request();

		//Form Control
		var formElement = Browser.document.getElementById('createForm');
		formElement.addEventListener('submit', handleForm);
	}
}
