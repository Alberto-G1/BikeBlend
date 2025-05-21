import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> services = [];
  
  @override
  void initState() {
    super.initState();
    _fetchServices();
  }
  
  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final servicesSnapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('ownerId', isEqualTo: user.uid)
            .get();
            
        services = servicesSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching services: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  void _showAddEditServiceDialog([Map<String, dynamic>? service]) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    final nameController = TextEditingController(text: service?['name'] ?? '');
    final descriptionController = TextEditingController(text: service?['description'] ?? '');
    final priceController = TextEditingController(
      text: service?['price'] != null ? service!['price'].toString() : '',
    );
    final durationController = TextEditingController(
      text: service?['duration'] != null ? service!['duration'].toString() : '',
    );
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            service != null ? 'Edit Service' : 'Add New Service',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                    hintText: 'e.g., Haircut, Manicure',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                    hintText: 'Describe the service...',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // labelText: 'Price ($)',
                          labelStyle: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                          ),
                          filled: true,
                          fillColor: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Duration (min)',
                          labelStyle: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                          hintText: '30',
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                          ),
                          filled: true,
                          fillColor: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name and price are required')),
                  );
                  return;
                }
                
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;
                  
                  final serviceData = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'duration': int.tryParse(durationController.text) ?? 0,
                    'ownerId': user.uid,
                    'updatedAt': FieldValue.serverTimestamp(),
                  };
                  
                  if (service != null) {
                    // Update existing service
                    await FirebaseFirestore.instance
                        .collection('services')
                        .doc(service['id'])
                        .update(serviceData);
                  } else {
                    // Add new service
                    serviceData['createdAt'] = FieldValue.serverTimestamp();
                    await FirebaseFirestore.instance
                        .collection('services')
                        .add(serviceData);
                  }
                  
                  if (mounted) {
                    Navigator.of(context).pop();
                    _fetchServices();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving service: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                foregroundColor: Colors.white,
              ),
              child: Text(
                service != null ? 'Update' : 'Add',
              ),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _deleteService(String serviceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .delete();
      
      _fetchServices();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting service: $e')),
      );
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
        title: const Text(
          'Manage Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              ),
            )
          : services.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.spa,
                        size: 80,
                        color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No services added yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first service',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    service['name'] ?? 'Unnamed Service',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${service['price']?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                  ),
                                ),
                              ],
                            ),
                            if (service['description'] != null && service['description'].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                service['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (service['duration'] != null) ...[
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${service['duration']} min',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: isDarkMode ? Colors.white70 : Colors.black54,
                                    size: 20,
                                  ),
                                  onPressed: () => _showAddEditServiceDialog(service),
                                  tooltip: 'Edit Service',
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: isDarkMode ? Colors.redAccent[100] : Colors.redAccent,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Delete Service',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                                        content: Text(
                                          'Are you sure you want to delete "${service['name']}"?',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white70 : Colors.black87,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _deleteService(service['id']);
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: isDarkMode ? Colors.redAccent[100] : Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  tooltip: 'Delete Service',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditServiceDialog(),
        backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
        child: const Icon(Icons.add),
      ),
    );
  }
}
