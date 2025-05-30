import 'package:flutter/material.dart';
import 'package:road_saver/payment_page.dart';

class GasolineRequestPage extends StatefulWidget {
  final Map<String, dynamic> truck;
  final double userLat;
  final double userLng;

  const GasolineRequestPage({
    super.key,
    required this.truck,
    required this.userLat,
    required this.userLng,

});

@override
State<GasolineRequestPage> createState() => _GasolineRequestPageState();
}

class _GasolineRequestPageState extends State<GasolineRequestPage> with SingleTickerProviderStateMixin {
  String _selectedFuelType = '92';
  final TextEditingController _quantityController = TextEditingController();
  double _totalCost = 0.0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_calculateCost);

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

  void _calculateCost() {
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    double pricePerLiter = _selectedFuelType == '92' ? 20.0 : 23.0;
    setState(() {
      _totalCost = quantity * pricePerLiter;
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: Image.asset(
                        'assets/images/gasoline_icon.png',
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.local_gas_station,
                          color: Colors.greenAccent,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Fuel Type:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text('92 - 20 EGP/Liter'),
                        selected: _selectedFuelType == '92',
                        selectedColor: Colors.greenAccent,
                        backgroundColor: Colors.grey[900],
                        labelStyle: TextStyle(
                          color: _selectedFuelType == '92' ? Colors.black : Colors.white,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFuelType = '92';
                              _calculateCost();
                            });
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('95 - 23 EGP/Liter'),
                        selected: _selectedFuelType == '95',
                        selectedColor: Colors.greenAccent,
                        backgroundColor: Colors.grey[900],
                        labelStyle: TextStyle(
                          color: _selectedFuelType == '95' ? Colors.black : Colors.white,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFuelType = '95';
                              _calculateCost();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Number of Liters',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Cost: ${_totalCost.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_quantityController.text.isEmpty || double.tryParse(_quantityController.text) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid number of liters')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                serviceType: 'Gasoline $_selectedFuelType',
                                estimatedCost: _totalCost,
                                truck: widget.truck,
                                userLat: widget.userLat,
                                userLng: widget.userLng,
                                additionalDetails: '${_quantityController.text} Liters',
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
                          backgroundColor: Colors.grey[900],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
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
            const Positioned(
              top: 20,
              right: 16,
              child: Text(
                'Gasoline Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}