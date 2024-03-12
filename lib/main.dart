import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea 6 - Caja de Herramientas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/caja.png',
              width: 200,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PredictGenderScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Predecir Género',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PredictAgeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Predecir Edad',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UniversitiesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Universidades',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Clima Dominicano',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navegar a la vista de Página Web
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Página Web',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Acerca De',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca De'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('lib/assets/yo.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Contacto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Leonardo Pérez',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              '829-457-0644',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'leonardofelipe.perez4002@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Image.asset(
              'lib/assets/icono.png',
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class UniversitiesScreen extends StatefulWidget {
  @override
  _UniversitiesScreenState createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  List<dynamic> universities = [];
  bool isLoading = false;
  String country = '';

  Future<void> fetchUniversities(String country) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$country'));
    final responseData = json.decode(response.body);

    setState(() {
      universities = responseData;
      isLoading = false;
    });
  }

  Future<void> launchUniversityWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universidades'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingrese un país en inglés:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {

                setState(() {
                  country = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'País',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Fetch universities
                fetchUniversities(country);
              },
              child: Text('Buscar'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  final university = universities[index];
                  return ListTile(
                    title: Text(university['name']),
                    subtitle: Text(university['country']),
                    onTap: () {

                      launchUniversityWebsite(university['web_pages'][0]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictGenderScreen extends StatefulWidget {
  @override
  _PredictGenderScreenState createState() => _PredictGenderScreenState();
}

class _PredictGenderScreenState extends State<PredictGenderScreen> {
  String name = '';
  String gender = '';
  String imageUrl = '';

  Future<void> predictGender(String name) async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
    final responseData = json.decode(response.body);

    setState(() {
      this.name = name;
      this.gender = responseData['gender'];
      this.imageUrl = this.gender == 'male' ? 'lib/assets/masculino.png' : 'lib/assets/femenino.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predecir Género'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingrese un nombre:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                hintText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                predictGender(name);
              },
              child: Text('Predecir'),
            ),
            SizedBox(height: 20),
            Text(
              'Género: $gender',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (imageUrl.isNotEmpty) Image.asset(
              imageUrl,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class PredictAgeScreen extends StatefulWidget {
  @override
  _PredictAgeScreenState createState() => _PredictAgeScreenState();
}

class _PredictAgeScreenState extends State<PredictAgeScreen> {
  String name = '';
  int age = 0;
  String ageCategory = '';
  String imageUrl = '';

  Future<void> predictAge(String name) async {
    final response = await http.get(Uri.parse('https://api.agify.io/?name=$name'));
    final responseData = json.decode(response.body);

    setState(() {
      this.name = name;
      this.age = responseData['age'] as int;

      if (age <= 20) {
        ageCategory = 'Joven';
        imageUrl = 'lib/assets/joven.png';
      } else if (age <= 60) {
        ageCategory = 'Adulto';
        imageUrl = 'lib/assets/adulto.png';
      } else {
        ageCategory = 'Anciano';
        imageUrl = 'lib/assets/anciano.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predecir Edad'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingrese un nombre:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                hintText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                predictAge(name);
              },
              child: Text('Predecir'),
            ),
            SizedBox(height: 20),
            Text(
              'Edad: $age años',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Categoría de edad: $ageCategory',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (imageUrl.isNotEmpty) Image.asset(
              imageUrl,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String temperature = '';

  Future<void> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'https://api.weatherbit.io/v2.0/current?lat=18.4861&lon=-69.9312&key=d9a7e5f8d38547aea32b694543ffcef0'));
    final responseData = json.decode(response.body);

    setState(() {
      temperature = responseData['data'][0]['temp'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima Dominicano'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperatura actual en RD:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '$temperature °C',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Image.asset(
              'lib/assets/isla.png',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
