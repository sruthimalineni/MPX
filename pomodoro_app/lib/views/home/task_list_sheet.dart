import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_viewmodel.dart';

class TaskListSheet extends StatefulWidget {
  const TaskListSheet({super.key});

  @override
  State<TaskListSheet> createState() => _TaskListSheetState();
}

class _TaskListSheetState extends State<TaskListSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Task Name"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: "Duration (minutes)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _timeController.text.isNotEmpty) {
                context.read<TaskViewModel>().addTask(
                      _nameController.text,
                      _descController.text,
                      int.tryParse(_timeController.text) ?? 20,
                    );
                _nameController.clear();
                _descController.clear();
                _timeController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final tasks = taskViewModel.tasks;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xffFFF9D6), // Cream background
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Tasks",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddTaskDialog(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add New Task", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFF6B6B),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: tasks.isEmpty 
            ? const Center(child: Text("No tasks yet. Add one!", style: TextStyle(color: Colors.grey)))
            : ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    taskViewModel.removeTask(i);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task removed')),
                    );
                  },
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tasks[i].name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xffE0F7FA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${tasks[i].minutes} min",
                                style: const TextStyle(color: Color(0xff006064), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        if (tasks[i].description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            tasks[i].description,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffFF6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffFF6B6B).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Total Time", style: TextStyle(color: Colors.black54)),
                    Text(taskViewModel.totalWorkTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(width: 1, height: 40, color: Colors.black12),
                Column(
                  children: [
                    const Text("Total Break", style: TextStyle(color: Colors.black54)),
                    Text(taskViewModel.totalBreakTime, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}