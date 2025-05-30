import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'dart:math' as math;
import 'contact_us_page.dart';

class OrderStatusPage extends StatefulWidget {
  final String serviceType;
  final String truckName;
  final double userLat;
  final double userLng;
  final double truckLat;
  final double truckLng;
  final double truckBaseLat;
  final double truckBaseLng;
  final int estimatedTime;

  const OrderStatusPage({
    super.key,
    required this.serviceType,
    required this.truckName,
    required this.userLat,
    required this.userLng,
    required this.truckLat,
    required this.truckLng,
    required this.truckBaseLat,
    required this.truckBaseLng,
    required this.estimatedTime,
  });

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> with TickerProviderStateMixin {
  late AnimationController _truckMovementController;
  double _movementAngle = 0.0;
  late double _currentTruckLat;
  late double _currentTruckLng;

  @override
  void initState() {
    super.initState();
    debugPrint('OrderStatusPage initState called');
    debugPrint('Parameters: serviceType=${widget.serviceType}, truckName=${widget.truckName}, '
        'userLat=${widget.userLat}, userLng=${widget.userLng}, '
        'truckLat=${widget.truckLat}, truckLng=${widget.truckLng}, '
        'truckBaseLat=${widget.truckBaseLat}, truckBaseLng=${widget.truckBaseLng}, '
        'estimatedTime=${widget.estimatedTime}');

    _currentTruckLat = widget.truckLat;
    _currentTruckLng = widget.truckLng;

    _truckMovementController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _truckMovementController.addListener(() {
      setState(() {
        _movementAngle = _truckMovementController.value * 2 * math.pi;
        const radius = 0.001;
        _currentTruckLat = widget.truckBaseLat + radius * math.cos(_movementAngle);
        _currentTruckLng = widget.truckBaseLng + radius * math.sin(_movementAngle);
      });
    });
  }

  @override
  void dispose() {
    debugPrint('OrderStatusPage dispose called');
    _truckMovementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('OrderStatusPage build called');
    try {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Order Status',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/status_icon.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading status_icon.png: $error');
                        return const Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                          size: 80,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Order Confirmed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your ${widget.serviceType} request has been confirmed.',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: const Icon(Icons.directions_car, color: Colors.greenAccent),
                      title: const Text(
                        'Truck',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        widget.truckName,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.greenAccent),
                      title: const Text(
                        'Location',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Lat: ${widget.userLat.toStringAsFixed(4)}, Lng: ${widget.userLng.toStringAsFixed(4)}',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: const Icon(Icons.timer, color: Colors.greenAccent),
                      title: const Text(
                        'Estimated Arrival',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${widget.estimatedTime} minutes',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Order Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.33, // تمثل حالة "Confirmed" (مثال)
                    backgroundColor: Colors.grey[900],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Status: Confirmed',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Truck Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: latlng.LatLng(widget.userLat, widget.userLng),
                        initialZoom: 15.0,
                        interactionOptions: const InteractionOptions(
                          flags: 0, // تعطيل التفاعل (Zoom, Pan)
                        )
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          errorTileCallback: (tile, error, stackTrace) {
                            debugPrint('Error loading map tile: $error');
                          },
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: latlng.LatLng(widget.userLat, widget.userLng),
                              child: Image.asset(
                                'assets/images/user_location_icon.png',
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint('Error loading user_location_icon.png: $error');
                                  return const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: latlng.LatLng(_currentTruckLat, _currentTruckLng),
                              child: Image.asset(
                                'assets/images/truck_icon.png',
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading truck_icon.png: $error');
                                  return const Icon(
                                    Icons.directions_car,
                                    color: Colors.greenAccent,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Cancel Order button pressed');
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cancel Order'),
                            content: const Text('Are you sure you want to cancel this order?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  print('Order cancelled for ${widget.truckName}');
                                  Navigator.pop(context);
                                  Navigator.pop(context); // رجوع لـ MapPage
                                },
                                child: const Text('Yes'),
                              ),


                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Contact Support button pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactUsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in OrderStatusPage build: $e');
      print('Stack trace: $stackTrace');
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Error loading order status: $e',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }
  }
}