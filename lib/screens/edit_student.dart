import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_getx/get/get.dart';
import 'package:student_management_getx/model/student_model.dart';
import 'package:student_management_getx/widgets/widgets.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final StudentController controller = Get.put(StudentController());

  late TextEditingController _nameController;
  late TextEditingController _admissionController;
  late TextEditingController _courseController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _admissionController =
        TextEditingController(text: widget.student.admissionNumber);
    _courseController = TextEditingController(text: widget.student.course);
    _contactController = TextEditingController(text: widget.student.contact);

    // Set the image in the controller
    if (widget.student.imagePath != null) {
      controller.imageFile.value = File(widget.student.imagePath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _admissionController.dispose();
    _courseController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student.id,
        name: _nameController.text,
        admissionNumber: _admissionController.text,
        course: _courseController.text,
        contact: _contactController.text,
        imagePath: controller.imageFile.value?.path ?? widget.student.imagePath,
      );

      await controller.updateStudent(student);
      Get.back();
      Get.snackbar(
        'Success',
        'Student updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showImagePickerDialog() {
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
      appBar: appbarWidget('Edit Student'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _showImagePickerDialog,
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
                                fit: BoxFit.cover,
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
                    controller: _nameController,
                    label: 'Name',
                    validationMessage: 'Enter name'),
                const SizedBox(height: 16),
                buildTextFormField(
                    controller: _admissionController,
                    label: 'Admission Numbeer',
                    validationMessage: 'Enter admission number'),
                const SizedBox(height: 16),
                buildTextFormField(
                    controller: _courseController,
                    label: 'Course',
                    validationMessage: 'Enter course'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
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
                    'Update Student',
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
