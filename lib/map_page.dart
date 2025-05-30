import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:road_saver/providers/language_provider.dart';
import 'gasoline_request_page.dart';
import 'light_maintenance_page.dart';
import 'person_details_page.dart';
import 'notifications_page.dart';
import 'faq_page.dart';
import 'contact_us_page.dart';
import 'privacy_and_terms_page.dart';
import 'tesla_status_app.dart';
import 'package:road_saver/localizations/app_localizations.dart';

class MapPage extends StatefulWidget {
    const MapPage({super.key});

    @override
    State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
    final List<Map<String, dynamic>> _chargingTrucks = [
        {
            'name': 'Truck #1 - Nearby Area 1',
            'lat': 0.0,
            'lng': 0.0,
            'baseLat': 0.0,
            'baseLng': 0.0,
            'estimatedTime': 10,
            'serviceType': 'Electric Charging',
        },
        {
            'name': 'Truck #2 - Nearby Area 2',
            'lat': 0.0,
            'lng': 0.0,
            'baseLat': 0.0,
            'baseLng': 0.0,
            'estimatedTime': 15,
            'serviceType': 'Gasoline',
        },
    ];

    List<Map<String, dynamic>> _gasStations = [];
    latlng.LatLng? _userLocation;
    MapController? _mapController;
    late AnimationController _truckMovementController;
    double _movementAngle = 0.0;
    final TextEditingController _locationController = TextEditingController();
    String _selectedService = 'Select Service';
    final List<String> _services = [
        'Select Service',
        'Electric Charging',
        'Gasoline',
        'Light Maintenance'
    ];
    List<Map<String, dynamic>> _sortedTrucks = [];
    final math.Random _random = math.Random();
    final List<String> _gasStationNames = ['Misr', 'Chillout', 'Total'];

    @override
    void initState() {
        super.initState();
        print('MapPage initState called');
        if (FirebaseAuth.instance.currentUser == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
            });
            return;
        }
        _mapController = MapController();

        _truckMovementController = AnimationController(
            duration: const Duration(seconds: 10),
            vsync: this,
        )..repeat();

        _truckMovementController.addListener(() {
            setState(() {
                _movementAngle = _truckMovementController.value * 2 * math.pi;
                for (var truck in _chargingTrucks) {
                    const radius = 0.001;
                    truck['lat'] = truck['baseLat'] + radius * math.cos(_movementAngle);
                    truck['lng'] = truck['baseLng'] +radius * math.sin(_movementAngle);
                }
                _sortTrucksByDistance();
            });
        });

        _getCurrentLocation();
    }

    Future<String> _getCarType() async {
        final user = FirebaseAuth.instance.currentUser;
        print('Fetching car type for user: ${user?.uid}');
        if (user == null) {
            print('No user logged in');
            return 'No user logged in';
        }

        try {
            DocumentSnapshot doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get()
                .timeout(const Duration(seconds: 5), onTimeout: () {
                print('Firestore query timed out after 5 seconds');
                throw Exception('Firestore timeout');
            });

            if (!doc.exists) {
                print('No document found for user ${user.uid}');
                return 'No car data available';
            }

            final data = doc.data() as Map<String, dynamic>?;
            print('Firestore data for user ${user.uid}: $data');
            if (data == null) {
                print('No data in document for user ${user.uid}');
                return 'No car data available';
            }

            String? carType = data['car_type'] ?? data['carName'] ?? data['car_model'];
            if (carType == null || carType.isEmpty) {
                print('No car type found in document');
                return 'Unknown car';
            }

            if (carType.toLowerCase().contains('tesla') ||
                carType.toLowerCase().contains('electric')) {
                print('Car type identified as Electric: $carType');
                return 'Electric';
            } else {
                print('Car type identified as Gasoline: $carType');
                return 'Gasoline';
            }
        } catch (e) {
            print('Error fetching car type: $e');
            return 'Error fetching data: $e';
        }
    }

    Future<void> _getCurrentLocation() async {
        print('Getting current location...');
        bool serviceEnabled;
        LocationPermission permission;

        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
            bool opened = await Geolocator.openLocationSettings();
            if (!opened) {
                setState(() {
                    _locationController.text = 'Please enable location services from device settings';
                });
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: const Text('Location Services Disabled'),
                        content: const Text('Please enable location services from device settings and try again.'),
                        actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                            ),
                        ],
                    ),
                );
                return;
            }
            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
                setState(() {
                    _locationController.text = 'Failed to enable location services';
                });
                return;
            }
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
                setState(() {
                    _locationController.text = 'Location permission denied';
                });
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: const Text('Location Permission Denied'),
                        content: const Text('Please allow location permission from app settings.'),
                        actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                            ),
                        ],
                    ),
                );
                return;
            }
        }

        if (permission == LocationPermission.deniedForever) {
            setState(() {
                _locationController.text = 'Location permission permanently denied';
            });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: const Text('Location Permission Permanently Denied'),
                    content: const Text('Please allow location permission from device settings.'),
                    actions: [
                        TextButton(
                            onPressed: () async {
                                await Geolocator.openAppSettings();
                                Navigator.pop(context);
                            },
                            child: const Text('Open Settings'),
                        ),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                        ),
                    ],
                ),
            );
            return;
        }

        try {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
            );

            setState(() {
                _userLocation = latlng.LatLng(position.latitude, position.longitude);
                print('User location: ${_userLocation!.latitude}, ${_userLocation!.longitude}');

                _chargingTrucks[0]['lat'] = position.latitude + 0.005;
                _chargingTrucks[0]['lng'] = position.longitude + 0.005;
                _chargingTrucks[0]['baseLat'] = position.latitude + 0.005;
                _chargingTrucks[0]['baseLng'] = position.longitude + 0.005;

                _chargingTrucks[1]['lat'] = position.latitude - 0.005;
                _chargingTrucks[1]['lng'] = position.longitude - 0.005;
                _chargingTrucks[1]['baseLat'] = position.latitude - 0.005;
                _chargingTrucks[1]['baseLng'] = position.longitude - 0.005;

                _sortTrucksByDistance();
                _locationController.text = 'Current User Location';
            });

            if (_mapController != null && _userLocation != null) {
                _mapController!.move(_userLocation!, 14.0);
                await _fetchGasStations();
            }
        } catch (e) {
            print('Error fetching location: $e');
            setState(() {
                _locationController.text = 'Error fetching location: $e';
            });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('An error occurred while fetching location. Please try again.'),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                        ),
                    ],
                ),
            );
        }
    }

    Future<void> _fetchGasStations() async {
        print('Fetching gas stations...');
        if (_userLocation == null) return;

        final query = '''
      [out:json];
      node["amenity"="fuel"](around:10000,${_userLocation!.latitude},${_userLocation!.longitude});
      out body;
    ''';
        final url = Uri.parse('https://overpass-api.de/api/interpreter');

        try {
            final response = await http.post(url, body: query);
            if (response.statusCode == 200) {
                final data = json.decode(response.body);
                final elements = data['elements'] as List<dynamic>;

                setState(() {
                    _gasStations = elements.map((e) {
                        return {
                            'name': _gasStationNames[_random.nextInt(_gasStationNames.length)],
                            'lat': e['lat'] as double,
                            'lng': e['lon'] as double,
                            'hasRoadSaverCharging': _random.nextBool(),
                        };
                    }).toList();
                    print('Fetched gas stations: ${_gasStations.length}');
                    if (_gasStations.isNotEmpty) {
                        print('First gas station: ${_gasStations[0]}');
                    }
                });
            } else {
                print('Failed to fetch gas stations: ${response.statusCode}');
                setState(() {
                    _gasStations = [
                        {
                            'name': _gasStationNames[_random.nextInt(_gasStationNames.length)],
                            'lat': _userLocation!.latitude + 0.003,
                            'lng': _userLocation!.longitude + 0.003,
                            'hasRoadSaverCharging': _random.nextBool(),
                        }
                    ];
                    print('Added test gas station: ${_gasStations[0]}');
                });
            }
        } catch (e) {
            print('Error fetching gas stations: $e');
            setState(() {
                _gasStations = [
                    {
                        'name': _gasStationNames[_random.nextInt(_gasStationNames.length)],
                        'lat': _userLocation!.latitude + 0.003,
                        'lng': _userLocation!.longitude + 0.003,
                        'hasRoadSaverCharging': _random.nextBool(),
                    }
                ];
                print('Added test gas station: ${_gasStations[0]}');
            });
        }
    }

    void _sortTrucksByDistance() {
        if (_userLocation == null) {
            _sortedTrucks = List.from(_chargingTrucks);
            return;
        }

        _sortedTrucks = List.from(_chargingTrucks);
        _sortedTrucks.sort((a, b) {
            double distanceA = Geolocator.distanceBetween(
                _userLocation!.latitude,
                _userLocation!.longitude,
                a['lat'],
                a['lng'],
            );
            double distanceB = Geolocator.distanceBetween(
                _userLocation!.latitude,
                _userLocation!.longitude,
                b['lat'],
                b['lng'],
            );
            return distanceA.compareTo(distanceB);
        });
    }

    void _showGasStationInfo(Map<String, dynamic> station) {
        if (_userLocation == null) return;

        double distance = Geolocator.distanceBetween(
            _userLocation!.latitude,
            _userLocation!.longitude,
            station['lat'],
            station['lng'],
        ) / 1000;

        const double averageSpeedKmh = 40.0;
        double timeHours = distance / averageSpeedKmh;
        int timeMinutes = (timeHours * 60).ceil();

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(station['name']),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text('RoadSaver Charging: ${station['hasRoadSaverCharging'] ? 'Available' : 'Not Available'}'),
                        Text('Distance: ${distance.toStringAsFixed(2)} km'),
                        Text('Estimated Time: $timeMinutes minutes'),
                    ],
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                    ),
                ],
            ),
        );
    }

    Widget _getServiceImage() {
        switch (_selectedService) {
            case 'Electric Charging':
                return Image.asset(
                    'assets/images/electric_icon.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.battery_charging_full,
                        color: Colors.greenAccent,
                        size: 50,
                    ),
                );
            case 'Gasoline':
                return Image.asset(
                    'assets/images/gasoline_icon.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_gas_station,
                        color: Colors.greenAccent,
                        size: 50,
                    ),
                );
            case 'Light Maintenance':
                return Image.asset(
                    'assets/images/maintenance_icon.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.build,
                        color: Colors.greenAccent,
                        size: 50,
                    ),
                );
            default:
                return Image.asset(
                    'assets/images/default_car_icon.png',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.directions_car,
                        color: Colors.greenAccent,
                        size: 50,
                    ),
                );
        }
    }

    void _handleMenuSelection(String value) {
        print('Menu item selected: $value');
        switch (value) {
            case 'personal_details':
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonDetailsPage(userId: user.uid),
                        ),
                    );
                } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text('You are not logged in. Please log in again.'),
                            actions: [
                                TextButton(
                                    onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    child: const Text('OK'),
                                ),
                            ],
                        ),
                    );
                }
                break;
            case 'notifications':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                    ),
                );
                break;
            case 'faq':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FaqPage(),
                    ),
                );
                break;
            case 'contact_us':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsPage(),
                    ),
                );
                break;
            case 'privacy_terms':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyAndTermsPage(),
                    ),
                );
                break;
            case 'logout':
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
                break;
        }
    }

    void _requestService(Map<String, dynamic> truck) {
        final localizations = AppLocalizations.of(context);
        
        if (_selectedService == localizations.get('select_service')) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text(localizations.get('error')),
                    content: Text(localizations.get('please_select_service')),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(localizations.get('ok')),
                        ),
                    ],
                ),
            );
            return;
        }

        if (_userLocation == null) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text(localizations.get('error')),
                    content: Text(localizations.get('location_not_found')),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(localizations.get('ok')),
                        ),
                    ],
                ),
            );
            return;
        }

        if (_selectedService == localizations.get('gasoline')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GasolineRequestPage(
                        truck: truck,
                        userLat: _userLocation!.latitude,
                        userLng: _userLocation!.longitude,
                    ),
                ),
            );
        } else if (_selectedService == localizations.get('light_maintenance')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LightMaintenancePage(
                        truck: truck,
                        userLat: _userLocation!.latitude,
                        userLng: _userLocation!.longitude,
                    ),
                ),
            );
        } else if (_selectedService == localizations.get('electric_charging')) {
            if (truck['name'] == null ||
                truck['lat'] == null ||
                truck['lng'] == null ||
                truck['baseLat'] == null ||
                truck['baseLng'] == null ||
                truck['estimatedTime'] == null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text(localizations.get('error')),
                        content: Text(localizations.get('invalid_truck_info')),
                        actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(localizations.get('ok')),
                            ),
                        ],
                    ),
                );
                return;
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TeslaStatusPage(),
                    settings: RouteSettings(
                        arguments: _selectedService,
                    ),
                ),
            );
        } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text(localizations.get('error')),
                    content: Text(localizations.get('invalid_service')),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(localizations.get('ok')),
                        ),
                    ],
                ),
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        final localizations = AppLocalizations.of(context);
        final isArabic = Provider.of<LanguageProvider>(context).locale.languageCode == 'ar';
        
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                    },
                ),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => Navigator.pushNamed(context, '/settings'),
                    ),
                    PopupMenuButton<String>(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onSelected: _handleMenuSelection,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                                value: 'personal_details',
                                child: Row(
                                    children: [
                                        const Icon(Icons.person, color: Colors.greenAccent),
                                        const SizedBox(width: 8),
                                        Text(localizations.get('personal_details')),
                                    ],
                                ),
                            ),
                            PopupMenuItem<String>(
                                value: 'notifications',
                                child: Row(
                                    children: [
                                        const Icon(Icons.notifications, color: Colors.greenAccent),
                                        const SizedBox(width: 8),
                                        Text(localizations.get('notifications')),
                                    ],
                                ),
                            ),
                            PopupMenuItem<String>(
                                value: 'faq',
                                child: Row(
                                    children: [
                                        const Icon(Icons.help, color: Colors.greenAccent),
                                        const SizedBox(width: 8),
                                        Text(localizations.get('faq')),
                                    ],
                                ),
                            ),
                            PopupMenuItem<String>(
                                value: 'contact_us',
                                child: Row(
                                    children: [
                                        const Icon(Icons.message, color: Colors.greenAccent),
                                        const SizedBox(width: 8),
                                        Text(localizations.get('contact_us')),
                                    ],
                                ),
                            ),
                            PopupMenuItem<String>(
                                value: 'privacy_terms',
                                child: Row(
                                    children: [
                                        const Icon(Icons.lock, color: Colors.greenAccent),
                                        const SizedBox(width: 8),
                                        Text(localizations.get('privacy_terms')),
                                    ],
                                ),
                            ),
                            PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                    children: [
                                        const Icon(Icons.logout, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(localizations.get('logout')),
                                    ],
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body: Stack(
                children: [
                    FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                            initialCenter: _userLocation ?? latlng.LatLng(29.9773, 30.9456),
                            initialZoom: 13.0,
                        ),
                        children: [
                            TileLayer(
                                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                errorTileCallback: (tile, error, stackTrace) {
                                    print('Error loading map tile: $error');
                                },
                            ),
                            MarkerLayer(
                                markers: [
                                    if (_userLocation != null)
                                        Marker(
                                            width: 40.0,
                                            height: 40.0,
                                            point: _userLocation!,
                                            child: Image.asset(
                                                'assets/images/user_location_icon.png',
                                                width: 40,
                                                height: 40,
                                                errorBuilder: (context, error, stackTrace) {
                                                    print;'sError loading user_location_icon.png: $error';
                                                    return const Icon(
                                                    Icons.location_pin,
                                                    color: Colors.red,
                                                    size: 40,
                                                    );
                                                },
                                            ),
                                        ),
                                    ..._chargingTrucks.map((truck) {
                                        return Marker(
                                            width: 40.0,
                                            height: 40.0,
                                            point: latlng.LatLng(truck['lat'], truck['lng']),
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
                                        );
                                    }),
                                    ..._gasStations.map((station) {
                                        return Marker(
                                            width: 40.0,
                                            height: 40.0,
                                            point: latlng.LatLng(station['lat'], station['lng']),
                                            child: GestureDetector(
                                                onTap: () => _showGasStationInfo(station),
                                                child: Image.asset(
                                                    'assets/images/gas_station_icon.png',
                                                    width: 40,
                                                    height: 40,
                                                    errorBuilder: (context, error, stackTrace) {
                                                        print('Error loading gas_station_icon.png: $error');
                                                        return const Icon(
                                                            Icons.local_gas_station,
                                                            color: Colors.yellow,
                                                            size: 40,
                                                        );
                                                    },
                                                ),
                                            ),
                                        );
                                    }),
                                    if (_userLocation != null)
                                        Marker(
                                            width: 40.0,
                                            height: 40.0,
                                            point: latlng.LatLng(
                                                _userLocation!.latitude + 0.002,
                                                _userLocation!.longitude + 0.002,
                                            ),
                                            child: const Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                                size: 40,
                                            ),
                                        ),
                                ],
                            ),
                        ],
                    ),
                    Positioned(
                        bottom: 1,
                        left: 0,
                        right: 0,
                        child: Container(
                            height: 450,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 5,
                                    ),
                                ],
                            ),
                            child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Row(
                                                children: [
                                                    Expanded(
                                                        child: FutureBuilder<DocumentSnapshot>(
                                                            future: FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                                                .get(),
                                                            builder: (context, snapshot) {
                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                    return Text(
                                                                        localizations.get('loading'),
                                                                        style: const TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold,
                                                                        ),
                                                                    );
                                                                } else if (snapshot.hasError) {
                                                                    return Text(
                                                                        localizations.get('error_loading_car'),
                                                                        style: const TextStyle(
                                                                            color: Colors.red,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold,
                                                                        ),
                                                                    );
                                                                } else if (snapshot.hasData && snapshot.data != null) {
                                                                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                                                                    String carName = data?['carName'] ?? data?['car_name'] ?? '';
                                                                    String carModel = data?['car_model'] ?? '';
                                                                    String displayText = '';
                                                                    
                                                                    if (carName.isNotEmpty && carModel.isNotEmpty) {
                                                                        displayText = '$carName - $carModel';
                                                                    } else if (carName.isNotEmpty) {
                                                                        displayText = carName;
                                                                    } else if (carModel.isNotEmpty) {
                                                                        displayText = carModel;
                                                                } else {
                                                                        displayText = localizations.get('unknown_car');
                                                                    }
                                                                    
                                                                    return Text(
                                                                        displayText,
                                                                        style: const TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold,
                                                                        ),
                                                                    );
                                                                } else {
                                                                    return Text(
                                                                        localizations.get('unknown_car'),
                                                                        style: const TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold,
                                                                        ),
                                                                    );
                                                                }
                                                            },
                                                        ),
                                                    ),
                                                    _getServiceImage(),
                                                ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                                children: [
                                                    const Icon(Icons.ev_station, color: Colors.greenAccent),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        localizations.get('charging_trucks'),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                            const SizedBox(height: 8),
                                            DropdownButton<String>(
                                                value: _selectedService,
                                                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                                                dropdownColor: Colors.white,
                                                style: const TextStyle(color: Colors.black),
                                                underline: Container(
                                                    height: 2,
                                                    color: Colors.greenAccent,
                                                ),
                                                onChanged: (String? newValue) {
                                                    setState(() {
                                                        _selectedService = newValue!;
                                                        if (_selectedService != localizations.get('select_service')) {
                                                            Fluttertoast.showToast(
                                                                msg: '${localizations.get('selected')}: $_selectedService',
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.BOTTOM,
                                                                backgroundColor: Colors.greenAccent,
                                                                textColor: Colors.black,
                                                                fontSize: 16.0,
                                                            );
                                                        }
                                                    });
                                                },
                                                items: [
                                                    localizations.get('select_service'),
                                                    localizations.get('electric_charging'),
                                                    localizations.get('gasoline'),
                                                    localizations.get('light_maintenance'),
                                                ].map<DropdownMenuItem<String>>((String value) {
                                                    IconData icon;
                                                    if (value == localizations.get('electric_charging')) {
                                                        icon = Icons.battery_charging_full;
                                                    } else if (value == localizations.get('gasoline')) {
                                                        icon = Icons.local_gas_station;
                                                    } else if (value == localizations.get('light_maintenance')) {
                                                        icon = Icons.build;
                                                    } else {
                                                        icon = Icons.list;
                                                    }
                                                    
                                                    return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Row(
                                                            children: [
                                                                Icon(icon, color: Colors.greenAccent, size: 20),
                                                                const SizedBox(width: 8),
                                                                Text(value),
                                                            ],
                                                        ),
                                                    );
                                                }).toList(),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                                controller: _locationController,
                                                decoration: InputDecoration(
                                                    hintText: localizations.get('enter_location'),
                                                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                                                    filled: true,
                                                    fillColor: Colors.grey[100],
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide.none,
                                                    ),
                                                    suffixIcon: IconButton(
                                                        icon: const Icon(Icons.gps_fixed, color: Colors.greenAccent),
                                                        onPressed: () => _getCurrentLocation(),
                                                    ),
                                                    prefixIcon: const Icon(Icons.location_on, color: Colors.greenAccent),
                                                ),
                                                style: const TextStyle(color: Colors.black),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                                localizations.get('available_trucks'),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                                height: 100,
                                                child: _sortedTrucks.isEmpty
                                                    ? Center(
                                                    child: Text(
                                                            localizations.get('no_trucks_available'),
                                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                                    ),
                                                )
                                                    : ListView.builder(
                                                    itemCount: _sortedTrucks.length,
                                                    itemBuilder: (context, index) {
                                                        final truck = _sortedTrucks[index];
                                                        double distance = _userLocation != null
                                                            ? Geolocator.distanceBetween(
                                                            _userLocation!.latitude,
                                                            _userLocation!.longitude,
                                                            truck['lat'],
                                                            truck['lng'],
                                                                ) / 1000
                                                            : 0.0;
                                                        return Row(
                                                            children: [
                                                                    const Icon(Icons.location_pin, color: Colors.black54),
                                                                const SizedBox(width: 8),
                                                                Expanded(
                                                                    child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                            Text(
                                                                                truck['name'],
                                                                                    style: const TextStyle(color: Colors.black87),
                                                                            ),
                                                                            Text(
                                                                                    '${localizations.get('service_type')}: ${truck['serviceType']} | ${localizations.get('distance')}: ${distance.toStringAsFixed(2)} km',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black.withOpacity(0.6),
                                                                                    fontSize: 12,
                                                                                ),
                                                                            ),
                                                                        ],
                                                                    ),
                                                                ),
                                                                Row(
                                                                    children: [
                                                                        Text(
                                                                                '${localizations.get('request')} ${localizations.get('in')} ${truck['estimatedTime']} ${localizations.get('minutes')}',
                                                                                style: const TextStyle(color: Colors.black87),
                                                                            ),
                                                                            const SizedBox(width: 8),
                                                                            ElevatedButton(
                                                                                onPressed: () => _requestService(truck),
                                                                                style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.greenAccent,
                                                                                    foregroundColor: Colors.black,
                                                                                ),
                                                                                child: Text(localizations.get('request')),
                                                                            ),
                                                                        ],
                                                                    ),
                                                                ],
                                                            );
                                                        },
                                                                            ),
                                                                        ),
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

    @override
    void dispose() {
        print('MapPage dispose called');
        _mapController?.dispose();
        _truckMovementController.dispose();
        _locationController.dispose();
        super.dispose();
    }
}