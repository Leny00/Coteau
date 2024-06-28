import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EdadPage extends StatefulWidget {
  const EdadPage({Key? key}) : super(key: key);

  @override
  State<EdadPage> createState() => _EdadPageState();
}

class _EdadPageState extends State<EdadPage> {
  TextEditingController? nombre;
  int? edad;

  @override
  void initState() {
    super.initState();
    nombre = TextEditingController();
  }

  @override
  void dispose() {
    nombre?.dispose();
    super.dispose();
  }

  Future<void> fetchAge(String name) async {
    final response =
        await http.get(Uri.parse('https://api.agify.io/?name=$name'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        edad = jsonData['age'];
      });
    } else {
      setState(() {
        edad = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String titulo = 'Introduce tu Nombre!';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[400],
        elevation: 0,
        title: const Text('Adivinador de Edad'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nombre,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 4,
                            color: Colors.green,
                          ),
                        ),
                        hintText: 'Introduce tu nombre',
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 120, 10, 6)),
                    onPressed: () {
                      if (nombre?.text.isNotEmpty ?? false) {
                        fetchAge(nombre!.text);
                      }
                    },
                    child: const Text(
                      'Enviar',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (edad != null) _buildImageBasedOnAge(edad!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageBasedOnAge(int age) {
    if (age <= 25) {
      // Joven
      return Image.asset(
        './assets/jovenes.jpg',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (age > 25 && age <= 60) {
      // Adulto
      return Image.asset(
        './assets/adultos.jpg',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // Anciano
      return Image.asset(
        './assets/ancianos.webp',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }
}
