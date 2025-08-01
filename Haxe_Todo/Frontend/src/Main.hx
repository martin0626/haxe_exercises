import js.html.Event;
import js.Browser;

class Main {

	static function alertMessage(message: String) {
		Browser.alert(message);
	}

	static function handleForm(e: Event) {
		e.preventDefault();
		TodoCreator.createTodo();
	}

	static function main() {
		//Load existing todos
		TodoCreator.loadAllTodos();
		//Form Control
		var formElement = Browser.document.getElementById('createForm');
		formElement.addEventListener('submit', handleForm);
	}
}
