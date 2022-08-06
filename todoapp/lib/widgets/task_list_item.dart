import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/models/task_model.dart';

import '../main.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({required this.task, Key? key}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            // ignore: sort_child_properties_last
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                textInputAction: TextInputAction
                    .done, // klavye açılınca en sağ alttaki işareti done yap diyor
                minLines: 1,
                maxLines: null,
                controller: _taskNameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (yenideger) {
                  if (yenideger.length > 3) {
                    widget.task.name = yenideger;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a')
              .format(widget.task.createdAt), //intl kütüphanesi
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
