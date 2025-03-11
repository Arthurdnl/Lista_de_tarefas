import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';


class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.todo,required this.onDelete,});

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  onDelete(todo);
                  print("Excluir: ${todo.title}");
                },
                borderRadius: BorderRadius.circular(5),
                padding: EdgeInsets.zero,
                label: 'Deletar',
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200]
        ),

        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
              style: TextStyle(
              fontSize: 12,
            ),),
            Text(todo.title, style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),),
          ],
        ),
      )),
    );
  }
}
