import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import 'package:student_management_getx/model/student_model.dart';
import 'package:student_management_getx/screens/edit_student.dart';

class ProfileScreen extends StatelessWidget {
  final int studentId;

  const ProfileScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.find<StudentController>();

    // Load student data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStudent1(studentId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.student1.value == null) {
          return const Center(
            child: Text('Student not found'),
          );
        }

        final student = controller.student1.value!;
        return _buildStudentDetails(student, context);
      }),
    );
  }

  Widget _buildStudentDetails(Student student, BuildContext context) {
    final StudentController controller = Get.find<StudentController>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (student.imagePath != null &&
                File(student.imagePath!).existsSync())
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Get.to<bool>(
                            () => EditStudentScreen(student: student),
                          );

                          if (result == true) {
                            // First update the student details
                            await controller.getStudent1(student.id!);

                            // Then refresh the list
                            await controller.loadStudents();

                            // Show success message after both operations complete
                            Get.snackbar(
                              'Success',
                              'Student information updated successfully',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Student'),
                                content: const Text(
                                    'Are you sure you want to delete this student?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await controller
                                          .deleteStudent(student.id!);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      Get.back();
                                      Get.snackbar(
                                        'Success',
                                        'Student deleted successfully',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(student.imagePath!)),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name', student.name),
                    const SizedBox(height: 12),
                    _buildInfoRow('Admission Number', student.admissionNumber),
                    const SizedBox(height: 12),
                    _buildInfoRow('Course', student.course),
                    const SizedBox(height: 12),
                    _buildInfoRow('Contact', student.contact),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
