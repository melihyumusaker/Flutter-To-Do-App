import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/widgets/custom_search_delegate.dart';
import 'package:todoapp/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          // inkwell tarzı bişey
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: const Text(
            'Bugün Neler Yapacaksın',
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var _oAnkiListeElemani = _allTasks[index];
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
                  onDismissed: (direction) {
                    // taskı sola kaydırıp kaldırma yeri
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: _oAnkiListeElemani);
                    setState(() {});
                  },
                  child: ListTile(
                    title: TaskItem(task: _oAnkiListeElemani),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Hadi bir görev ekle'),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    // sayfa içerisinde diğer tarafları karartıp küçük bi yer açar
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: // klavye açıldıktan sonra textformun hemen klavyenin üst tarafına çıkmasını sağlar
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Görev Nedir',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                // submit edildiğinde yazılan şey valueye atanır.
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev = Task.create(
                          name: value,
                          createdAt:
                              time); // value textformfielde girilen değer time ise seçilen tarih
                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {}); // ekrana yansısın diye setstate var
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTaskFromDb();
  }
}
