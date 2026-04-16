import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import 'task_view_model.dart';
import 'task_model.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<TaskViewModel>().loadTasks();
    });
  }

  // ── Priority helpers ──────────────────────────────────────────────────────

  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return const Color(0xFFF87171);
      case TaskPriority.medium:
        return const Color(0xFFFBBF24);
      case TaskPriority.low:
        return const Color(0xFF34D399);
    }
  }

  String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  IconData _priorityIcon(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return Icons.flag_rounded;
      case TaskPriority.medium:
        return Icons.outlined_flag_rounded;
      case TaskPriority.low:
        return Icons.flag_outlined;
    }
  }

  // ── Task dialog (Add / Edit) ──────────────────────────────────────────────

  void _showTaskDialog(BuildContext context, {Task? existingTask}) {
    final titleController =
        TextEditingController(text: existingTask?.title ?? '');
    final descController =
        TextEditingController(text: existingTask?.description ?? '');
    TaskPriority selectedPriority =
        existingTask?.priority ?? TaskPriority.medium;
    DateTime? selectedDueDate = existingTask?.dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                  top: 24,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withValues(alpha: 0.97),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      existingTask == null ? 'New Task' : 'Edit Task',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: titleController,
                      label: 'Task title',
                      icon: Icons.task_alt_rounded,
                    ),
                    const SizedBox(height: 12),

                    _buildInputField(
                      controller: descController,
                      label: 'Description (optional)',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Priority',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: TaskPriority.values.map((p) {
                        final isSelected = selectedPriority == p;
                        final pColor = _priorityColor(p);
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setModalState(() => selectedPriority = p),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? pColor.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? pColor
                                      : Colors.white12,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(_priorityIcon(p),
                                      color: isSelected
                                          ? pColor
                                          : Colors.white38,
                                      size: 20),
                                  const SizedBox(height: 4),
                                  Text(
                                    _priorityLabel(p),
                                    style: TextStyle(
                                      color: isSelected
                                          ? pColor
                                          : Colors.white38,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Due date picker
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate:
                              selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 1)),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 365)),
                          builder: (c, child) => Theme(
                            data: Theme.of(c).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: AppTheme.primaryAccent,
                                surface: AppTheme.surfaceColor,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDueDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                color: AppTheme.primaryAccent, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedDueDate != null
                                    ? 'Due: ${DateFormat('MMM d, yyyy').format(selectedDueDate!)}'
                                    : 'Set due date (optional)',
                                style: TextStyle(
                                  color: selectedDueDate != null
                                      ? Colors.white
                                      : Colors.white38,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (selectedDueDate != null)
                              GestureDetector(
                                onTap: () => setModalState(
                                    () => selectedDueDate = null),
                                child: const Icon(Icons.close,
                                    color: Colors.white38, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          final desc = descController.text.trim();
                          if (title.isNotEmpty) {
                            final vm =
                                context.read<TaskViewModel>();
                            if (existingTask == null) {
                              vm.addTask(
                                title,
                                desc,
                                priority: selectedPriority,
                                dueDate: selectedDueDate,
                              );
                            } else {
                              vm.updateTask(
                                existingTask.id,
                                title,
                                desc,
                                priority: selectedPriority,
                                dueDate: selectedDueDate,
                                clearDueDate: selectedDueDate == null &&
                                    existingTask.dueDate != null,
                              );
                            }
                            Navigator.pop(ctx);
                          }
                        },
                        child: Text(
                          existingTask == null ? 'Add Task' : 'Save Changes',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.white.withValues(alpha: 0.45)),
          prefixIcon:
              Icon(icon, color: AppTheme.primaryAccent, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ── Delete confirmation ───────────────────────────────────────────────────

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Task',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF87171),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              context.read<TaskViewModel>().deleteTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  backgroundColor: AppTheme.surfaceColor,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Task Manager',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            centerTitle: true,
            actions: [
              if (vm.completedCount > 0)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded,
                      color: Colors.white70),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppTheme.surfaceColor,
                        title: const Text('Clear Completed?',
                            style: TextStyle(color: Colors.white)),
                        content: const Text(
                            'This will permanently remove all finished tasks.',
                            style: TextStyle(color: Colors.white70)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              vm.clearCompletedTasks();
                              Navigator.pop(ctx);
                            },
                            child: const Text('Clear',
                                style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                ).animate().fadeIn().scale(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showTaskDialog(context),
            backgroundColor: AppTheme.primaryAccent,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Task',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
          body: Stack(
            children: [
              // Decorative blobs
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryAccent.withValues(alpha: 0.08),
                  ),
                ),
              ).animate().fadeIn(duration: 1.seconds),
              Positioned(
                bottom: -80,
                left: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppTheme.secondaryAccent.withValues(alpha: 0.07),
                  ),
                ),
              ).animate().fadeIn(duration: 1.seconds, delay: 300.ms),

              if (vm.isLoading)
                const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryAccent))
              else
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: _buildStatsCard(vm),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),

                    const SizedBox(height: 12),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildFilterTabs(vm),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 8),

                    Expanded(
                      child: vm.filteredTasks.isEmpty
                          ? _buildEmptyState(vm.filter)
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 8, 16, 100),
                              itemCount: vm.filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = vm.filteredTasks[index];
                                return _buildTaskCard(
                                    context, task, index);
                              },
                            ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Stats Card ────────────────────────────────────────────────────────────

  Widget _buildStatsCard(TaskViewModel vm) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statChip(Icons.format_list_bulleted_rounded,
                  '${vm.totalCount}', 'Total', Colors.white60),
              _statChip(Icons.radio_button_unchecked_rounded,
                  '${vm.activeCount}', 'Active', AppTheme.primaryAccent),
              _statChip(Icons.check_circle_rounded,
                  '${vm.completedCount}', 'Done', const Color(0xFF34D399)),
              Column(
                children: [
                  Text(
                    '${(vm.completionRatio * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Progress',
                      style:
                          TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: vm.completionRatio,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                vm.completionRatio == 1.0
                    ? const Color(0xFF34D399)
                    : AppTheme.primaryAccent,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style:
                const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  // ── Filter Tabs ───────────────────────────────────────────────────────────

  Widget _buildFilterTabs(TaskViewModel vm) {
    final filters = [
      (TaskFilter.all, 'All', vm.totalCount),
      (TaskFilter.active, 'Active', vm.activeCount),
      (TaskFilter.completed, 'Done', vm.completedCount),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: filters.map((f) {
          final isSelected = vm.filter == f.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => vm.setFilter(f.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryAccent.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(
                          color: AppTheme.primaryAccent
                              .withValues(alpha: 0.4))
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${f.$2} (${f.$3})',
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryAccent
                          : Colors.white38,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Task Card ─────────────────────────────────────────────────────────────

  Widget _buildTaskCard(BuildContext context, Task task, int index) {
    final priorityColor = _priorityColor(task.priority);
    final overdue = task.isOverdue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          _confirmDelete(context, task);
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color:
                const Color(0xFFF87171).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xFFF87171)
                    .withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFF87171), size: 26),
            ],
          ),
        ),
        child: GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(0),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context
                .read<TaskViewModel>()
                .toggleTaskCompletion(task.id),
            onLongPress: () =>
                _showTaskDialog(context, existingTask: task),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority colour bar
                  Container(
                    width: 4,
                    height: 60,
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? priorityColor.withValues(alpha: 0.2)
                          : priorityColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // Checkbox
                  GestureDetector(
                    onTap: () => context
                        .read<TaskViewModel>()
                        .toggleTaskCompletion(task.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 26,
                      height: 26,
                      margin:
                          const EdgeInsets.only(top: 2, right: 14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isCompleted
                              ? const Color(0xFF34D399)
                              : Colors.white30,
                          width: 2,
                        ),
                        color: task.isCompleted
                            ? const Color(0xFF34D399)
                                .withValues(alpha: 0.2)
                            : Colors.transparent,
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check_rounded,
                              size: 16,
                              color: Color(0xFF34D399))
                          : null,
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: task.isCompleted
                                ? Colors.white38
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Colors.white38,
                          ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: task.isCompleted
                                  ? Colors.white24
                                  : Colors.white54,
                              fontSize: 13,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Colors.white24,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Priority badge
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: priorityColor
                                    .withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(6),
                                border: Border.all(
                                    color: priorityColor
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_priorityIcon(task.priority),
                                      size: 11,
                                      color: priorityColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    _priorityLabel(task.priority),
                                    style: TextStyle(
                                        color: priorityColor,
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            if (task.dueDate != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3),
                                decoration: BoxDecoration(
                                  color: overdue
                                      ? const Color(0xFFF87171)
                                          .withValues(alpha: 0.12)
                                      : Colors.white
                                          .withValues(alpha: 0.06),
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  border: Border.all(
                                      color: overdue
                                          ? const Color(0xFFF87171)
                                              .withValues(alpha: 0.4)
                                          : Colors.white12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 10,
                                      color: overdue
                                          ? const Color(0xFFF87171)
                                          : Colors.white38,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('MMM d')
                                          .format(task.dueDate!),
                                      style: TextStyle(
                                        color: overdue
                                            ? const Color(0xFFF87171)
                                            : Colors.white38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (overdue) ...[
                                      const SizedBox(width: 4),
                                      const Text(
                                        '· Overdue',
                                        style: TextStyle(
                                            color:
                                                Color(0xFFF87171),
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.bold),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded,
                        color: Colors.white30, size: 22),
                    onPressed: () =>
                        _showTaskDialog(context, existingTask: task),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(
            delay: Duration(milliseconds: 40 * index),
          ).slideX(
            begin: 0.08,
            delay: Duration(milliseconds: 40 * index),
          ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(TaskFilter filter) {
    final IconData icon;
    final String title;
    final String subtitle;

    switch (filter) {
      case TaskFilter.active:
        icon = Icons.check_circle_outline_rounded;
        title = 'All caught up!';
        subtitle = 'No active tasks. Add a new one to get started.';
        break;
      case TaskFilter.completed:
        icon = Icons.checklist_rtl_rounded;
        title = 'Nothing completed yet';
        subtitle = 'Tap a task to mark it as done.';
        break;
      case TaskFilter.all:
        icon = Icons.checklist_rtl_rounded;
        title = 'No tasks yet';
        subtitle =
            'Tap the button below to create your first task!';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 72, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 14),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
