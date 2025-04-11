import 'package:flutter/material.dart';
import 'package:bike_bliss/models/bike.dart';
import 'package:bike_bliss/theme/app_theme.dart';

class BikeCard extends StatelessWidget {
  final Bike bike;

  const BikeCard({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            // Bike image
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                bike.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            
            // Bike details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bike.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            bike.type,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bike.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "• ${bike.distance} km away",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Battery level or standard bike indicator
                        if (bike.batteryLevel != null)
                          Row(
                            children: [
                              Icon(
                                Icons.battery_charging_full,
                                size: 16,
                                color: _getBatteryColor(bike.batteryLevel!),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${bike.batteryLevel}%",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _getBatteryColor(bike.batteryLevel!),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.pedal_bike,
                                size: 16,
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Standard",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        
                        // Price
                        Text(
                          "\$${bike.pricePerMinute.toStringAsFixed(2)}/min",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getBatteryColor(int level) {
    if (level > 70) {
      return Colors.green;
    } else if (level > 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
