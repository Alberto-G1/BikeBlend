import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/models.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SalonDetailsPage extends StatefulWidget {
  final String salonId;
  
  const SalonDetailsPage({
    super.key,
    required this.salonId, required Owner salon,
  });
  
  @override
  State<SalonDetailsPage> createState() => _SalonDetailsPageState();
}

class _SalonDetailsPageState extends State<SalonDetailsPage> {
  bool isLoading = true;
  Map<String, dynamic> salonData = {};
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0.0;
  bool isOwner = false;
  
  @override
  void initState() {
    super.initState();
    _fetchSalonDetails();
  }
  
  Future<void> _fetchSalonDetails() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Check if current user is the owner
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.uid == widget.salonId) {
        isOwner = true;
      }
      
      // Fetch salon data
      final salonDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(widget.salonId)
          .get();
          
      if (salonDoc.exists) {
        salonData = salonDoc.data() ?? {};
        
        // Fetch services
        final servicesSnapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('ownerId', isEqualTo: widget.salonId)
            .get();
            
        services = servicesSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
            
        // Fetch reviews
        final reviewsSnapshot = await FirebaseFirestore.instance
            .collection('reviews')
            .where('salonId', isEqualTo: widget.salonId)
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();
            
        reviews = reviewsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
            
        // Calculate average rating
        if (reviews.isNotEmpty) {
          double totalRating = 0;
          for (var review in reviews) {
            totalRating += (review['rating'] ?? 0).toDouble();
          }
          averageRating = totalRating / reviews.length;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching salon details: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  
  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Inquiry about salon services',
    );
    await launchUrl(launchUri);
  }
  
  void _shareSalon() {
    final String salonName = salonData['salonName'] ?? 'Our Salon';
    final String location = salonData['location'] ?? '';
    Share.share(
      'Check out $salonName located at $location. They offer great beauty services!',
      subject: 'Great Salon Recommendation',
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode 
          ? const Color(0xFF121212) 
          : const Color.fromARGB(255, 248, 236, 220),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              ),
            )
          : CustomScrollView(
              slivers: [
                // App Bar with Salon Image
                SliverAppBar(
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      salonData['salonName'] ?? 'Salon Details',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Salon Image
                        salonData['profileImageUrl'] != null && salonData['profileImageUrl'].isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: salonData['profileImageUrl'],
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
                                  size: 80,
                                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                                ),
                              ),
                        // Gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: _shareSalon,
                      tooltip: 'Share',
                    ),
                    if (isOwner)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit-profile');
                        },
                        tooltip: 'Edit Salon',
                      ),
                  ],
                ),
                
                // Salon Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating and Location
                        Row(
                          children: [
                            // Rating
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    averageRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Location
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      salonData['location'] ?? 'Location not specified',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white70 : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Quick Contact Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContactButton(
                              icon: Icons.phone,
                              label: 'Call',
                              onTap: () {
                                if (salonData['contact'] != null && salonData['contact'].isNotEmpty) {
                                  _makePhoneCall(salonData['contact']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Phone number not available')),
                                  );
                                }
                              },
                              isDarkMode: isDarkMode,
                            ),
                            _buildContactButton(
                              icon: Icons.email,
                              label: 'Email',
                              onTap: () {
                                if (salonData['email'] != null && salonData['email'].isNotEmpty) {
                                  _sendEmail(salonData['email']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Email not available')),
                                  );
                                }
                              },
                              isDarkMode: isDarkMode,
                            ),
                            _buildContactButton(
                              icon: Icons.calendar_today,
                              label: 'Book',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Booking feature coming soon')),
                                );
                              },
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // About Section
                        _buildSectionTitle('About', isDarkMode),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  salonData['salonDescription'] ?? 'No description available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                      color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Owner: ${salonData['ownerName'] ?? 'Not specified'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkMode ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Business Hours Section
                        _buildSectionTitle('Business Hours', isDarkMode),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  'Working Days',
                                  salonData['workingDays'] ?? 'Not specified',
                                  isDarkMode,
                                ),
                                const Divider(),
                                _buildInfoRow(
                                  Icons.access_time,
                                  'Working Hours',
                                  salonData['workingHours'] ?? 'Not specified',
                                  isDarkMode,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Services Section
                        _buildSectionTitle('Services Offered', isDarkMode),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (salonData['servicesOffered'] != null)
                                  ...Map<String, dynamic>.from(salonData['servicesOffered'])
                                      .entries
                                      .where((entry) => entry.value == true)
                                      .map((entry) => _buildServiceItem(entry.key, isDarkMode))
                                      .toList(),
                                if (salonData['servicesOffered'] != null)
                                  ...Map<String, dynamic>.from(salonData['servicesOffered'])
                                      .entries
                                      .where((entry) => entry.value == true)
                                      .map((entry) => _buildServiceItem(entry.key, isDarkMode))
                                      .toList(),
                                if (salonData['servicesOffered'] == null || 
                                    Map<String, dynamic>.from(salonData['servicesOffered'])
                                        .entries
                                        .where((entry) => entry.value == true)
                                        .isEmpty)
                                  Text(
                                    'No services specified',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white70 : Colors.black87,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Service List Section (if available)
                        if (services.isNotEmpty) ...[
                          _buildSectionTitle('Service Menu', isDarkMode),
                          const SizedBox(height: 12),
                          ...services.map((service) => _buildServiceCard(service, isDarkMode)).toList(),
                          const SizedBox(height: 12),
                        ],
                        
                        // Reviews Section
                        _buildSectionTitle('Reviews', isDarkMode),
                        const SizedBox(height: 12),
                        
                        if (reviews.isEmpty)
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No reviews yet',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          ...reviews.map((review) => _buildReviewCard(review, isDarkMode)).toList(),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: !isOwner
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking feature coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : null,
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

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(String service, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            service,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, bool isDarkMode) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'] ?? 'Unnamed Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (service['description'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      service['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                  if (service['duration'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                      ],
                    ),
                  ],
                ],
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
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, bool isDarkMode) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isDarkMode ? AppColors.siennaLight.withOpacity(0.2) : AppColors.sienna.withOpacity(0.2),
                  child: Text(
                    (review['userName'] ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['userName'] ?? 'Anonymous',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (review['timestamp'] != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(review['timestamp']),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (review['rating'] ?? 0) ? Icons.star : Icons.star_border,
                      color: index < (review['rating'] ?? 0) ? Colors.amber : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
            if (review['comment'] != null && review['comment'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                review['comment'],
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? AppColors.sienna.withOpacity(0.2) 
                    : AppColors.sienna.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Recent';
  }
}
