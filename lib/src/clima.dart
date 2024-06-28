import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Clima {
  final String apiKey = "jev1q64kprs4yqadmtlz8go2t5er6836t0erntd8";

  Future<Map<String, dynamic>> fetchWeatherData(String placeId) async {
    final url = 'https://www.meteosource.com/api/v1/free/point'
        '?place_id=$placeId&sections=all&timezone=UTC&language=en&units=metric&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final Clima weatherService = Clima();
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    try {
      var data = await weatherService.fetchWeatherData('santo-domingo');
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Map<String, String> weatherIcons = {
    '1': 'assets/climaiconos/1.png',
    '2': 'assets/climaiconos/2.png',
    '3': 'assets/climaiconos/3.png',
    '4': 'assets/climaiconos/4.png',
    '5': 'assets/climaiconos/5.png',
    '6': 'assets/climaiconos/6.png',
    '7': 'assets/climaiconos/7.png',
    '8': 'assets/climaiconos/8.png',
    '9': 'assets/climaiconos/9.png',
    '10': 'assets/climaiconos/10.png',
    '11': 'assets/climaiconos/11.png',
    '12': 'assets/climaiconos/12.png',
    '13': 'assets/climaiconos/13.png',
    '14': 'assets/climaiconos/14.png',
    '15': 'assets/climaiconos/15.png',
    '16': 'assets/climaiconos/16.png',
    '17': 'assets/climaiconos/17.png',
    '18': 'assets/climaiconos/18.png',
    '19': 'assets/climaiconos/19.png',
    '20': 'assets/climaiconos/20.png',
    '21': 'assets/climaiconos/21.png',
    '22': 'assets/climaiconos/22.png',
    '23': 'assets/climaiconos/23.png',
    '24': 'assets/climaiconos/24.png',
    '25': 'assets/climaiconos/25.png',
    '26': 'assets/climaiconos/26.png',
    '27': 'assets/climaiconos/27.png',
    '28': 'assets/climaiconos/28.png',
    '29': 'assets/climaiconos/29.png',
    '30': 'assets/climaiconos/30.png',
    '31': 'assets/climaiconos/31.png',
    '32': 'assets/climaiconos/32.png',
    '33': 'assets/climaiconos/33.png',
    '34': 'assets/climaiconos/34.png',
    '35': 'assets/climaiconos/35.png',
    '36': 'assets/climaiconos/36.png',
  };

  @override
  Widget build(BuildContext context) {
    String titulo = 'Clima en Santo Domingo';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[400],
        elevation: 0,
        title: const Text('Clima en República Dominicana'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: isLoading
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              )))
          : weatherData == null
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/fondo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/fondo.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Center(
                          child: Text('Error al cargar los datos'))))
              : Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/fondo.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                titulo.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Pronóstico por Hora:',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 225,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(bottom: 10),
                                itemCount:
                                    weatherData!['hourly']['data'].length,
                                itemBuilder: (context, index) {
                                  var hourly =
                                      weatherData!['hourly']['data'][index];
                                  String iconPath =
                                      weatherIcons[hourly['icon'].toString()] ??
                                          'assets/climaiconos/1.png';
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal:
                                            10), // Añadir margen horizontal
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(69, 81, 42, 187),
                                          blurRadius: 4,
                                          offset: Offset(4, 8),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.1),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.asset(
                                                    iconPath,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  hourly['summary'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  '${hourly['temperature']}°',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                Text(
                                                  hourly['date']
                                                      .substring(11, 16),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
