import 'package:flutter/material.dart';
import 'package:veloce/models/bike.dart';
import 'package:veloce/screens/bike_details_screen.dart';

class BikesScreen extends StatefulWidget {
  const BikesScreen({super.key});

  @override
  State<BikesScreen> createState() => _BikesScreenState();
}

class _BikesScreenState extends State<BikesScreen> {
  late List<Bike> bikes;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBikes();
  }

  Future<void> _loadBikes() async {
    // Simulate loading data from an API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      bikes = [
        Bike(
          id: '1',
          name: 'Mountain Explorer',
          modelType: 'Mountain',
          code: 'MTB-2023-X1',
          description:
              'A high-performance mountain bike designed for rough terrains and steep trails. Features advanced suspension and durable frame for the ultimate off-road experience.',
          rating: 4.8,
          likes: 243,
          price: 1299.99,
          imageUrl:
              'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91',
          features: [
            'Advanced suspension system',
            'Lightweight aluminum frame',
            'Hydraulic disc brakes',
            '21-speed gear system',
            'All-terrain tires',
          ],
          specifications: [
            'Weight: 12.5 kg',
            'Frame Size: M, L, XL',
            'Wheel Size: 29 inches',
            'Frame Material: Aluminum Alloy',
            'Suspension Travel: 120mm',
          ],
        ),
        Bike(
          id: '2',
          name: 'City Cruiser',
          modelType: 'Urban',
          code: 'URB-2023-C2',
          description:
              'The perfect companion for city commuting. Comfortable, stylish, and efficient with features designed for urban environments.',
          rating: 4.5,
          likes: 187,
          price: 899.99,
          imageUrl:
              'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7',
          features: [
            'Upright riding position',
            'Integrated front basket',
            'Puncture-resistant tires',
            'Built-in lights',
            'Fenders and chain guard',
          ],
          specifications: [
            'Weight: 14 kg',
            'Frame Size: S, M, L',
            'Wheel Size: 28 inches',
            'Frame Material: Steel',
            'Gears: 7-speed',
          ],
        ),
        Bike(
          id: '3',
          name: 'Road Master',
          modelType: 'Road',
          code: 'RD-2023-R3',
          description:
              'Engineered for speed and efficiency on paved roads. Aerodynamic design and lightweight construction make this bike perfect for long-distance rides and racing.',
          rating: 4.9,
          likes: 312,
          price: 1599.99,
          imageUrl:
              'https://images.unsplash.com/photo-1485965120184-e220f721d03e',
          features: [
            'Carbon fiber frame',
            'Aerodynamic design',
            'Drop handlebars',
            'Ultra-lightweight construction',
            'Professional racing tires',
          ],
          specifications: [
            'Weight: 8.2 kg',
            'Frame Size: S, M, L, XL',
            'Wheel Size: 700c',
            'Frame Material: Carbon Fiber',
            'Gears: 22-speed',
          ],
        ),
        Bike(
          id: '4',
          name: 'Electric Voyager',
          modelType: 'Electric',
          code: 'EL-2023-E4',
          description:
              'Experience the future of cycling with this electric-assist bike. Powerful motor and long-lasting battery make every ride effortless and enjoyable.',
          rating: 4.7,
          likes: 276,
          price: 2199.99,
          imageUrl:
              'https://images.unsplash.com/photo-1571068316344-75bc76f77890',
          features: [
            '500W electric motor',
            '50km range per charge',
            'Removable battery',
            'LCD display',
            'Integrated lights and horn',
          ],
          specifications: [
            'Weight: 22 kg',
            'Frame Size: M, L',
            'Wheel Size: 27.5 inches',
            'Battery: 48V 10.4Ah',
            'Max Speed: 25 km/h',
          ],
        ),
        Bike(
          id: '5',
          name: 'Hybrid Pathfinder',
          modelType: 'Hybrid',
          code: 'HYB-2023-H5',
          description:
              'The versatile all-rounder that performs well on various terrains. Perfect for riders who want a single bike for multiple purposes.',
          rating: 4.6,
          likes: 198,
          price: 1099.99,
          imageUrl:
              'https://images.unsplash.com/photo-1507035895480-2b3156c31fc8',
          features: [
            'Versatile design',
            'Front suspension',
            'Ergonomic grips',
            'Wide gear range',
            'Quick-release wheels',
          ],
          specifications: [
            'Weight: 11.8 kg',
            'Frame Size: S, M, L, XL',
            'Wheel Size: 700c',
            'Frame Material: Aluminum',
            'Gears: 18-speed',
          ],
        ),
        Bike(
          id: '6',
          name: 'Folding Commuter',
          modelType: 'Folding',
          code: 'FLD-2023-F6',
          description:
              'Compact and convenient, this folding bike is ideal for mixed-mode commuting and storage in small spaces. Unfolds in seconds for an instant ride.',
          rating: 4.4,
          likes: 156,
          price: 799.99,
          imageUrl:
              'https://images.unsplash.com/photo-1593764592116-bfb2a97c642a',
          features: [
            'Folds in 10 seconds',
            'Compact storage size',
            'Carrying handle',
            'Adjustable components',
            'Includes storage bag',
          ],
          specifications: [
            'Weight: 10.5 kg',
            'Folded Size: 65 x 30 x 60 cm',
            'Wheel Size: 20 inches',
            'Frame Material: Aluminum Alloy',
            'Gears: 6-speed',
          ],
        ),
      ];
      _isLoading = false;
    });
  }

  List<Bike> get filteredBikes {
    return bikes.where((bike) {
      final matchesSearch =
          bike.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          bike.modelType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          bike.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter =
          _selectedFilter == 'All' || bike.modelType == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<String> get bikeTypes {
    final types = bikes.map((bike) => bike.modelType).toSet().toList();
    types.sort();
    return ['All', ...types];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bikes"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
              : Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search bikes...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.black12 : Colors.white,
                      ),
                    ),
                  ),

                  // Filter chips
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children:
                          bikeTypes.map((type) {
                            final isSelected = _selectedFilter == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(type),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = type;
                                  });
                                },
                                backgroundColor:
                                    isDark ? Colors.black12 : Colors.white,
                                selectedColor: theme.colorScheme.primary
                                    .withOpacity(0.2),
                                checkmarkColor: theme.colorScheme.primary,
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? theme.colorScheme.primary
                                          : isDark
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color:
                                        isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.primary
                                                .withOpacity(0.3),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  // Bikes grid
                  Expanded(
                    child:
                        filteredBikes.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pedal_bike_outlined,
                                    size: 80,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No bikes found",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Try adjusting your search or filters",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color:
                                          isDark
                                              ? Colors.white54
                                              : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: filteredBikes.length,
                              itemBuilder: (context, index) {
                                final bike = filteredBikes[index];
                                return _buildBikeCard(bike, context);
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to scan page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Navigate to Scan Page'),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text("Scan & Ride"),
      ),
    );
  }

  Widget _buildBikeCard(Bike bike, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BikeDetailsScreen(bike: bike),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike image with model type badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    bike.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: isDark ? Colors.black26 : Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: isDark ? Colors.black26 : Colors.grey[200],
                        child: Icon(
                          Icons.pedal_bike,
                          size: 50,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bike.modelType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bike name
                  Text(
                    bike.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Bike code
                  Text(
                    bike.code,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Rating and likes
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        bike.rating.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.favorite, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        bike.likes.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    "\$${bike.price.toStringAsFixed(2)}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Bikes",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Bike Type",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        bikeTypes.map((type) {
                          final isSelected = _selectedFilter == type;
                          return ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                this.setState(() {
                                  _selectedFilter = type;
                                });
                              });
                            },
                            backgroundColor:
                                isDark ? Colors.black12 : Colors.white,
                            selectedColor: theme.colorScheme.primary
                                .withOpacity(0.2),
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? theme.colorScheme.primary
                                      : isDark
                                      ? Colors.white
                                      : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
