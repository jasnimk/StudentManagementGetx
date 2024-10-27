import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_management_getx/controllers/database_helper.dart';
import 'package:student_management_getx/model/student_model.dart';

class StudentController extends GetxController {
  var students = <Student>[].obs; // Observable list of students
  var isGridView = true.obs; // Observable for grid view
  var imageFile = Rx<File?>(null); // Observable for image file
  var isLoading = false.obs; // Observable for loading state
  var searchQuery = ''.obs; // Observable for search query

  List<Student> get filteredStudents {
    return students.where((student) {
      return student.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          student.admissionNumber
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> loadStudents() async {
    isLoading.value = true;

    try {
      students.value = await getAllStudents();
    } catch (e) {
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStudent(Student student) async {
    isLoading.value = true;

    try {
      String? imagePath;
      if (imageFile.value != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage =
            await imageFile.value!.copy('${directory.path}/$fileName');
        imagePath = savedImage.path;
      }

      final newStudent = Student(
        name: student.name,
        admissionNumber: student.admissionNumber,
        course: student.course,
        contact: student.contact,
        imagePath: imagePath,
      );

      await insertStudent(newStudent);
      await loadStudents();
    } catch (e) {
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStudent(Student student) async {
    isLoading.value = true;

    try {
      String? imagePath = student.imagePath;
      if (imageFile.value != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage =
            await imageFile.value!.copy('${directory.path}/$fileName');
        imagePath = savedImage.path;
      }

      final updatedStudent = Student(
        id: student.id,
        name: student.name,
        admissionNumber: student.admissionNumber,
        course: student.course,
        contact: student.contact,
        imagePath: imagePath,
      );

      await updateStudent1(updatedStudent);
      await loadStudents();
    } catch (e) {
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStudent(int id) async {
    isLoading.value = true;

    try {
      await deleteStudent1(id);
      await loadStudents();
    } catch (e) {
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      throw e;
    }
  }

  void clearImage() {
    imageFile.value = null;
  }
}
