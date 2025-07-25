import js.html.HtmlElement;
import js.html.Event;
import js.Browser;
import Test;
import Dog;
import Creator;

class Main {

	static function alertMessage(message: String) {
		Browser.alert(message);
	}

	static function handleForm(e: Event) {
		e.preventDefault();
		Creator.logOnPage();
	}

	static function main() {
		// trace("Hello, world!");

		var nums: Array<Int> = [1, 2, 3, 4,111111];
		var result = Lambda.fold(nums, (acc, e) -> acc + e, 0);
		trace(result);


		var newObj = new Test("Tosho");

		//Button
		var btn = Browser.document.createButtonElement();
		btn.textContent = 'New BTN';
		btn.addEventListener('click', () -> alertMessage(Std.string(result)));
		Browser.document.getElementById('mainSection').appendChild(btn);


		//Form Control
		var formElement = Browser.document.getElementById('createForm');
		formElement.addEventListener('submit', handleForm);

	}
}
