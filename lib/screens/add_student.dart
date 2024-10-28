import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import 'package:student_management_getx/model/student_model.dart';
import 'package:student_management_getx/widgets/widgets.dart';

class AddStudentScreen extends StatelessWidget {
  AddStudentScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final StudentController controller = Get.put(StudentController());

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        name: controller.nameController.text,
        admissionNumber: controller.admissionController.text,
        course: controller.courseController.text,
        contact: controller.contactController.text,
        imagePath: controller.imageFile.value?.path,
      );

      await controller.addStudent(student);
      Get.back();
      Get.snackbar(
        'Success',
        'Student added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('From Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('From Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Add a Student'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _showImagePickerDialog(context),
                  child: Obx(() {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.imageFile.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                controller.imageFile.value!,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                buildTextFormField(
                    controller: controller.nameController,
                    label: 'Name',
                    validationMessage: 'Enter name'),
                const SizedBox(height: 16),
                buildTextFormField(
                    controller: controller.admissionController,
                    label: 'Admission Number',
                    validationMessage: 'Enter admission number'),
                const SizedBox(height: 16),
                buildTextFormField(
                    controller: controller.courseController,
                    label: 'Course',
                    validationMessage: 'Enter course'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Add Student',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
