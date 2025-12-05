import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/stats_viewmodel.dart'; // <-- New Import

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

  void _showTaskDialog(BuildContext context, {int? index, Task? existingTask}) {
    if (existingTask != null) {
      _nameController.text = existingTask.name;
      _descController.text = existingTask.description;
      _timeController.text = existingTask.minutes.toString();
    } else {
      _nameController.clear();
      _descController.clear();
      _timeController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? "New Task" : "Edit Task"),
        content: SingleChildScrollView(
          child: Column(
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _timeController.text.isNotEmpty) {
                final name = _nameController.text;
                final desc = _descController.text;
                final mins = int.tryParse(_timeController.text) ?? 20;

                if (index != null) {
                  context.read<TaskViewModel>().updateTask(index, name, desc, mins);
                } else {
                  context.read<TaskViewModel>().addTask(name, desc, mins);
                }
                
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? "Add" : "Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final statsViewModel = context.read<StatsViewModel>(); // <-- Get Stats ViewModel
    final tasks = taskViewModel.tasks;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xffFFF9D6), 
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
              onPressed: () => _showTaskDialog(context),
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
                final task = tasks[i]; // Get the task at the current index
                return Dismissible(
                  key: Key(task.name + i.toString()),
                  // Allow swiping both left (delete) and right (complete)
                  direction: DismissDirection.horizontal, 
                  
                  // Background for SWIPE LEFT (End to Start - DELETE)
                  background: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff6BCB77), // Green for completion
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.check_circle, color: Colors.white, size: 28),
                  ),

                  // Secondary Background for SWIPE RIGHT (Start to End - COMPLETE)
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFF6B6B), // Red for deletion
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),

                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Confirmation for completion (optional, but good practice)
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Task Completed'),
                            content: Text('Mark "${task.name}" as completed and log ${task.minutes} minutes of work?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text(
                                  'Complete',
                                  style: TextStyle(color: Color(0xff6BCB77)),
                                ),
                              ),
                            ],
                          );
                        },
                      ) ?? false;
                    }
                    // Use existing confirmation for deletion (swipe left)
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Task'),
                          content: Text('Are you sure you want to delete "${task.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Color(0xffFF6B6B)),
                              ),
                            ),
                          ],
                        );
                      },
                    ) ?? false;
                  },
                  
                  // Main logic after confirmation
                  onDismissed: (direction) {
                    final dismissedTask = tasks[i];
                    
                    if (direction == DismissDirection.startToEnd) {
                      // --- TASK COMPLETED (Swipe Right) ---
                      
                      // 1. Record the time to the Stats ViewModel
                      statsViewModel.recordSession(dismissedTask.minutes);

                      // 2. Remove the task from the Task ViewModel
                      taskViewModel.removeTask(i);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ ${dismissedTask.name} completed! ${dismissedTask.minutes} mins logged.'),
                          backgroundColor: const Color(0xff6BCB77),
                          duration: const Duration(seconds: 3),
                        ),
                      );

                    } else if (direction == DismissDirection.endToStart) {
                      // --- TASK DELETED (Swipe Left) ---

                      // 1. Remove the task from the Task ViewModel
                      taskViewModel.removeTask(i);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${dismissedTask.name} deleted'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // In a real app, you'd implement undo here
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              if (task.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  task.description,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xffE0F7FA),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "${task.minutes} min",
                                  style: const TextStyle(color: Color(0xff006064), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () => _showTaskDialog(context, index: i, existingTask: task),
                              tooltip: 'Edit',
                            ),
                          ],
                        ),
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