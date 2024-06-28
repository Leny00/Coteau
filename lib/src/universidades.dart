import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Universidad {
  final String name;
  final String country;
  final List<String> webPages;

  Universidad({
    required this.name,
    required this.country,
    required this.webPages,
  });

  factory Universidad.fromJson(Map<String, dynamic> json) {
    return Universidad(
      name: json['name'],
      country: json['country'],
      webPages: List<String>.from(json['web_pages']),
    );
  }
}

class UniPage extends StatefulWidget {
  const UniPage({super.key});

  @override
  State<UniPage> createState() => _UniPageState();
}

class _UniPageState extends State<UniPage> {
  TextEditingController? countryController;
  List<Universidad> universidades = [];

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController();
  }

  @override
  void dispose() {
    countryController?.dispose();
    super.dispose();
  }

  Future<void> fetchUniversidades(String country) async {
    final response = await http.get(Uri.parse(
        'http://universities.hipolabs.com/search?country=${Uri.encodeQueryComponent(country)}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        universidades =
            jsonData.map((data) => Universidad.fromJson(data)).toList();
      });
    } else {
      setState(() {
        universidades = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String titulo = 'Buscar Universidades por País';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[400],
        elevation: 0,
        title: const Text('Listado de Universidades'),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  style: TextStyle(color: Colors.white),
                  controller: countryController,
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.red,
                        ),
                      ),
                      hintText:
                          'Ingrese el nombre del país (ej. Dominican Republic)',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 120, 10, 6)),
                  onPressed: () {
                    String country = countryController!.text.trim();
                    if (country.isNotEmpty) {
                      fetchUniversidades(country);
                    }
                  },
                  child: const Text('Buscar Universidades'),
                ),
                const SizedBox(height: 20),
                if (universidades.isNotEmpty)
                  TableController.createTable(universidades),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TableController {
  static Widget createTable(List<Universidad> list) {
    List<TableRow> rows = [];
    rows.add(_createTableHeader());

    for (var universidad in list) {
      rows.add(TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(universidad.name, style: TextStyle(color: Colors.white)),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(universidad.country,
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: universidad.webPages
                    .map((webPage) =>
                        Text(webPage, style: TextStyle(color: Colors.white)))
                    .toList(),
              ),
            ),
          ),
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        children: rows,
      ),
    );
  }

  static TableRow _createTableHeader() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Country',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Web Pages',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
