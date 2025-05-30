import 'package:flutter/material.dart';
import 'package:road_saver/payment_page.dart';

class LightMaintenancePage extends StatefulWidget {
  final Map<String, dynamic> truck;
  final double userLat;
  final double userLng;

  const LightMaintenancePage({
    super.key,
    required this.truck,
    required this.userLat,
    required this.userLng,
  });

  @override
  State<LightMaintenancePage> createState() => _LightMaintenancePageState();
}

class _LightMaintenancePageState extends State<LightMaintenancePage> with SingleTickerProviderStateMixin {
  String _selectedMaintenanceType = 'Tire Repair';
  final TextEditingController _notesController = TextEditingController();
  double _estimatedCost = 100.0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _updateCost();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  void _updateCost() {
    setState(() {
      if (_selectedMaintenanceType == 'Tire Repair') {
        _estimatedCost = 100.0;
      } else if (_selectedMaintenanceType == 'Oil Change') {
        _estimatedCost = 200.0;
      } else if (_selectedMaintenanceType == 'Battery Check') {
        _estimatedCost = 150.0;
      } else if (_selectedMaintenanceType == 'Salvage Lorry') {
        _estimatedCost = 1500.0;
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Center(
                        child: Image.asset(
                          'assets/images/maintenance_icon.png',
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.build,
                            color: Colors.greenAccent,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Maintenance Type:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        ChoiceChip(
                          label: const Text('Tire Repair - 100 EGP'),
                          selected: _selectedMaintenanceType == 'Tire Repair',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: const Color(0xFF212121),
                          labelStyle: TextStyle(
                            color: _selectedMaintenanceType == 'Tire Repair' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMaintenanceType = 'Tire Repair';
                                _updateCost();
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Oil Change - 200 EGP'),
                          selected: _selectedMaintenanceType == 'Oil Change',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: const Color(0xFF212121),
                          labelStyle: TextStyle(
                            color: _selectedMaintenanceType == 'Oil Change' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMaintenanceType = 'Oil Change';
                                _updateCost();
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Battery Check - 150 EGP'),
                          selected: _selectedMaintenanceType == 'Battery Check',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: const Color(0xFF212121),
                          labelStyle: TextStyle(
                            color: _selectedMaintenanceType == 'Battery Check' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMaintenanceType = 'Battery Check';
                                _updateCost();
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Salvage Lorry - 1500 EGP'),
                          selected: _selectedMaintenanceType == 'Salvage Lorry',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: const Color(0xFF212121),
                          labelStyle: TextStyle(
                            color: _selectedMaintenanceType == 'Salvage Lorry' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMaintenanceType = 'Salvage Lorry';
                                _updateCost();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Enter Additional Notes (Optional)',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF212121),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Estimated Cost: ${_estimatedCost.toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  serviceType: _selectedMaintenanceType,
                                  estimatedCost: _estimatedCost,
                                  truck: widget.truck,
                                  userLat: widget.userLat,
                                  userLng: widget.userLng,
                                  additionalDetails: _notesController.text.isNotEmpty
                                      ? _notesController.text
                                      : 'No additional notes',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text('Confirm Request'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF212121),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
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
            const Positioned(
              top: 20,
              right: 60,
              child: Text(
                'Light Maintenance Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 16,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 30,
                  ),
                  tooltip: 'Contact Customer Support',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Contact Customer Support'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phone: +1988'),
                            SizedBox(height: 8),
                            Text('Email: support@roadsaver.com'),
                            SizedBox(height: 8),
                            Text('Available 24/7'),
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}