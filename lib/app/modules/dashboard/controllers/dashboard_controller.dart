import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_task_it/app/modules/dashboard/widgets/edit_task_sheet.dart';
import 'package:just_task_it/app/modules/theme/theme_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_task_it/app/data/models/task_model.dart';
import 'package:just_task_it/app/data/services/task_service.dart';
import 'package:just_task_it/app/routes/app_pages.dart';

class DashboardController extends GetxController {
  final _taskService = TaskService();

  final allTasks = <TaskModel>[].obs;
  final isLoading = false.obs;

  List<TaskModel> get pendingTasks =>
      allTasks.where((t) => !t.isCompleted).toList();
  List<TaskModel> get completedTasks =>
      allTasks.where((t) => t.isCompleted).toList();

  double get progress =>
      allTasks.isEmpty ? 0 : completedTasks.length / allTasks.length;

  String get progressText =>
      allTasks.isEmpty
          ? 'No tasks yet'
          : '${completedTasks.length} of ${allTasks.length} completed';

  @override
  void onInit() {
    super.onInit();
    Get.put(ThemeController());
    fetchTasks();
  }
void editTask(String id, String newTitle) async {
  if (newTitle.trim().isEmpty) return;

  final index = allTasks.indexWhere((t) => t.id == id);
  if (index == -1) return;

  final oldTitle = allTasks[index].title;
  allTasks[index] = allTasks[index].copyWith(title: newTitle.trim()); // optimistic
  allTasks.refresh();

  try {
    await _taskService.updateTaskTitle(id, newTitle.trim());
  } catch (e) {
    allTasks[index] = allTasks[index].copyWith(title: oldTitle); // revert
    allTasks.refresh();
    Get.snackbar('Error', 'Could not update task.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  }
}

void showEditSheet(TaskModel task) {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditTaskSheet(
      task: task,
      onEdit: (newTitle) => editTask(task.id, newTitle),
    ),
  );
}


  void fetchTasks() async {
    isLoading.value = true;
    try {
      allTasks.value = await _taskService.fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Could not load tasks.');
    } finally {
      isLoading.value = false;
    }
  }

  void addTask(String title) async {
    if (title.trim().isEmpty) return;

    // Create a temporary task instantly
    final tempTask = TaskModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      userId: Supabase.instance.client.auth.currentUser!.id,
      title: title.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    allTasks.insert(0, tempTask); // add to top of list immediately

    try {
      await _taskService.addTask(title.trim());
      await _refreshSilently(); // sync with DB quietly in background
    } catch (e) {
      allTasks.remove(tempTask); // revert if it failed
      Get.snackbar(
        'Error',
        'Could not add task. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // fetches from DB without showing the full screen loader
  Future<void> _refreshSilently() async {
    try {
      allTasks.value = await _taskService.fetchTasks();
    } catch (_) {}
  }

  void deleteTask(String id) async {
    try {
      allTasks.removeWhere((t) => t.id == id);
      await _taskService.deleteTask(id);
    } catch (e) {
      fetchTasks();
      Get.snackbar('Error', 'Could not delete task.');
    }
  }

  void toggleTheme() {
    Get.find<ThemeController>().toggleTheme();
    isDarkMode.value = Get.find<ThemeController>().isDarkMode;
  }

  RxBool isDarkMode = Get.find<ThemeController>().isDarkMode.obs;

  void toggleTask(String id, bool current) async {
    try {
      final index = allTasks.indexWhere((t) => t.id == id);
      allTasks[index] = allTasks[index].copyWith(isCompleted: !current);
      allTasks.refresh();
      await _taskService.toggleTask(id, current);
    } catch (e) {
      fetchTasks();
      Get.snackbar('Error', 'Could not update task.');
    }
  }

  void signOut() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed(Routes.GET_STARTED);
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get userName =>
      Supabase.instance.client.auth.currentUser?.userMetadata?['name'] ??
      'there';
}
