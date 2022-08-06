import 'package:flutter/material.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/widgets/task_list_item.dart';
import 'package:todoapp/main.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});
  @override
  List<Widget>? buildActions(BuildContext context) {
    // tıklandığında sağdaki çarpı işaretinin olayları
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // soldaki geri dönün olayları
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var _oAnkiListeElemani = filteredList[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Bu görev silindi')
                  ],
                ),
                key: Key(_oAnkiListeElemani.id),
                onDismissed: (direction) async {
                  // taskı sola kaydırıp kaldırma yeri
                  filteredList.removeAt(index);
                  await locator<LocalStorage>()
                      .deleteTask(task: _oAnkiListeElemani);
                },
                child: ListTile(
                  title: TaskItem(task: _oAnkiListeElemani),
                ),
              );
            },
          )
        : const Center(
            child: Text('Aradığını Bulamadık'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
