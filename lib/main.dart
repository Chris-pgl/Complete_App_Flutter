import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class City {
  final String name;
  final String image;
  bool isLiked;

  City({required this.name, required this.image, this.isLiked = false});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<City> cities = [
    City(
      name: "Night City",
      image:
          "https://static.cdprojektred.com/cms.cdprojektred.com/16x9_big/872822c5e50dc71f345416098d29fc3ae5cd26c1-1920x1080.jpg",
    ),
    City(
      name: "Columbia",
      image:
          "https://static.wikia.nocookie.net/bioshock/images/7/7e/The_Flying_City_of_Columbia.png/revision/latest/scale-to-width-down/1200?cb=20130512002726",
    ),
    City(
      name: "Rapture",
      image:
          "https://cubiccreativity.wordpress.com/wp-content/uploads/2025/09/bioshock-two-1.jpg?w=1000",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City Explorer')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InfoTourPage(city: city.name),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(city.image),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: city.isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              city.isLiked = !city.isLiked;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Scopri le attività più interessanti della città.",
                        ),
                        SizedBox(height: 10),
                        Text("Scopri", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoTourPage extends StatefulWidget {
  final String city;

  InfoTourPage({required this.city});

  @override
  _InfoTourPageState createState() => _InfoTourPageState();
}

class _InfoTourPageState extends State<InfoTourPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> sendData() async {
    final url = Uri.parse('http://10.0.2.2:3000/infoTour');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "city": widget.city,
        "email": emailController.text,
        "message": messageController.text,
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.statusCode == 201 ? "Inviato ✅" : "Errore ❌"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Richiedi informazioni")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Città: ${widget.city}"),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email obbligatoria";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Email non valida";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(labelText: "Messaggio"),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Messaggio obbligatorio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendData();
                  }
                },
                child: Text("Invia"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
