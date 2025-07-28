import js.html.Event;
import js.Browser;
import TodoCreator;

class Main {

	static function alertMessage(message: String) {
		Browser.alert(message);
	}

	static function handleForm(e: Event) {
		e.preventDefault();
		TodoCreator.logOnPage();
	}

	static function main() {
		//Form Control
		var formElement = Browser.document.getElementById('createForm');
		formElement.addEventListener('submit', handleForm);
	}
}
