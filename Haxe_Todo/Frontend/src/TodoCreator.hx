import js.html.InputElement;
import haxe.extern.EitherType;
import js.html.ParagraphElement;
import js.Browser;
import StringTools;

class TodoCreator {

    private static var mainElement = Browser.document.getElementById('todos');
    private static var inputElement: InputElement = cast Browser.document.getElementById('todoInput');

    private static function handleDelte(e: ParagraphElement) {
        e.parentElement.remove();
    }

    private static function handleAction(e: ParagraphElement) {
        var parent = e.parentElement; 

        if(e.textContent == 'Finish'){
            e.textContent = 'Restart';
            parent.classList.remove('pendingTodo');
            parent.classList.add('finishedTodo');
        }else{
            e.textContent = 'Finish';
            parent.classList.remove('finishedTodo');
            parent.classList.add('pendingTodo');
        }
        
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
        //Todo El
        var element = Browser.document.createDivElement();
        element.classList.add('todoEl');
        element.classList.add('pendingTodo');

        //Paragraph
        var todoText = Browser.document.createParagraphElement();
        todoText.classList.add('todoText');

        //Delete BTN
        var deleteBtn = Browser.document.createParagraphElement();
        deleteBtn.textContent = 'Remove';
        deleteBtn.classList.add('todoBtn');

        //Action BTN
        var actionBtn = Browser.document.createParagraphElement();
        actionBtn.textContent = 'Finish';
        actionBtn.classList.add('todoBtn');
        

        var text = getText();

        if(text){
            todoText.textContent = text;

            //Addding event listeneres
            deleteBtn.addEventListener('click', ()-> handleDelte(deleteBtn));
            actionBtn.addEventListener('click', ()->handleAction(actionBtn));

            //Append Elements to the DOM
            mainElement.appendChild(element);
            element.appendChild(todoText);
            element.appendChild(actionBtn);
            element.appendChild(deleteBtn);
        }else{
            Browser.alert('You have to type something!');
        }
    }
}