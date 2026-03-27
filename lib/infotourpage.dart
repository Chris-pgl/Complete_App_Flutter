import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class InfoTourPage extends StatefulWidget {
  @override
  _InfoTourPageState createState() => _InfoTourPageState();
}

class _InfoTourPageState extends State<InfoTourPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  //Post
  Future<void> sendData() async {
    //uso il 10.0.2.2 per emulator android
    final url = Uri.parse('http://10.0.2.2:3000/infoTour');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'message': messageController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Dati inviati con successo.')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Errore invio..')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info Toir')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email obbligatoria';
                  }

                  //regex emial
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email non valida.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              //messag
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(labelText: 'Messagio'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Messagio obbligatorio';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              //buttn
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //snakbar confirm
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Invio in corso..')));
                    sendData();
                  }
                },
                child: Text('Invia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
