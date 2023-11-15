import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('its working');
  } catch (e) {
    print('Error during Firebase initialization: $e');
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginPage(),
      '/': (context) => Home(),
      '/second': (context) => CitySelectPage(),
      '/fiveDayForecast': (context) => FiveDayForecastPage(),
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherService weatherService = WeatherService();
  Map<String, dynamic> weatherData = {};
  bool isLoading = false;

  Future<void> fetchWeatherData(String cityName) async {
    try {
      setState(() {
        isLoading = true;
      });
      weatherData = await weatherService.getWeatherData(cityName);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchWeatherData('Pilani');
    super.initState();
  }

  Future<void> updateWeatherData(CityData selectedCity) async {
    await fetchWeatherData(selectedCity.name);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (weatherData == null || weatherData.isEmpty) {
      return Scaffold(body: Center(child: Text('Failed to load weather data')));
    } else {
      final temperature = (weatherData['main']['temp']) - 273.15;
      final weatherCondition = weatherData['weather'][0]['description'];
      final capitalizedWeatherCondition =
          weatherCondition[0].toUpperCase() + weatherCondition.substring(1);

      Size size = MediaQuery.of(context).size;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/second');
            },
          ),
          title: Center(
            child: Text(weatherData.isNotEmpty ? weatherData['name'] : "Pilani"),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Bad_weather_sky_1.JPG/1200px-Bad_weather_sky_1.JPG?20060709173623',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '${temperature.toStringAsFixed(0)}°C',
                      style: TextStyle(fontSize: 72, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      capitalizedWeatherCondition,
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    Text(
                      '😷 AQI 165',
                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                margin: const EdgeInsets.all(15.0),
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 20.0, 10.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          "More Details>",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    WeatherInfoRow(
                        icon: Icons.cloud, day: "Today", condition: "Haze", temperature: "40°/23°"),
                    SizedBox(height: 10),
                    WeatherInfoRow(
                        icon: Icons.cloud, day: "Tomorrow", condition: "Haze", temperature: "36°/24°"),
                    SizedBox(height: 10),
                    WeatherInfoRow(
                        icon: Icons.cloud, day: "Sun", condition: "Haze", temperature: "36°/25°"),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 30.0),
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/fiveDayForecast');
                        },
                        child: Text(
                          "5-day forecast",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        WeatherDataRow('Now', '15:00', '16:00', '17:00'),
                        WeatherDataRow('39°', '39°', '40°', '39°'),
                        WeatherDataRow('☁', '☁', '☁', '☁'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class WeatherInfoRow extends StatelessWidget {
  final IconData icon;
  final String day;
  final String condition;
  final String temperature;

  WeatherInfoRow({
    required this.icon,
    required this.day,
    required this.condition,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text("$day · $condition", style: TextStyle(fontSize: 18)),
        Spacer(),
        Text(temperature, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

class WeatherDataRow extends StatelessWidget {
  final String time1;
  final String time2;
  final String time3;
  final String time4;

  WeatherDataRow(this.time1, this.time2, this.time3, this.time4);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          time1,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
        Text(
          time2,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
        Text(
          time3,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
        Text(
          time4,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ],
    );
  }
}

class FiveDayForecastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("5-Day Forecast"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Today'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('6/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('→23.5km/h', style: TextStyle(fontSize: 10.0, color: Colors.black)),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Tomorrow'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('7/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h', style: TextStyle(fontSize: 10.0, color: Colors.black)),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Sun'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('8/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('→18.5km/h', style: TextStyle(fontSize: 10.0, color: Colors.black)),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Mon'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('9/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h', style: TextStyle(fontSize: 10.0, color: Colors.black)),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Tue'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('10/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h', style: TextStyle(fontSize: 10.0, color: Colors.black)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CitySelectPage extends StatelessWidget {
  final List<CityData> cities = [
    CityData(name: 'Pilani', aqi: 165, minTemp: 23, maxTemp: 40, currentTemp: 39),
    CityData(name: 'Delhi', aqi: 158, minTemp: 24, maxTemp: 39, currentTemp: 35),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Manage cities")),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            width: size.width,
            height: size.height / 10,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return CityButton(
                  city: cities[index],
                  onCitySelected: (selectedCity) {
                    Navigator.pop(context, selectedCity);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CityButton extends StatelessWidget {
  final CityData city;
  final Function(CityData) onCitySelected;

  CityButton({required this.city, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        onPressed: () {
          onCitySelected(city);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          backgroundColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "AQI ${city.aqi} ${city.minTemp}° / ${city.maxTemp}°",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${city.currentTemp}°",
                    style: TextStyle(fontSize: 39, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityData {
  final String name;
  final int aqi;
  final int minTemp;
  final int maxTemp;
  final int currentTemp;

  CityData({
    required this.name,
    required this.aqi,
    required this.minTemp,
    required this.maxTemp,
    required this.currentTemp,
  });
}
