import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/get/get.dart'; // Ensure correct import
import 'package:student_management_getx/screens/add_student.dart';
import 'package:student_management_getx/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());

  HomeScreen({Key? key}) : super(key: key) {
    // Load students when the screen is created
    studentController.loadStudents();
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) => studentController.setSearchQuery(value),
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
          Get.to(() => const AddStudentScreen())?.then((_) {
            studentController.loadStudents();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
