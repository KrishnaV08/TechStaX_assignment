import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_task_it/app/data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit; // ← add this

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit, // ← add this
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.redAccent.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.redAccent),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color:
              task.isCompleted
                  ? Theme.of(context).canvasColor.withOpacity(0.6)
                  : Theme.of(context).canvasColor,

          borderRadius: BorderRadius.circular(16),

          boxShadow:
              task.isCompleted
                  ? []
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          onLongPress: onEdit, // ← long press to edit

          leading: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    task.isCompleted
                        ? const Color(0xFFFF8C00)
                        : Colors.transparent,
                border: Border.all(
                  color:
                      task.isCompleted
                          ? const Color(0xFFFF8C00)
                          : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child:
                  task.isCompleted
                      ? const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Colors.white,
                      )
                      : null,
            ),
          ),
          trailing: GestureDetector(
            onTap: onEdit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                color:
                    task.isCompleted
                        ? const Color(0xFFFF8C00)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color:
                      task.isCompleted
                          ? const Color(0xFFFF8C00)
                          : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          title: Text(
            task.title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: task.isCompleted ? FontWeight.w400 : FontWeight.w500,
              color:
                  task.isCompleted
                      ? Colors.grey.shade400
                      : Theme.of(context).colorScheme.onSurface,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
