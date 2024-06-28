// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Adivinador {
  final String name;
  final String gender;
  final double probability;

  Adivinador({
    required this.name,
    required this.gender,
    required this.probability,
  });

  factory Adivinador.fromJson(Map<String, dynamic> json) {
    return Adivinador(
      name: json['name'],
      gender: json['gender'],
      probability: json['probability'],
    );
  }
}

class GeneroPage extends StatefulWidget {
  const GeneroPage({super.key});

  @override
  State<GeneroPage> createState() => _GeneroPageState();
}

class _GeneroPageState extends State<GeneroPage> {
  TextEditingController? nombre;
  String? genero;

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

  Future<void> fetchGender(String name) async {
    final response =
        await http.get(Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        genero = jsonData['gender'];
        if (genero == "male") {
          genero = 'Hombre';
        } else {
          genero = 'Mujer';
        }
      });
    } else {
      setState(() {
        genero = null;
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
        title: const Text('Adivinador de genero'),
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 4,
                            color: genero == 'Hombre'
                                ? Colors.blue
                                : genero == 'Mujer'
                                    ? Colors.pink
                                    : Colors.green,
                          ),
                        ),
                        hintText: 'Introduce tu nombre',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 120, 10, 6)),
                      onPressed: () {
                        if (nombre?.text.isNotEmpty ?? false) {
                          fetchGender(nombre!.text);
                        }
                      },
                      child: const Text('Enviar'),
                    ),
                    const SizedBox(height: 20),
                    if (genero != null)
                      Text(
                        'Género estimado: $genero',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
