enum TaskCategory { work, personal, wellbeing }

enum TaskPriority { low, medium, high }

enum TaskFilter { all, pending, completed }

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.notes = '',
    this.completed = false,
  });
  final String id;
  final String title;
  final String notes;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime dueDate;
  final bool completed;

  Task copyWith({
    String? title,
    String? notes,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? dueDate,
    bool? completed,
  }) => Task(
    id: id,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    category: category ?? this.category,
    priority: priority ?? this.priority,
    dueDate: dueDate ?? this.dueDate,
    completed: completed ?? this.completed,
  );

  bool isOverdue(DateTime now) =>
      !completed && dueDate.isBefore(DateTime(now.year, now.month, now.day));

  Map<String, Object> toJson() => {
    'id': id,
    'title': title,
    'notes': notes,
    'category': category.name,
    'priority': priority.name,
    'dueDate': dueDate.toIso8601String(),
    'completed': completed,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String;
    final id = json['id'] as String;
    if (title.trim().isEmpty || title.length > 100 || id.isEmpty) {
      throw const FormatException('Invalid task');
    }
    return Task(
      id: id,
      title: title,
      notes: json['notes'] as String,
      category: TaskCategory.values.byName(json['category'] as String),
      priority: TaskPriority.values.byName(json['priority'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      completed: json['completed'] as bool,
    );
  }
}

String? validateTitle(String? value) {
  if (value == null || value.trim().isEmpty) return 'required';
  if (value.trim().length > 100) return 'tooLong';
  return null;
}

List<Task> filterTasks(
  List<Task> tasks, {
  String query = '',
  TaskFilter filter = TaskFilter.all,
  TaskCategory? category,
}) {
  final needle = query.trim().toLowerCase();
  return tasks
      .where(
        (t) =>
            (filter == TaskFilter.all ||
                t.completed == (filter == TaskFilter.completed)) &&
            (category == null || t.category == category) &&
            ('${t.title} ${t.notes}'.toLowerCase().contains(needle)),
      )
      .toList()
    ..sort((a, b) {
      final status = (a.completed ? 1 : 0).compareTo(b.completed ? 1 : 0);
      return status != 0 ? status : a.dueDate.compareTo(b.dueDate);
    });
}

class TaskStats {
  TaskStats(List<Task> tasks)
    : total = tasks.length,
      completed = tasks.where((t) => t.completed).length;
  final int total;
  final int completed;
  int get pending => total - completed;
  double get progress => total == 0 ? 0 : completed / total;
}
