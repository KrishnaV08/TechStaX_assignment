import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_task_it/app/data/models/task_model.dart';
import 'package:just_task_it/app/data/services/add_task_sheet.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/task_tile.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Obx(() {
              return FloatingActionButton(
                onPressed: controller.toggleTheme,
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                shape: const CircleBorder(),
                elevation: 4,
                child: Icon(
                  controller.isDarkMode.value == false
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: Theme.of(context).cardColor,
                  size: 32,
                ),
              );
            }),
          ),
          FloatingActionButton(
            onPressed:
                () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddTaskSheet(onAdd: controller.addTask),
                ),
            backgroundColor: const Color(0xFFFF8C00),
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF8C00)),
          );
        }
        return RefreshIndicator(
          color: const Color(0xFFFF8C00),
          onRefresh: () async => controller.fetchTasks(),
          child: CustomScrollView(
            slivers: [
              _Header(),
              _ProgressCard(),
              if (controller.pendingTasks.isNotEmpty) ...[
                _SectionLabel(
                  label: 'Pending',
                  count: controller.pendingTasks.length,
                ),
                _TaskList(
                  tasks: controller.pendingTasks,
                  controller: controller,
                ),
              ],
              if (controller.completedTasks.isNotEmpty) ...[
                _SectionLabel(
                  label: 'Completed',
                  count: controller.completedTasks.length,
                ),
                _TaskList(
                  tasks: controller.completedTasks,
                  controller: controller,
                ),
              ],
              if (controller.allTasks.isEmpty)
                const SliverFillRemaining(child: _EmptyState()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
    );
  }
}

class _Header extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF8C00),
              Color.fromARGB(255, 252, 186, 88),

              Theme.of(context).cardColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.greeting,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                Text(
                  controller.userName,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _confirmSignOut(context),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      92,
                      92,
                      92,
                    ).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.9),
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Sign Out',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: controller.signOut,
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }
}

class _ProgressCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.allTasks.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Progress',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).appBarTheme.iconTheme!.color,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  Text(
                    '${(controller.progress * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: const Color(0xFFFF8C00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: controller.progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF8C00),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.progressText,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;
  const _SectionLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C00).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF8C00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final DashboardController controller;
  const _TaskList({required this.tasks, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => TaskTile(
          task: tasks[i],
          onDelete: () => controller.deleteTask(tasks[i].id),
          onToggle:
              () => controller.toggleTask(tasks[i].id, tasks[i].isCompleted),
          onEdit: () => controller.showEditSheet(tasks[i]), // ← add this
        ),

        childCount: tasks.length,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checklist_rounded,
              size: 48,
              color: Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No tasks yet!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first task.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
