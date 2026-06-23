import '../../core/logger/app_logger.dart';

class ApplicationInitTask {
  final int priority;
  final Future<void> Function() task;

  ApplicationInitTask({required this.priority, required this.task});
}

class ApplicationInitializer {
  static final ApplicationInitializer instance = ApplicationInitializer._();
  ApplicationInitializer._();

  final List<ApplicationInitTask> _tasks = [];
  bool _ran = false;

  void register(int priority, Future<void> Function() task) {
    _tasks.add(ApplicationInitTask(priority: priority, task: task));
  }

  Future<void> initialize({bool force = false}) async {
    if (_ran && !force) return;
    _ran = true;

    _tasks.sort((a, b) => a.priority.compareTo(b.priority));

    for (final t in _tasks) {
      try {
        await t.task();
      } catch (e, s) {
        AppLogger.error(
          "ApplicationInitializer error (priority=${t.priority}): $e\n$s",
        );
      }
    }
  }

  void reset() {
    _ran = false;
    _tasks.clear();
  }
}
