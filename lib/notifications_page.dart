import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Payment Confirmed',
      'description': 'Your payment of 300 EGP for Electric Charging was successful.',
      'icon': Icons.payment,
      'time': '2 minutes ago',
    },
    {
      'id': 2,
      'title': 'Service Requested',
      'description': 'Your Gasoline request has been received. Truck #2 is on the way.',
      'icon': Icons.directions_car,
      'time': '10 minutes ago',
    },
    {
      'id': 3,
      'title': 'Maintenance Completed',
      'description': 'Light Maintenance (Tire Repair) has been completed.',
      'icon': Icons.build,
      'time': '1 hour ago',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Setup animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward(); // Start animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _removeNotification(int id) {
    setState(() {
      _notifications.removeWhere((notification) => notification['id'] == id);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Space for text and image
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: Image.asset(
                        'assets/images/notification_icon.png',
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.notifications,
                          color: Colors.greenAccent,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_notifications.isNotEmpty)
                        TextButton(
                          onPressed: _clearAllNotifications,
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _notifications.isEmpty
                        ? const Center(
                      child: Text(
                        'No notifications available',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Card(
                            color: Colors.grey[800],
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Icon(
                                notification['icon'],
                                color: Colors.greenAccent,
                                size: 40,
                              ),
                              title: Text(
                                notification['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification['description'],
                                    style: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification['time'],
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeNotification(notification['id']),
                              ),
                              onTap: () {
                                // Add action for tapping notification (e.g., navigate to details)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tapped on ${notification['title']}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}