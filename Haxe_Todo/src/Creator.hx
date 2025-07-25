import js.html.InputElement;
import haxe.io.Input;
import haxe.extern.EitherType;
import js.html.ParagraphElement;
import js.html.HtmlElement;
import js.html.Event;
import js.Browser;
import StringTools;

class Creator {

    private static var mainElement = Browser.document.getElementById('todos');
    private static var inputElement: InputElement = cast Browser.document.getElementById('todoInput');

    private static function handleDelte(e: ParagraphElement) {
        e.remove();
    }

    private static function getText(): EitherType<String, Bool> {
        var text: String = inputElement.value;

        if(StringTools.trim(text) != ''){
            inputElement.value = '';
            return text;
        }else{
            return false;
        }
    }

    public static function logOnPage(): Void {
        var element = Browser.document.createParagraphElement();
        var text = getText();

        if(text){
            element.textContent = text;
            element.classList.add('todoEl');
            element.addEventListener('click', ()-> handleDelte(element));
            mainElement.appendChild(element);
        }else{
            Browser.alert('You have to type something!');
        }
    }
}