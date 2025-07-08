import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(SmartTasksApp());

class SmartTasksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTH SmartTasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: HomeScreen(),
    );
  }
}

// ----------------------------- MODELS -----------------------------
class Subtask {
  final int id;
  final String title;
  final bool isCompleted;

  Subtask({required this.id, required this.title, required this.isCompleted});

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }
}

class Attachment {
  final int id;
  final String fileName;
  final String fileUrl;

  Attachment({required this.id, required this.fileName, required this.fileUrl});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }
}

class Reminder {
  final int id;
  final String time;
  final String type;

  Reminder({required this.id, required this.time, required this.type});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      time: json['time'],
      type: json['type'],
    );
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String category;
  final String dueDate;
  final String createdAt;
  final String updatedAt;
  final List<Subtask> subtasks;
  final List<Attachment> attachments;
  final List<Reminder> reminders;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.subtasks,
    required this.attachments,
    required this.reminders,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      category: json['category'],
      dueDate: json['dueDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      subtasks: (json['subtasks'] as List)
          .map((item) => Subtask.fromJson(item))
          .toList(),
      attachments: (json['attachments'] as List)
          .map((item) => Attachment.fromJson(item))
          .toList(),
      reminders: (json['reminders'] as List)
          .map((item) => Reminder.fromJson(item))
          .toList(),
    );
  }
}

// ----------------------------- HOME SCREEN -----------------------------
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('https://amock.io/api/researchUTH/tasks'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      if (jsonBody['isSuccess'] == true) {
        final List<dynamic> data = jsonBody['data'];
        isLoading = false;
        setState(() {
          tasks = data.map((json) => Task.fromJson(json)).toList();
        });
      } else {
        throw Exception('API returned unsuccessful status');
      }
    } else {
      throw Exception('Failed to load tasks from server');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('https://amock.io/api/researchUTH/task/$id'));

    if (response.statusCode == 200) {
      setState(() {
        tasks.removeWhere((task) => task.id == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task')),
      );
    }
  }

  void openTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow[100]!;
      case 'in progress':
        return Colors.red[100]!;
      case 'completed':
        return Colors.green[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Icon getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icon(Icons.check_box, color: Colors.black);
      case 'in progress':
        return Icon(Icons.check_box_outline_blank, color: Colors.black);
      default:
        return Icon(Icons.crop_square, color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartTasks'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bedtime, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Tasks Yet!\nStay productive—add something to do',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            color: getStatusColor(task.status),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => openTaskDetail(task),
              leading: getStatusIcon(task.status),
              title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(task.description),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Status: ${task.status}"),
                  Text(task.dueDate, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

// ----------------------------- DETAIL SCREEN -----------------------------
class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  Widget buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: BackButton(),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Colors.red))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(task.description),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildChip("Category: ${task.category}", Colors.purple),
                buildChip("Status: ${task.status}", Colors.orange),
                buildChip("Priority: ${task.priority}", Colors.red),
              ],
            ),
            SizedBox(height: 20),
            Text("Subtasks", style: TextStyle(fontWeight: FontWeight.bold)),
            ...task.subtasks.map((sub) => CheckboxListTile(
              value: sub.isCompleted,
              onChanged: null,
              title: Text(sub.title),
            )),
            SizedBox(height: 16),
            Text("Attachments", style: TextStyle(fontWeight: FontWeight.bold)),
            ...task.attachments.map((att) => ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text(att.fileName),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('File: ${att.fileUrl}')),
                );
              },
            )),
            SizedBox(height: 16),
            Text("Reminders", style: TextStyle(fontWeight: FontWeight.bold)),
            ...task.reminders.map((rem) => ListTile(
              leading: Icon(Icons.alarm),
              title: Text(rem.type),
              subtitle: Text(rem.time),
            )),
          ],
        ),
      ),
    );
  }
}
