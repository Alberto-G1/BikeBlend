import 'package:flutter/material.dart';
import 'package:glamazon/screens/owner_profile_page.dart';
import 'package:glamazon/utils/colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _salonNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _workingDaysController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _salonDescriptionController = TextEditingController();
  bool isEditing = false;
  String? _profileImageUrl;
  
  Map<String, bool> _servicesOffered = {
    'Hair styling and Cuts': false,
    'Nails': false,
    'Spa or Massage': false,
    'Tattoo': false,
    'Facial and Makeup': false,
    'Piercing': false,
  };
  
  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
    });
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final profileDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
        final data = profileDoc.data();
        
        if (data != null) {
          setState(() {
            isEditing = true;
            _salonNameController.text = data['salonName'] ?? '';
            _ownerNameController.text = data['ownerName'] ?? '';
            _contactController.text = data['contact'] ?? '';
            _emailController.text = data['email'] ?? '';
            _locationController.text = data['location'] ?? '';
            _workingDaysController.text = data['workingDays'] ?? 'Monday to Saturday';
            _workingHoursController.text = data['workingHours'] ?? '';
            _salonDescriptionController.text = data['salonDescription'] ?? '';
            _profileImageUrl = data['profileImageUrl'];
            
            if (data['servicesOffered'] != null) {
              _servicesOffered = Map<String, bool>.from(data['servicesOffered']);
            }
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching profile data: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.camera_alt, 
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library, 
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      
      if (image != null) {
        final File imageFile = File(image.path);
        if (await imageFile.exists()) {
          setState(() {
            _profileImage = imageFile;
          });
        } else {
          throw Exception('Picked image file does not exist.');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String> _uploadProfileImage(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      final storageRef = FirebaseStorage.instance.ref();
      final profileImagesRef = storageRef.child('profile_images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      final uploadTask = profileImagesRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('Upload task did not complete successfully');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not authenticated')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      String? profileImageUrl;
      if (_profileImage != null) {
        try {
          profileImageUrl = await _uploadProfileImage(_profileImage!);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      
      final profileData = {
        'profileImageUrl': profileImageUrl ?? _profileImageUrl ?? '',
        'salonName': _salonNameController.text,
        'ownerName': _ownerNameController.text,
        'contact': _contactController.text,
        'email': _emailController.text,
        'location': _locationController.text,
        'workingDays': _workingDaysController.text,
        'workingHours': _workingHoursController.text,
        'salonDescription': _salonDescriptionController.text,
        'servicesOffered': _servicesOffered,
        'role': 'salon_owner',
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      try {
        await FirebaseFirestore.instance
            .collection('owners')
            .doc(user.uid)
            .set(profileData, SetOptions(merge: true));
            
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode 
          ? const Color(0xFF121212) 
          : const Color.fromARGB(255, 248, 236, 220),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Salon Profile' : 'Create Salon Profile',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Hero(
                            tag: 'profile-image',
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: _profileImage != null
                                    ? Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: _profileImageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                              child: const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                              child: const Icon(Icons.error),
                                            ),
                                          )
                                        : Container(
                                            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                            child: Icon(
                                              Icons.business,
                                              size: 50,
                                              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                                            ),
                                          )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode ? Colors.black : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Basic Information Section
                    _buildSectionTitle('Basic Information', isDarkMode),
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _salonNameController,
                      label: 'Salon Name',
                      hint: 'Enter your salon name',
                      icon: Icons.business,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter salon name';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _ownerNameController,
                      label: 'Owner\'s Name',
                      hint: 'Enter owner\'s name',
                      icon: Icons.person,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter owner\'s name';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter email address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _contactController,
                      label: 'Contact Number',
                      hint: 'Enter contact number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _locationController,
                      label: 'Location',
                      hint: 'Enter salon location',
                      icon: Icons.location_on,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Business Hours Section
                    _buildSectionTitle('Business Hours', isDarkMode),
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _workingDaysController,
                      label: 'Working Days',
                      hint: 'e.g., Monday to Saturday',
                      icon: Icons.calendar_today,
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextFormField(
                      controller: _workingHoursController,
                      label: 'Working Hours',
                      hint: 'e.g., 9:00 AM - 7:00 PM',
                      icon: Icons.access_time,
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Services Section
                    _buildSectionTitle('Services Offered', isDarkMode),
                    const SizedBox(height: 16),
                    
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: _servicesOffered.keys.map((service) {
                            return CheckboxListTile(
                              title: Text(
                                service,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              value: _servicesOffered[service],
                              activeColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                              checkColor: Colors.white,
                              onChanged: (bool? value) {
                                setState(() {
                                  _servicesOffered[service] = value ?? false;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Salon Description Section
                    _buildSectionTitle('Salon Description', isDarkMode),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _salonDescriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe your salon, services, and unique features...',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                        ),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          isEditing ? 'Update Profile' : 'Create Profile',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: isDarkMode 
                ? AppColors.siennaLight.withOpacity(0.3) 
                : AppColors.sienna.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
        ),
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}
