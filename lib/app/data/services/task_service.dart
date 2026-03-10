// TODO Implement this library.
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser!.id;

  Future<List<TaskModel>> fetchTasks() async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => TaskModel.fromJson(e))
        .toList();
  }

Future<void> updateTaskTitle(String id, String newTitle) async {
  await _supabase
      .from('tasks')
      .update({'title': newTitle})
      .eq('id', id);
}

  Future<void> addTask(String title) async {
    await _supabase.from('tasks').insert({
      'title': title,
      'user_id': _userId,
      'is_completed': false,
    });
  }

  Future<void> deleteTask(String id) async {
    await _supabase
        .from('tasks')
        .delete()
        .eq('id', id);
  }

  Future<void> toggleTask(String id, bool current) async {
    await _supabase
        .from('tasks')
        .update({'is_completed': !current})
        .eq('id', id);
  }

}
