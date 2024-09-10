import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:busticketingapp/sql_helper.dart';

void main() {
  runApp(const ApplicationHome());
}

class ApplicationHome extends StatelessWidget {
  const ApplicationHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SanganoSoft Bus Ticketing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
        primaryColor: Colors.lightBlueAccent,
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.lightBlueAccent),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
      home: const TicketSalesHome(
        title: 'Passenger Ticket Sales',
        routes: [
          {'source': 'City A', 'destination': 'City B', 'fare': 20.0},
          {'source': 'City B', 'destination': 'City C', 'fare': 15.0},
        ],
      ),
    );
  }
}

class TicketSalesHome extends StatefulWidget {
  const TicketSalesHome({super.key, required this.title, required this.routes});

  final String title;
  final List<Map<String, dynamic>> routes;

  @override
  State<TicketSalesHome> createState() => _TicketSalesHomeState();
}

class _TicketSalesHomeState extends State<TicketSalesHome> {
  List<Map<String, dynamic>> _ticketList = [];
  Future<void> _fetchTickets() async {
    // Assuming SQLHelper.getTickets() returns a Future<List<Map<String, dynamic>>>
    List<Map<String, dynamic>> tickets = await SQLHelper.getTickets();
    setState(() {
      _ticketList = tickets;
    });
  }

  bool _applyDiscount = false;
  double _luggageFare = 0.0;
  double _discountAmount = 0.0;
  String? _selectedPickup;
  String? _selectedDestination;
  final String _date = DateTime.now().toString().split(' ').first;
  final String _currentTime = DateTime.now().toString().split(' ').last.padLeft(5, '0');
  static const _conductorName = "Blessing Tsenesa";
  // New fields for passenger name and phone number
  final TextEditingController _passengerNameController = TextEditingController();
  final TextEditingController _passengerPhoneController = TextEditingController();

  final TextEditingController _tripFareController = TextEditingController();
  final TextEditingController _luggageDescriptionController = TextEditingController();
  final TextEditingController _seatNumberController = TextEditingController();
  final TextEditingController _luggageFareController = TextEditingController();
  final TextEditingController _discountAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tripFareController.text = _calculateFare().toString();
  }

  @override
  Widget build(BuildContext context) {
    double grandTotal = _calculateGrandTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(
                'SanganoSoft Bus Ticketing System',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text(
                'Issue New Ticket',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle navigation to Issue New Ticket
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              dense: true,
              visualDensity: VisualDensity.compact,
              shape: const Border(bottom: BorderSide(color: Colors.grey)), // Add bottom border
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text(
                'List All Tickets',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle navigation to List All Tickets
                MaterialPageRoute(builder: (context) => TicketList(ticketList: _ticketList));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              dense: true,
              visualDensity: VisualDensity.compact,
              shape: const Border(bottom: BorderSide(color: Colors.grey)), // Add bottom border
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text(
                'Add New Expense',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle navigation to Add New Expense
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              dense: true,
              visualDensity: VisualDensity.compact,
              shape: const Border(bottom: BorderSide(color: Colors.grey)), // Add bottom border
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text(
                'Add Report',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle navigation to Add Report
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              dense: true,
              visualDensity: VisualDensity.compact,
              shape: const Border(bottom: BorderSide(color: Colors.grey)), // Add bottom border
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text(
                'Cash Handover',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle navigation to Cash Handover
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              dense: true,
              visualDensity: VisualDensity.compact,
              shape: const Border(bottom: BorderSide(color: Colors.grey)), // Add bottom border
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Issue Passenger Ticket',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Date: $_date Time : $_currentTime'),
            const Text('Bus Conductor Name: $_conductorName'),
            const SizedBox(height: 15),
            Text(
              'Ticket Total: \$${grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Passenger Name TextField
                Expanded(
                  child: TextField(
                    controller: _passengerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Passenger Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between the two fields

                // Passenger Phone Number TextField
                Expanded(
                  child: TextField(
                    controller: _passengerPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row( // Row for Pickup and Destination dropdowns
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedPickup,
                      items: widget.routes
                          .map<DropdownMenuItem<String>>(
                            (route) => DropdownMenuItem(
                          value: route['source'].toString(),
                          child: Text(route['source'].toString()),
                        ),
                      )
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPickup = value;
                          _updateFare();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Pickup Point',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedDestination,
                      items: widget.routes
                          .map<DropdownMenuItem<String>>(
                            (route) => DropdownMenuItem(
                          value: route['destination'].toString(),
                          child: Text(route['destination'].toString()),
                        ),
                      )
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDestination = value;
                          _updateFare();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Destination Point',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row( // Row for Trip Fare and Luggage Fare text fields
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _tripFareController,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Trip Fare',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _luggageFareController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Luggage Fare',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _luggageFare = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _seatNumberController,
              decoration: const InputDecoration(
                labelText: 'Seat Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _luggageDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Luggage Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Discount Passenger Fare'),
              value: _applyDiscount,
              onChanged: (bool value) {
                setState(() {
                  _applyDiscount = value;
                  _discountAmountController.text = value ? _discountAmount.toString() : '0.0';
                });
              },
            ),
            const SizedBox(height: 10),
            if (_applyDiscount)
              TextField(
                controller: _discountAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Discount Amount',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _discountAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveTicket,
              child: const Text('Finalise Ticket'),
            ),
          ],
        ),
      ),

    );
  }

  void _updateFare() {
    if (_selectedPickup != null && _selectedDestination != null) {
      final route = widget.routes.firstWhere(
            (route) => route['source'] == _selectedPickup && route['destination'] == _selectedDestination,
        orElse: () => {'fare': 0.0},
      );
      _tripFareController.text = route['fare'].toString();
    }
  }

  double _calculateFare() {
    if (_selectedPickup != null && _selectedDestination != null) {
      final route = widget.routes.firstWhere(
            (route) => route['source'] == _selectedPickup && route['destination'] == _selectedDestination,
        orElse: () => {'fare': 0.0},
      );
      return route['fare'];
    }
    return 0.0;
  }

  double _calculateGrandTotal() {
    double fare = double.tryParse(_tripFareController.text) ?? 0.0;
    double luggageFare = _luggageFare;
    double discount = _applyDiscount ? _discountAmount : 0.0;
    return fare + luggageFare - discount;
  }

  void _saveTicket() async {
    if (_selectedPickup != null && _selectedDestination != null) {
      final ticket = {
        'pickup': _selectedPickup,
        'destination': _selectedDestination,
        'fare': double.tryParse(_tripFareController.text) ?? 0.0,
        'luggageFare': _luggageFare,
        'discount': _applyDiscount ? _discountAmount : 0.0,
        'total': _calculateGrandTotal(),
        'date': _date,
        'time': _currentTime,
        'conductor': _conductorName,
        'ticketNumber': _generateTicketNumber(),
      };

      await SQLHelper.addTicket(ticket);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket saved successfully!')),
      );
    }
  }

  String _generateTicketNumber() {
    // Example ticket number generation logic, you can customize this
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class TicketList extends StatelessWidget {
  final List<Map<String, dynamic>> ticketList;

  const TicketList({Key? key, required this.ticketList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tickets'),
      ),
      body: ListView.builder(
        itemCount: ticketList.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lightBlueAccent,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text('Ticket Number: ${ticketList[index]['ticketNumber']}'),
            subtitle: Text('Pickup: ${ticketList[index]['pickup']}, Destination: ${ticketList[index]['destination']}'),
            trailing: Text('Total: \$${ticketList[index]['total'].toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}