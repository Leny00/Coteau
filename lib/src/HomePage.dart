import 'package:coteau/src/clima.dart';
import 'package:coteau/src/wordpress.dart';
import 'package:flutter/material.dart';
import 'package:coteau/src/universidades.dart';
import 'package:coteau/src/genero.dart';
import 'package:coteau/src/edad.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_currentPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Universidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Género',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: 'Edad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Clima',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'WordPress',
          ),
        ],
        backgroundColor: Colors.red[400],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Bobthebuilder.webp'),
              fit: BoxFit.cover,
            ),
          ),
        );
      case 1:
        return const UniPage();
      case 2:
        return const GeneroPage();
      case 3:
        return const EdadPage();
      case 4:
        return const ClimaPage();
      case 5:
        return const WordPressPage();
      default:
        return Container();
    }
  }
}
