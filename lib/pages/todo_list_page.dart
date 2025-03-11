import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

import '../repositories/todo_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});



  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });

  }

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Ler livro',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 3,
                            ),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){
                      String text = todoController.text;
                      if(text.isEmpty){
                        setState(() {
                          errorText='A tarefa está vazia!';
                        });

                        return;
                      }

                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(newTodo);
                        errorText = null;
                      });
                      todoController.clear();
                      todoRepository.saveTodoList(todos);
      
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17,),
      
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
      
                SizedBox(height: 17,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Você tem ${todos.length} tarefas pendentes!'
                      ),
                    ),
                    SizedBox(width: 7),
                    ElevatedButton(onPressed: (){
                      showDeleteTodoConfirmationDialog();
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.all(13),
                        shape: RoundedRectangleBorder(),
                      ),
                      child:Text('Limpar tudo',
                        style: TextStyle(color: Colors.white),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo){

    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarefa ${todo.title} foi removida com sucesso!',
          style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
          action: SnackBarAction(label: 'Desfazer',
              textColor: const Color(0xff682da3),
              onPressed: (){
                setState(() {
                  todos.insert(deletedTodoPos!, deletedTodo!);
                });
                todoRepository.saveTodoList(todos);
              }),
          duration: const Duration(seconds: 3),
        ),

    );
  }

  void showDeleteTodoConfirmationDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Limpar tudo'),
          content: Text('Tem certeza que quer apagar todas as tarefas?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            },
                child: Text('Cancelar')),

            TextButton(onPressed: (){
              setState(() {
                todos.clear();
              });
              todoRepository.saveTodoList(todos);
              Navigator.of(context).pop();

            },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Confirmar')),
          ],
        ),
    );
  }



}

