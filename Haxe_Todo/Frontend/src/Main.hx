import js.html.Event;
import js.Browser;
import TodoCreator;
import haxe.Http;

class Main {

	static function alertMessage(message: String) {
		Browser.alert(message);
	}

	static function handleForm(e: Event) {
		e.preventDefault();
		TodoCreator.logOnPage();
	}

	static function main() {
		//Load data
		var http = new Http('http://localhost:3000/todos');

		http.onData = function(data:String) {
			trace("Response: " + data);
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
