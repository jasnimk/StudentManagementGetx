import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import 'package:student_management_getx/screens/add_student.dart';
import 'package:student_management_getx/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    studentController.loadStudents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                studentController.isGridView.value
                    ? Icons.list
                    : Icons.grid_view,
              ),
              onPressed: studentController.toggleView,
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: studentController.setSearchQuery,
              decoration: const InputDecoration(
                labelText: 'Search Students',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (studentController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final students = studentController.filteredStudents;

              if (students.isEmpty) {
                return const Center(child: Text('No students found'));
              }

              return studentController.isGridView.value
                  ? GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return buildStudentCard(
                            context, student, studentController);
                      },
                    )
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return buildStudentListTile(
                            context, student, studentController);
                      },
                    );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          studentController.clearImage();
          studentController.clearControllers();
          Get.to(() => AddStudentScreen())?.then((_) {
            studentController.loadStudents();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
