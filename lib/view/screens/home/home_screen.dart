import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/viewmodel/task_view_model.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/view/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<DateTime> _dateTabs =
      List.generate(5, (index) => DateTime.now().add(Duration(days: index)));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _dateTabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final selectedDate = _dateTabs[_tabController.index];
      Provider.of<TaskViewModel>(context, listen: false)
          .setSelectedDate(selectedDate);
    });

    // Set initial date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskViewModel>(context, listen: false)
          .setSelectedDate(_dateTabs[0]);
    });
  }

  void _openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddTaskDialog(),
    );
  }

  List<DropdownMenuItem<DateTime>> _buildMonthYearItems() {
    final now = DateTime.now();
    final items = <DropdownMenuItem<DateTime>>[];

    for (int i = -12; i <= 12; i++) {
      final date = DateTime(now.year, now.month + i);
      items.add(
        DropdownMenuItem(
          value: DateTime(date.year, date.month),
          child: Text(DateFormat('MMMM yyyy').format(date)),
        ),
      );
    }

    return items;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context);
    final tasks = taskVM.filteredTasks;

    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d').format(now);

    return Scaffold(
      backgroundColor: const Color(0xffEBE8E3),
      appBar: AppBar(
        backgroundColor: const Color(0xffEBE8E3),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          formattedDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Dropdown Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade400, width: 0.8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DateTime>(
                  value: DateTime(_dateTabs[0].year, _dateTabs[0].month),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  isDense: true,
                  onChanged: (DateTime? newDate) {
                    if (newDate == null) return;

                    setState(() {
                      _dateTabs.clear();

                      final now = DateTime.now();
                      final isCurrentMonth = newDate.year == now.year &&
                          newDate.month == now.month;

                      if (isCurrentMonth) {
                        // Show: Today, Tomorrow, etc.
                        for (int i = 0; i < 5; i++) {
                          _dateTabs.add(now.add(Duration(days: i)));
                        }
                      } else {
                        // For other months: Show from 1st to 5th
                        for (int i = 0; i < 5; i++) {
                          _dateTabs.add(
                              DateTime(newDate.year, newDate.month, i + 1));
                        }
                      }

                      _tabController.dispose();
                      _tabController =
                          TabController(length: _dateTabs.length, vsync: this);
                      _tabController.addListener(() {
                        if (_tabController.indexIsChanging) return;
                        Provider.of<TaskViewModel>(context, listen: false)
                            .setSelectedDate(_dateTabs[_tabController.index]);
                      });

                      Provider.of<TaskViewModel>(context, listen: false)
                          .setSelectedDate(_dateTabs[0]);
                    });
                  },
                  items: _buildMonthYearItems(),
                ),
              ),
            ),
          ),

          // Date Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            unselectedLabelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            labelStyle:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            tabAlignment: TabAlignment.start,
            tabs: _dateTabs.map((date) {
              String label;
              if (DateUtils.isSameDay(date, now)) {
                label = 'Today';
              } else if (DateUtils.isSameDay(
                  date, now.add(const Duration(days: 1)))) {
                label = 'Tomorrow';
              } else {
                label = DateFormat('MMM d').format(date);
              }
              return Tab(text: label);
            }).toList(),
          ),

          Consumer<TaskViewModel>(
            builder: (context, taskVM, _) {
              if (taskVM.filteredTasks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Plan your day with purpose!",
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            "You’ve got tasks to conquer — let’s do this together.",
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),

          // Task List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: tasks[index], index: index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade500,
        onPressed: _openAddTaskDialog,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog({super.key});

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _submitTask() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) return;

    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    taskVM.addTask(
      taskVM.createNewTask(title: title, description: desc),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Task",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitTask,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Add",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
