import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  
  // Pick image from gallery
  Future<File?> pickImage({bool fromCamera = false}) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    
    return null;
  }
  
  // Upload image to Firebase Storage
  Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      // Generate a unique filename
      final String fileName = '${const Uuid().v4()}${path.extension(imageFile.path)}';
      final String filePath = '$folder/$fileName';
      
      // Upload to Firebase Storage
      final UploadTask uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      
      // Get download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  
  // Delete image from Firebase Storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract the path from the URL
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
  
  // Get image from Firebase Storage
  Future<Image?> getImage(String imageUrl) async {
    try {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } catch (e) {
      print('Error getting image: $e');
      return null;
    }
  }
}
