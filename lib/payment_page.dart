import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'order_status_page.dart';

class PaymentPage extends StatefulWidget {
  final String serviceType;
  final double estimatedCost;
  final Map<String, dynamic> truck;
  final double userLat;
  final double userLng;
  final String? additionalDetails;

  const PaymentPage({
    super.key,
    required this.serviceType,
    required this.estimatedCost,
    required this.truck,
    required this.userLat,
    required this.userLng,
    this.additionalDetails,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with SingleTickerProviderStateMixin {
  String _selectedPaymentMethod = 'Visa';
  String _selectedPackage = 'None';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _walletIdController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _updateTotalCost();

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

  void _updateTotalCost() {
    setState(() {
      _totalCost = widget.estimatedCost;
      if (_selectedPackage == 'Basic') {
        _totalCost += 500.0;
      } else if (_selectedPackage == 'Premium') {
        _totalCost += 1000.0;
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _walletIdController.dispose();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Center(
                        child: Image.asset(
                          'assets/images/payment_icon.png',
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.payment,
                            color: Colors.greenAccent,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Service: ${widget.serviceType}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.additionalDetails != null)
                      Text(
                        'Details: ${widget.additionalDetails}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                        ),
                      ),
                    Text(
                      'Base Cost: ${widget.estimatedCost.toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Payment Method:',
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
                          label: const Text('Visa'),
                          selected: _selectedPaymentMethod == 'Visa',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: _selectedPaymentMethod == 'Visa' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPaymentMethod = 'Visa';
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Cash'),
                          selected: _selectedPaymentMethod == 'Cash',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: _selectedPaymentMethod == 'Cash' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPaymentMethod = 'Cash';
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Wallet'),
                          selected: _selectedPaymentMethod == 'Wallet',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: _selectedPaymentMethod == 'Wallet' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPaymentMethod = 'Wallet';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_selectedPaymentMethod == 'Visa') ...[
                      TextField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(
                          hintText: 'Card Number (16 digits)',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.grey[700],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.greenAccent, width: 1.5),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        maxLength: 19, // 16 digits + 3 spaces
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumberInputFormatter(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _expiryDateController,
                              decoration: InputDecoration(
                                hintText: 'MM/YY',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.grey[700],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.greenAccent, width: 1.5),
                                ),
                                suffixIcon: const Icon(Icons.calendar_today, color: Colors.white54),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                _ExpiryDateInputFormatter(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _cvvController,
                              decoration: InputDecoration(
                                hintText: 'CVV (3 digits)',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.grey[700],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.greenAccent, width: 1.5),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (_selectedPaymentMethod == 'Cash')
                      const Text(
                        'Note: Payment will be collected upon service completion.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                        ),
                      ),
                    if (_selectedPaymentMethod == 'Wallet')
                      TextField(
                        controller: _walletIdController,
                        decoration: InputDecoration(
                          hintText: 'Enter Wallet ID or Phone Number',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.grey[700],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.greenAccent, width: 1.5),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Monthly Package (Optional):',
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
                          label: const Text('None'),
                          selected: _selectedPackage == 'None',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: _selectedPackage == 'None' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPackage = 'None';
                                _updateTotalCost();
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Basic - 500 EGP/month'),
                          selected: _selectedPackage == 'Basic',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: _selectedPackage == 'Basic' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPackage = 'Basic';
                                _updateTotalCost();
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Premium - 1000 EGP/month'),
                          selected: _selectedPackage == 'Premium',
                          selectedColor: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: _selectedPackage == 'Premium' ? Colors.black : Colors.white,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPackage = 'Premium';
                                _updateTotalCost();
                              });
                            }
                          },
                        ),
                      ],
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            try {
                              print('Confirm Payment button pressed');
                              // التحقق من مدخلات الفيزا
                              if (_selectedPaymentMethod == 'Visa') {
                                String cardNumber = _cardNumberController.text.replaceAll(' ', '');
                                if (cardNumber.length != 16) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter a valid 16-digit card number')),
                                  );
                                  print('Invalid card number: ${_cardNumberController.text}');
                                  return;
                                }
                                // التحقق من صيغة MM/YY فقط (أي أربع أرقام مع شرطة)
                                if (!_expiryDateController.text.contains(RegExp(r'^\d{2}/\d{2}$'))) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter expiry date in MM/YY format')),
                                  );
                                  print('Invalid expiry date: ${_expiryDateController.text}');
                                  return;
                                }
                                if (_cvvController.text.length != 3) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter a valid 3-digit CVV')),
                                  );
                                  print('Invalid CVV: ${_cvvController.text}');
                                  return;
                                }
                              }
                              // التحقق من مدخلات المحفظة
                              if (_selectedPaymentMethod == 'Wallet' && _walletIdController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter a valid wallet ID or phone number')),
                                );
                                print('Empty wallet ID');
                                return;
                              }

                              // التحقق من المعلمات
                              print('Truck parameters: ${widget.truck}');
                              if (widget.truck['name'] == null ||
                                  widget.truck['name'] is! String ||
                                  widget.truck['lat'] == null ||
                                  widget.truck['lat'] is! double ||
                                  widget.truck['lng'] == null ||
                                  widget.truck['lng'] is! double ||
                                  widget.truck['baseLat'] == null ||
                                  widget.truck['baseLat'] is! double ||
                                  widget.truck['baseLng'] == null ||
                                  widget.truck['baseLng'] is! double ||
                                  widget.truck['estimatedTime'] == null ||
                                  widget.truck['estimatedTime'] is! int) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error: Invalid or missing truck information')),
                                );
                                print('Invalid truck parameters: ${widget.truck}');
                                return;
                              }

                              // تأكيد الدفع
                              print('Payment confirmed via $_selectedPaymentMethod');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Payment confirmed via $_selectedPaymentMethod${_selectedPackage != 'None' ? ' with $_selectedPackage package' : ''}!',
                                  ),
                                ),
                              );

                              // التنقل إلى OrderStatusPage
                              print('Attempting to navigate to OrderStatusPage...');
                              Future.delayed(const Duration(milliseconds: 500), () {
                                try {
                                  print('Navigating with parameters:');
                                  print('serviceType: ${widget.serviceType}');
                                  print('truckName: ${widget.truck['name']}');
                                  print('userLat: ${widget.userLat}, userLng: ${widget.userLng}');
                                  print('truckLat: ${widget.truck['lat']}, truckLng: ${widget.truck['lng']}');
                                  print('truckBaseLat: ${widget.truck['baseLat']}, truckBaseLng: ${widget.truck['baseLng']}');
                                  print('estimatedTime: ${widget.truck['estimatedTime']}');

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderStatusPage(
                                        serviceType: widget.serviceType,
                                        truckName: widget.truck['name'],
                                        userLat: widget.userLat,
                                        userLng: widget.userLng,
                                        truckLat: widget.truck['lat'],
                                        truckLng: widget.truck['lng'],
                                        truckBaseLat: widget.truck['baseLat'],
                                        truckBaseLng: widget.truck['baseLng'],
                                        estimatedTime: widget.truck['estimatedTime'],
                                      ),
                                    ),
                                  );

                                  print('Navigation to OrderStatusPage successful');
                                } catch (e, stackTrace) {
                                  print('Error navigating to OrderStatusPage: $e');
                                  print('Stack trace: $stackTrace');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error navigating to order status: $e')),
                                  );
                                }
                              });
                            } catch (e, stackTrace) {
                              print('Error in Confirm Payment: $e');
                              print('Stack trace: $stackTrace');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error processing payment: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text('Confirm Payment'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
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
                'Payment Options',
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

// TextInputFormatter لإضافة شرطة تلقائية في حقل MM/YY
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text.replaceAll('/', '');
    if (newText.length > 4) {
      newText = newText.substring(0, 4); // الحد الأقصى 4 أرقام
    }
    String formattedText = '';
    if (newText.isNotEmpty) {
      formattedText = newText.substring(0, newText.length > 2 ? 2 : newText.length);
      if (newText.length > 2) {
        formattedText += '/';
        formattedText += newText.substring(2);
      }
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// TextInputFormatter لتنسيق رقم الكارت (مسافة بعد كل 4 أرقام)
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      formatted.write(newText[i]);
      if ((i + 1) % 4 == 0 && i + 1 < newText.length) {
        formatted.write(' ');
      }
    }
    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}