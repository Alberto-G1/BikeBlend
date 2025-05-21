import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;

class AppointmentManagementPage extends StatefulWidget {
  const AppointmentManagementPage({super.key});

  @override
  State<AppointmentManagementPage> createState() => _AppointmentManagementPageState();
}

class _AppointmentManagementPageState extends State<AppointmentManagementPage> {
  table_calendar.CalendarFormat _calendarFormat = table_calendar.CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  // Mock data for appointments
  final Map<DateTime, List<Map<String, dynamic>>> _appointments = {
    DateTime.now(): [
      {
        'id': '1',
        'clientName': 'Emma Johnson',
        'service': 'Hair Styling',
        'time': '10:00 AM',
        'status': 'confirmed',
      },
      {
        'id': '2',
        'clientName': 'James Wilson',
        'service': 'Beard Trim',
        'time': '2:30 PM',
        'status': 'pending',
      },
    ],
    DateTime.now().add(const Duration(days: 1)): [
      {
        'id': '3',
        'clientName': 'Sophia Williams',
        'service': 'Manicure',
        'time': '11:15 AM',
        'status': 'confirmed',
      },
    ],
    DateTime.now().add(const Duration(days: 3)): [
      {
        'id': '4',
        'clientName': 'Michael Brown',
        'service': 'Haircut',
        'time': '3:00 PM',
        'status': 'confirmed',
      },
      {
        'id': '5',
        'clientName': 'Olivia Davis',
        'service': 'Facial',
        'time': '4:30 PM',
        'status': 'pending',
      },
    ],
  };
  
  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    // Normalize the date to compare only year, month, and day
    final normalizedDay = DateTime(day.year, day.month, day.day);
    
    return _appointments.entries
        .where((entry) {
          final appointmentDate = DateTime(
            entry.key.year,
            entry.key.month,
            entry.key.day,
          );
          return appointmentDate == normalizedDay;
        })
        .expand((entry) => entry.value)
        .toList();
  }
  
  void _updateAppointmentStatus(String appointmentId, String newStatus) {
    setState(() {
      for (var entry in _appointments.entries) {
        for (var appointment in entry.value) {
          if (appointment['id'] == appointmentId) {
            appointment['status'] = newStatus;
            break;
          }
        }
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment status updated to $newStatus')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    final selectedDayAppointments = _getAppointmentsForDay(_selectedDay);
    
    return Scaffold(
      backgroundColor: isDarkMode 
          ? const Color(0xFF121212) 
          : const Color.fromARGB(255, 248, 236, 220),
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter feature coming soon')),
              );
            },
            tooltip: 'Filter Appointments',
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: table_calendar.TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return table_calendar.isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: (day) {
                return _getAppointmentsForDay(day);
              },
              calendarStyle: table_calendar.CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: isDarkMode ? AppColors.siennaLight.withOpacity(0.5) : AppColors.sienna.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
                defaultTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                weekendTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              headerStyle: table_calendar.HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                  color: isDarkMode ? AppColors.siennaLight.withOpacity(0.2) : AppColors.sienna.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                formatButtonTextStyle: TextStyle(
                  color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),

            ),
          ),
          
          // Appointments for selected day
          Expanded(
            child: selectedDayAppointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No appointments for ${DateFormat('EEEE, MMMM d').format(_selectedDay)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedDayAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = selectedDayAppointments[index];
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
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDarkMode 
                                          ? AppColors.sienna.withOpacity(0.2) 
                                          : AppColors.sienna.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appointment['clientName'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          appointment['service'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode ? Colors.white70 : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: appointment['status'] == 'confirmed'
                                          ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                                          : Colors.orange.withOpacity(isDarkMode ? 0.2 : 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      appointment['status'] == 'confirmed' ? 'Confirmed' : 'Pending',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: appointment['status'] == 'confirmed'
                                            ? Colors.green[isDarkMode ? 300 : 700]
                                            : Colors.orange[isDarkMode ? 300 : 700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    appointment['time'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDarkMode ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (appointment['status'] == 'pending')
                                    TextButton.icon(
                                      onPressed: () {
                                        _updateAppointmentStatus(appointment['id'], 'confirmed');
                                      },
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: isDarkMode ? Colors.green[300] : Colors.green[700],
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Confirm',
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.green[300] : Colors.green[700],
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                  else
                                    TextButton.icon(
                                      onPressed: () {
                                        _updateAppointmentStatus(appointment['id'], 'pending');
                                      },
                                      icon: Icon(
                                        Icons.pending_actions,
                                        color: isDarkMode ? Colors.orange[300] : Colors.orange[700],
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Mark Pending',
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.orange[300] : Colors.orange[700],
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add appointment feature coming soon')),
          );
        },
        backgroundColor: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HeaderStyle {
}

class DaysOfWeekStyle {
}
