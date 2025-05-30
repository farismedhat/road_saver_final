import 'package:flutter/material.dart';

class PersonalDetailsPage extends StatefulWidget {
  final String userId;

  const PersonalDetailsPage({super.key, required this.userId});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  String _name = '';
  double _balance = 120.00;
  String _email = 'ahmed@example.com';
  String _phone = '+201234567890';
  String _carType = 'Nissan Leaf 2023';
  String? _profileImagePath;
  List<Map<String, String>> _history = [
    {'service': 'Tire Repair', 'date': '2025-04-01', 'cost': '100 EGP'},
    {'service': 'Oil Change', 'date': '2025-03-15', 'cost': '200 EGP'},
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.userId; // تحديث الاسم بناءً على المعرف الممرر
  }

  void _editDetails() {
    TextEditingController nameController = TextEditingController(text: _name);
    TextEditingController emailController = TextEditingController(text: _email);
    TextEditingController phoneController = TextEditingController(text: _phone);
    TextEditingController carTypeController = TextEditingController(text: _carType);
    TextEditingController balanceController = TextEditingController(text: _balance.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: carTypeController,
                decoration: const InputDecoration(labelText: 'Car Type'),
              ),
              TextField(
                controller: balanceController,
                decoration: const InputDecoration(labelText: 'Balance'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
                _email = emailController.text;
                _phone = phoneController.text;
                _carType = carTypeController.text;
                _balance = double.tryParse(balanceController.text) ?? _balance;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _pickImage() {
    setState(() {
      _profileImagePath = 'assets/images/profile_placeholder.png';
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Personal Details',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImagePath != null
                            ? AssetImage(_profileImagePath!)
                            : null,
                        backgroundColor: Colors.grey[800],
                        child: _profileImagePath == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Name: $_name',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Balance: ${_balance.toStringAsFixed(2)} EGP',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Email: $_email',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Phone: $_phone',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.directions_car, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Car Type: $_carType',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _editDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Edit Details'),
                ),
                const SizedBox(height: 32),
                const Row(
                  children: [
                    Icon(Icons.history, color: Colors.greenAccent, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Service History',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _history.isEmpty
                    ? const Center(
                  child: Text(
                    'No history available',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final entry = _history[index];
                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: const Icon(Icons.build, color: Colors.greenAccent),
                        title: Text(
                          entry['service']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Date: ${entry['date']} | Cost: ${entry['cost']}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}