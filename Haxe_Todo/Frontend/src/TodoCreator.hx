import js.html.HtmlElement;
import js.html.XMLHttpRequest;
import haxe.Json;
import js.html.InputElement;
import haxe.extern.EitherType;
import js.html.ParagraphElement;
import js.Browser;
import StringTools;
import haxe.Http;


typedef NewTodoType = {
    var name: String;
    var status: String;
}

typedef TodoType = {
  var name: String;
  var status: String;
  var id: Int;
}


class TodoCreator {

    private static final mainElement = Browser.document.getElementById('testSec');
    private static final inputElement: InputElement = cast Browser.document.getElementById('todoInput');
    private static final baseURL = 'http://localhost:3000/';
    private static final doneTodosElement = Browser.document.getElementById('doneTodosSection');
    private static final pendingTodosElement = Browser.document.getElementById('pendingTodosSection');


    private static function handleDelte(e: ParagraphElement) {
        deleteTodoServer(e.parentElement.id);
        e.parentElement.classList.add("removeTodo");

        haxe.Timer.delay(() -> {
            e.parentElement.classList.remove("removeTodo");
            e.parentElement.remove();
        }, 500);
    }

    private static function handleAction(e: ParagraphElement) {
        var parent = e.parentElement;
        var todoId = parent.id;

        parent.classList.add("removeTodo");

        haxe.Timer.delay(() -> {
            parent.classList.remove("removeTodo");
            parent.remove();

            if(e.textContent == 'Finish'){
                e.textContent = 'Restart';
                parent.classList.remove('Pending');
                parent.classList.add('Completed');
                updateTodoServer('Completed', todoId);
                doneTodosElement.appendChild(parent);
            }else{
                e.textContent = 'Finish';
                parent.classList.remove('Completed');
                parent.classList.add('Pending');
                updateTodoServer('Pending', todoId);
                pendingTodosElement.appendChild(parent);
            }
        }, 500);
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
    
    public static function createTodo() {
        var currentText = getText();
        
        if(currentText == ''){
            Browser.alert('You have to type something!');
            return;
        }else{
            var newTodo: NewTodoType = {name: currentText, status: 'Pending'};
            createTodoServer(newTodo);
        }
    }   

    private static function createOnPage(todo: TodoType): Void {

        if(Browser.document.getElementById(Std.string(todo.id)) != null){
            return;
        }

        //Todo El
        var element = Browser.document.createDivElement();
        element.id = '${todo.id}';
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
        
        //Updating Dynamic values based on Todo
        todoText.textContent = todo.name;
        element.classList.add(todo.status);
        actionBtn.textContent = switch (todo.status){
            case 'Pending': 'Finish';
            case 'Completed': 'Restart';
            case _: "Finish";
        };

        //Addding event listeneres
        deleteBtn.addEventListener('click', ()-> handleDelte(deleteBtn));
        actionBtn.addEventListener('click', ()->handleAction(actionBtn));

        //Append Elements to the DOM

        trace(todo.status);
        if(todo.status == 'Pending'){
            pendingTodosElement.appendChild(element);
        }else{
            doneTodosElement.appendChild(element);
        }

        element.appendChild(todoText);
        element.appendChild(actionBtn);
        element.appendChild(deleteBtn);

    }


    public static function loadAllTodos() {
        //Load data
		var http = new Http('http://localhost:3000/todos');

		http.onData = function(data: String) {
			var todosData = haxe.Json.parse(data).data;
			var loadedTodos: Array<TodoType> = todosData.map(todoEl ->  {"name": todoEl.name, "status": todoEl.status, 'id': todoEl.id});
			
			for(todo in loadedTodos){
				createOnPage(todo);
			}
		}

		http.onError = function(error:String) {
			trace("Error: " + error);
		}

		http.request();


    }

    private static function createTodoServer(todo: NewTodoType) {
        var http = new Http(baseURL + 'todos');

        http.setHeader("Content-Type", "application/json");

        var data = {
            name: todo.name,
            status: todo.status,
        };

        http.setPostData(Json.stringify(data));

        http.onData = function(response: String) {
            trace("Response: " + response);
            loadAllTodos();
        }

        http.onError = function(error:String) {
            trace("Error: " + error);
        }

        http.request(true); // POST
    }

    private static function updateTodoServer(status: String, id:String) {
        var url = '${baseURL}todos/id=${id}'; // Change as needed
        var http = new Http(url);

        http.setHeader("Content-Type", "application/json");

        var data = {
            status: status,
        };

        http.setPostData(Json.stringify(data));

        http.onData = function(response: String) {
            trace("Response: " + response);
            // loadAllTodos();
        }

        http.onError = function(error:String) {
            trace("Error: " + error);
        }

        http.request(true); // POST
    }

    private static function deleteTodoServer(id: String) {
        var xhr = new XMLHttpRequest();
        xhr.open("DELETE", '${baseURL}todos/id=${id}', true); // Change URL as needed

        xhr.onload = function(_) {
            if (xhr.status == 200) {
                trace("Item deleted: " + xhr.responseText);
            } else {
                trace("Failed to delete: " + xhr.status);
            }
        }

        xhr.onerror = function(_) {
            trace("Request failed");
        }

        xhr.send(); // DELETE usually has no body
    }
}