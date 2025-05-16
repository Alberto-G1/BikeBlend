import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/screens/customer_profile-details.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  
  // Form controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // Profile data
  File? _image;
  String? _imageUrl;
  DateTime? _birthDate;
  String _gender = 'Prefer not to say';
  List<String> _preferences = [];
  bool _isLoading = false;
  bool _animate = false;
  
  // Animation controller
  late AnimationController _animationController;
  
  // Available preferences
  final List<String> _availablePreferences = [
    'Hair Styling', 'Nail Care', 'Spa & Massage', 
    'Tattoos', 'Makeup', 'Piercing', 'Skincare'
  ];
  
  // Gender options
  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Pre-fill email from Firebase Auth
    User? user = _auth.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
    }
    
    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.sienna,
              onPrimary: Colors.white,
              surface: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              onSurface: isDarkMode ? Colors.white : Colors.black,
            ),
            dialogBackgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Upload profile picture if selected
          if (_image != null) {
            final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}');
            final uploadTask = storageRef.putFile(_image!);
            final snapshot = await uploadTask.whenComplete(() {});
            _imageUrl = await snapshot.ref.getDownloadURL();
          }
          
          // Calculate age if birthdate is provided
          int? age;
          if (_birthDate != null) {
            age = DateTime.now().year - _birthDate!.year;
            if (DateTime.now().month < _birthDate!.month || 
                (DateTime.now().month == _birthDate!.month && 
                 DateTime.now().day < _birthDate!.day)) {
              age--;
            }
          }
          
          // Save user data to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'username': _usernameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'bio': _bioController.text,
            'address': _addressController.text,
            'profile_picture': _imageUrl ?? '',
            'birth_date': _birthDate?.millisecondsSinceEpoch,
            'age': age,
            'gender': _gender,
            'preferences': _preferences,
            'created_at': FieldValue.serverTimestamp(),
            'updated_at': FieldValue.serverTimestamp(),
            'role': 'customer',
          });
          
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate to profile screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color.fromARGB(255, 248, 236, 220),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : AppColors.sienna,
        elevation: 0,
        title: AppAnimations.fadeIn(
          animate: _animate,
          delay: const Duration(milliseconds: 200),
          child: const Text(
            'Create Your Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : AppColors.sienna,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppAnimations.scale(
                        animate: _animate,
                        delay: const Duration(milliseconds: 300),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _getImage,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  image: _image != null
                                      ? DecorationImage(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: _image == null
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.teal.shade700 : AppColors.sienna,
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
                      const SizedBox(height: 24),
                      
                      // Profile form
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 400),
                                child: Text(
                                  'Basic Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : AppColors.sienna,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Username field
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 500),
                                child: _buildTextField(
                                  controller: _usernameController,
                                  labelText: 'Username',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a username';
                                    }
                                    return null;
                                  },
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Email field
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 600),
                                child: _buildTextField(
                                  controller: _emailController,
                                  labelText: 'Email',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Phone field
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 700),
                                child: _buildTextField(
                                  controller: _phoneController,
                                  labelText: 'Phone Number',
                                  prefixIcon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a phone number';
                                    }
                                    return null;
                                  },
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Additional information
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 800),
                                child: Text(
                                  'Additional Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : AppColors.sienna,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Birth date picker
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 900),
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _birthDate == null
                                              ? 'Birth Date'
                                              : DateFormat('MMMM d, yyyy').format(_birthDate!),
                                          style: TextStyle(
                                            color: _birthDate == null
                                                ? (isDarkMode ? Colors.grey[400] : Colors.grey[600])
                                                : (isDarkMode ? Colors.white : Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Gender selection
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 1000),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: _genderOptions.map((gender) {
                                        return ChoiceChip(
                                          label: Text(gender),
                                          selected: _gender == gender,
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                _gender = gender;
                                              });
                                            }
                                          },
                                          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                          selectedColor: isDarkMode ? Colors.teal.shade700 : AppColors.sienna.withOpacity(0.7),
                                          labelStyle: TextStyle(
                                            color: _gender == gender
                                                ? Colors.white
                                                : (isDarkMode ? Colors.grey[300] : Colors.black87),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Address field
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 1100),
                                child: _buildTextField(
                                  controller: _addressController,
                                  labelText: 'Address',
                                  prefixIcon: Icons.location_on_outlined,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Bio field
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 1200),
                                child: TextField(
                                  controller: _bioController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Bio',
                                    alignLabelWithHint: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 45),
                                      child: Icon(
                                        Icons.edit_note,
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
                                        width: 2,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Beauty preferences
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 1300),
                                child: Text(
                                  'Beauty Preferences',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : AppColors.sienna,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 1400),
                                child: Text(
                                  'Select services you\'re interested in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppAnimations.slideIn(
                                animate: _animate,
                                beginOffset: const Offset(0, 0.2),
                                delay: const Duration(milliseconds: 1500),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _availablePreferences.map((preference) {
                                    return FilterChip(
                                      label: Text(preference),
                                      selected: _preferences.contains(preference),
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _preferences.add(preference);
                                          } else {
                                            _preferences.remove(preference);
                                          }
                                        });
                                      },
                                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                      selectedColor: isDarkMode ? Colors.teal.shade700 : AppColors.sienna.withOpacity(0.7),
                                      checkmarkColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: _preferences.contains(preference)
                                            ? Colors.white
                                            : (isDarkMode ? Colors.grey[300] : Colors.black87),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Save button
                      AppAnimations.slideIn(
                        animate: _animate,
                        beginOffset: const Offset(0, 0.2),
                        delay: const Duration(milliseconds: 1600),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode ? Colors.teal.shade700 : AppColors.sienna,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Create Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    bool isDarkMode = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red.shade700,
          ),
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
