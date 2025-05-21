import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Week', 'Month', 'Year'];
  
  // Mock data for analytics
  final Map<String, dynamic> _analyticsData = {
    'totalRevenue': 1250.75,
    'totalAppointments': 28,
    'averageRating': 4.7,
    'topService': 'Haircut',
    'revenueData': [
      {'day': 'Mon', 'revenue': 180.0},
      {'day': 'Tue', 'revenue': 220.0},
      {'day': 'Wed', 'revenue': 150.0},
      {'day': 'Thu', 'revenue': 250.0},
      {'day': 'Fri', 'revenue': 300.0},
      {'day': 'Sat', 'revenue': 350.0},
      {'day': 'Sun', 'revenue': 120.0},
    ],
    'appointmentData': [
      {'day': 'Mon', 'count': 3},
      {'day': 'Tue', 'count': 4},
      {'day': 'Wed', 'count': 2},
      {'day': 'Thu', 'count': 5},
      {'day': 'Fri', 'count': 6},
      {'day': 'Sat', 'count': 7},
      {'day': 'Sun', 'count': 1},
    ],
    'serviceDistribution': [
      {'service': 'Haircut', 'percentage': 40},
      {'service': 'Hair Coloring', 'percentage': 25},
      {'service': 'Manicure', 'percentage': 15},
      {'service': 'Facial', 'percentage': 10},
      {'service': 'Other', 'percentage': 10},
    ],
  };
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.siennaDark : AppColors.sienna,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Revenue'),
            Tab(text: 'Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                _buildPeriodSelector(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Key Metrics
                _buildSectionTitle('Key Metrics', isDarkMode),
                const SizedBox(height: 16),
                _buildKeyMetricsGrid(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Revenue Chart
                _buildSectionTitle('Revenue', isDarkMode),
                const SizedBox(height: 16),
                _buildRevenueChart(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Appointments Chart
                _buildSectionTitle('Appointments', isDarkMode),
                const SizedBox(height: 16),
                _buildAppointmentsChart(isDarkMode),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Revenue Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                _buildPeriodSelector(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Revenue Summary
                _buildSectionTitle('Revenue Summary', isDarkMode),
                const SizedBox(height: 16),
                _buildRevenueSummary(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Revenue Chart (Detailed)
                _buildSectionTitle('Revenue Trend', isDarkMode),
                const SizedBox(height: 16),
                _buildRevenueChart(isDarkMode, height: 300),
                
                const SizedBox(height: 24),
                
                // Revenue by Service
                _buildSectionTitle('Revenue by Service', isDarkMode),
                const SizedBox(height: 16),
                _buildRevenueByService(isDarkMode),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Services Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                _buildPeriodSelector(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Service Distribution
                _buildSectionTitle('Service Distribution', isDarkMode),
                const SizedBox(height: 16),
                _buildServiceDistribution(isDarkMode),
                
                const SizedBox(height: 24),
                
                // Popular Services
                _buildSectionTitle('Popular Services', isDarkMode),
                const SizedBox(height: 16),
                _buildPopularServices(isDarkMode),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Period:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              isExpanded: true,
              dropdownColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
              underline: Container(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              ),
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPeriod = newValue;
                  });
                }
              },
              items: _periods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
  
  Widget _buildKeyMetricsGrid(bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          title: 'Total Revenue',
          value: '\$${_analyticsData['totalRevenue'].toStringAsFixed(2)}',
          icon: Icons.attach_money,
          isDarkMode: isDarkMode,
        ),
        _buildMetricCard(
          title: 'Appointments',
          value: _analyticsData['totalAppointments'].toString(),
          icon: Icons.calendar_today,
          isDarkMode: isDarkMode,
        ),
        _buildMetricCard(
          title: 'Average Rating',
          value: _analyticsData['averageRating'].toString(),
          icon: Icons.star,
          isDarkMode: isDarkMode,
        ),
        _buildMetricCard(
          title: 'Top Service',
          value: _analyticsData['topService'],
          icon: Icons.spa,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
  
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRevenueChart(bool isDarkMode, {double height = 200}) {
    final List<Map<String, dynamic>> data = _analyticsData['revenueData'];
    
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.map<double>((item) => item['revenue'] as double).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: isDarkMode ? const Color(0xFF3A3A3A) : Colors.white,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${data[groupIndex]['revenue'].toStringAsFixed(2)}',
                  TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  data[value.toInt()]['day'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  '\$${value.toInt()}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item['revenue'],
                  // colors: [isDarkMode ? AppColors.siennaLight : AppColors.sienna],
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDarkMode ? Colors.white10 : Colors.black12,
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppointmentsChart(bool isDarkMode) {
    final List<Map<String, dynamic>> data = _analyticsData['appointmentData'];
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: isDarkMode ? const Color(0xFF3A3A3A) : Colors.white,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${data[spot.x.toInt()]['count']} appointments',
                    TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  data[value.toInt()]['day'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                reservedSize: 28,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDarkMode ? Colors.white10 : Colors.black12,
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false,
          ),
          minX: 0,
          maxX: data.length - 1.0,
          minY: 0,
          maxY: data.map<int>((item) => item['count'] as int).reduce((a, b) => a > b ? a : b) * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value['count'].toDouble());
              }).toList(),
              isCurved: true,
              color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                    strokeWidth: 2,
                    strokeColor: isDarkMode ? Colors.black : Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                // colors: [(isDarkMode ? AppColors.siennaLight : AppColors.sienna).withOpacity(0.2)],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildServiceDistribution(bool isDarkMode) {
    final List<Map<String, dynamic>> serviceDistribution = _analyticsData['serviceDistribution'];
    
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: serviceDistribution.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            
            // Generate a color based on the index
            final color = [
              isDarkMode ? AppColors.siennaLight : AppColors.sienna,
              isDarkMode ? Colors.blue[300] : Colors.blue[700],
              isDarkMode ? Colors.green[300] : Colors.green[700],
              isDarkMode ? Colors.purple[300] : Colors.purple[700],
              isDarkMode ? Colors.orange[300] : Colors.orange[700],
            ][index % 5];
            
            return PieChartSectionData(
              color: color,
              value: service['percentage'].toDouble(),
              title: '${service['percentage']}%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRevenueSummary(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Revenue',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  '\$${_analyticsData['totalRevenue'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Average per Day',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  '\$${(_analyticsData['totalRevenue'] / 7).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Average per Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  '\$${(_analyticsData['totalRevenue'] / _analyticsData['totalAppointments']).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRevenueByService(bool isDarkMode) {
    final List<Map<String, dynamic>> serviceDistribution = _analyticsData['serviceDistribution'];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: serviceDistribution.map((service) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        service['service'],
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: LinearProgressIndicator(
                        value: service['percentage'] / 100,
                        backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${service['percentage']}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (service != serviceDistribution.last)
                  const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
  
  Widget _buildPopularServices(bool isDarkMode) {
    final List<Map<String, dynamic>> serviceDistribution = _analyticsData['serviceDistribution'];
    
    return Column(
      children: serviceDistribution.asMap().entries.map((entry) {
        final index = entry.key;
        final service = entry.value;
        
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? AppColors.sienna.withOpacity(0.2) 
                        : AppColors.sienna.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.siennaLight : AppColors.sienna,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['service'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${service['percentage']}% of total appointments',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: isDarkMode ? Colors.green[300] : Colors.green[700],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}