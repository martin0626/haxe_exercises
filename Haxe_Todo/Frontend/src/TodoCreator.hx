import Main.TodoType;
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
            parent.classList.remove('Pending');
            parent.classList.add('Completed');
        }else{
            e.textContent = 'Finish';
            parent.classList.remove('Completed');
            parent.classList.add('Pending');
        }
        
    }

    private static function getText(): EitherType<String, Bool> {
        var text: String = inputElement.value;

        if(StringTools.trim(text) != ''){
            inputElement.value = '';
            return text;
        }else{
            return '';
        }
    }

    public static function createOnPage(todo: TodoType = null): Void {
        //Todo El
        var element = Browser.document.createDivElement();
        element.classList.add('todoEl');

        //Paragraph
        var todoText = Browser.document.createParagraphElement();
        todoText.classList.add('todoText');

        //Delete BTN
        var deleteBtn = Browser.document.createParagraphElement();
        deleteBtn.textContent = 'Remove';
        deleteBtn.classList.add('todoBtn');

        //Action BTN
        var actionBtn = Browser.document.createParagraphElement();
        
        actionBtn.classList.add('todoBtn');
        
        var currentText = '';
        var currentStatus = 'Pending';
        

        if(todo != null){
            currentText = todo.name;
            currentStatus = todo.status;
        }else{
            currentText = getText();
            if(currentText == ''){
                Browser.alert('You have to type something!');
                return;
            }
        }

        trace(todo);
        //Updating Dynamic values based on Todo
        todoText.textContent = currentText;
        element.classList.add(currentStatus);
        actionBtn.textContent = switch (currentStatus){
            case 'Pending': 'Finish';
            case 'Completed': 'Restart';
            case _: "Finish";
        };

        //Addding event listeneres
        deleteBtn.addEventListener('click', ()-> handleDelte(deleteBtn));
        actionBtn.addEventListener('click', ()->handleAction(actionBtn));


        //Append Elements to the DOM
        mainElement.appendChild(element);
        element.appendChild(todoText);
        element.appendChild(actionBtn);
        element.appendChild(deleteBtn);
    }


    public static function loadAll(todos: Array<TodoType>) {
        for (todo in todos){
            createOnPage(todo);
        }
    }

    private static function updateTodoServer() {
        //TODO Finish method
    }

    private static function deleteTodoServer() {
        //TODO Finish method
    }

    private static function createTodoServer() {
        //TODO Finish method
    }
}