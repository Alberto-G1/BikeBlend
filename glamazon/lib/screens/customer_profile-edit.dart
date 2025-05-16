import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/reusable_widgets/custom_app_bar.dart';
import 'package:glamazon/screens/customer_profile-details.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> with SingleTickerProviderStateMixin {
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
  bool _dataLoaded = false;
  
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
    
    // Load profile data
    _loadProfile();
    
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

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          
          setState(() {
            _usernameController.text = userData['username'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _bioController.text = userData['bio'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _imageUrl = userData['profile_picture'];
            
            // Convert timestamp to DateTime if it exists
            if (userData['birth_date'] != null) {
              _birthDate = DateTime.fromMillisecondsSinceEpoch(userData['birth_date']);
            }
            
            _gender = userData['gender'] ?? 'Prefer not to say';
            
            // Load preferences if they exist
            if (userData['preferences'] != null) {
              _preferences = List<String>.from(userData['preferences']);
            }
            
            _dataLoaded = true;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
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
          await _firestore.collection('users').doc(user.uid).update({
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
            'updated_at': FieldValue.serverTimestamp(),
          });
          
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate back to profile screen
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
              content: Text('Failed to update profile: $e'),
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
      appBar: CustomAppBar(
        title: 'Edit Profile',
        backgroundColor: isDarkMode ? Colors.black : AppColors.sienna,
        showThemeToggle: true,
      ),
      body: _isLoading && !_dataLoaded
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? Colors.tealAccent : AppColors.sienna,
              ),
            )
          : Stack(
              children: [
                Container(
                  height: 100,
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
                                            : _imageUrl != null && _imageUrl!.isNotEmpty
                                                ? DecorationImage(
                                                    image: NetworkImage(_imageUrl!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                      ),
                                      child: (_image == null && (_imageUrl == null || _imageUrl!.isEmpty))
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
                                          'Save Changes',
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



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:glamazon/screens/customer_profile-details.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// class ProfileEditScreen extends StatefulWidget {
//   const ProfileEditScreen({super.key});

//   @override
//   _ProfileEditScreenState createState() => _ProfileEditScreenState();
// }

// class _ProfileEditScreenState extends State<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>(); // Ensure this is properly declared and initialized
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   File? _image;
//   String? _imageUrl;

//   Future<void> _getImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? user = _auth.currentUser;
//         if (user != null) {
//           if (_image != null) {
//             // Upload the profile picture to Firebase Storage
//             final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}');
//             final uploadTask = storageRef.putFile(_image!);
//             final snapshot = await uploadTask.whenComplete(() {});
//             _imageUrl = await snapshot.ref.getDownloadURL();
//           }

//           await _firestore.collection('users').doc(user.uid).set({
//             'username': _usernameController.text,
//             'email': _emailController.text,
//             'phone': _phoneController.text,
//             'profile_picture': _imageUrl ?? '',
//             'password': _passwordController.text,
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile saved successfully')),
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const ProfileScreen()),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save profile: $e')),
//         );
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           _usernameController.text = userDoc['username'];
//           _emailController.text = userDoc['email'];
//           _phoneController.text = userDoc['phone'];
//           _passwordController.text = userDoc['password'];
//           _imageUrl = userDoc['profile_picture'];
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 248, 236, 220),
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: _getImage,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : _imageUrl != null
//                             ? NetworkImage(_imageUrl!) as ImageProvider
//                             : const AssetImage('assets/images/default_profile.png'),
//                     child: _image == null && _imageUrl == null
//                         ? const Icon(Icons.person, size: 50)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(labelText: 'Username'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a username';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(labelText: 'Phone'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _saveProfile,
//                   child: const Text('Save Profile'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


