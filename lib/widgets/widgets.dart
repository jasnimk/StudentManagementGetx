import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:student_management_getx/get/get.dart';
import 'package:student_management_getx/model/student_model.dart';
import 'package:student_management_getx/screens/add_student.dart';
import 'package:student_management_getx/screens/edit_student.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String validationMessage,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return validationMessage;
      }
      return null;
    },
  );
}

Widget buildStudentCard(
    BuildContext context, Student student, StudentController controller) {
  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (student.imagePath != null)
          Expanded(
            child: Image.file(
              File(student.imagePath!),
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          )
        else
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 50),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(student.admissionNumber),
              Text(student.course),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.to(() => EditStudentScreen(student: student));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDeleteDialog(context, student, controller);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildStudentListTile(
    BuildContext context, Student student, StudentController controller) {
  return ListTile(
    leading: student.imagePath != null
        ? CircleAvatar(
            backgroundImage: FileImage(File(student.imagePath!)),
          )
        : const CircleAvatar(child: Icon(Icons.person)),
    title: Text(student.name),
    subtitle: Text('${student.admissionNumber} - ${student.course}'),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Get.to(() => EditStudentScreen(student: student));
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDeleteDialog(context, student, controller);
          },
        ),
      ],
    ),
  );
}

void showDeleteDialog(
    BuildContext context, Student student, StudentController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              controller.deleteStudent(student.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

appbarWidget(String name) {
  return AppBar(
    title: Text(name),
    backgroundColor: Colors.blue[100],
  );
}

buildCustomTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String emptyValidationMessage,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return emptyValidationMessage;
      }
      return null;
    },
  );
}
