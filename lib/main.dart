import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
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

  // Method to fetch weather data
  Future<void> fetchWeatherData(String city) async {
    try {
      setState(() {
        isLoading = true;
      });
      weatherData = await weatherService.getWeatherData(city);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle errors, e.g., display an error message to the user
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // Fetch weather data for Vidyavihar when the page is loaded
    fetchWeatherData('Pilani');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Display a loading indicator while data is being fetched
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (weatherData == null) {
      // Handle the case where data is not available or there was an error
      return Scaffold(body: Center(child: Text('Failed to load weather data')));
    } else {
      // Parse the data and update your UI accordingly
      final temperature = (weatherData['main']['temp']) - 273.15;
      final weatherCondition = weatherData['weather'][0]['description'];
      final capitalizedWeatherCondition =
          weatherCondition[0].toUpperCase() + weatherCondition.substring(1);

      Size size = MediaQuery
          .of(context)
          .size;

      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
            ),
            title: Center(
            child: Text("Vidyavihar"
            ),
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
                      Text('${temperature.toStringAsFixed(0)}°C',
                          style: TextStyle(fontSize: 72, color: Colors.black)),
                      SizedBox(height: 10),
                      Text(capitalizedWeatherCondition,
                          style: TextStyle(fontSize: 24, color: Colors.black)),
                      //SizedBox(height: 10),
                      Text('😷 AQI 165',
                          style: TextStyle(fontSize: 13.0, color: Colors.black)),
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
                          child: Text("More Details>", textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {},
                        ),
                      ),
                      WeatherInfoRow(icon: Icons.cloud,
                          day: "Today",
                          condition: "Haze",
                          temperature: "40°/23°"),
                      SizedBox(height: 10),
                      WeatherInfoRow(icon: Icons.cloud,
                          day: "Tomorrow",
                          condition: "Haze",
                          temperature: "36°/24°"),
                      SizedBox(height: 10),
                      WeatherInfoRow(icon: Icons.cloud,
                          day: "Sun",
                          condition: "Haze",
                          temperature: "36°/25°"),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 30.0),
                        width: size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/fiveDayForecast');
                          },
                          child: Text(
                              "5-day forecast", textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,),),
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
          ));
    }
  }
}

class CitySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text("Manage cities")),
      actions:[
          IconButton(icon: const Icon(Icons.add),onPressed: () {},),

      ]
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
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0,5.0,10.0,10.0),
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blueGrey,
            ),
            width: size.width,
            height: size.height / 9,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vidyavihar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "AQI 165 40° / 23°",
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
                        "39°",
                        style: TextStyle(fontSize: 39, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0,5.0,10.0,10.0),
            padding: const EdgeInsets.all(19.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blueGrey,
            ),
            width: size.width,
            height: size.height / 9,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delhi",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "AQI 158 39° / 24°",
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
                        "35°",
                        style: TextStyle(fontSize: 39, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
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

          // First Column
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
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('→23.5km/h',style: TextStyle(fontSize: 10.0, color: Colors.black),),
                ],
              ),
            ],
          ),

          // Second Column
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
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h',style: TextStyle(fontSize: 10.0, color: Colors.black),),
                ],
              ),
            ],
          ),

          // Third Column
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
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('→18.5km/h',style: TextStyle(fontSize: 10.0, color: Colors.black),),
                ],
              ),
            ],
          ),

          // Fourth Column
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
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h',style: TextStyle(fontSize: 10.0, color: Colors.black),),
                ],
              ),
            ],
          ),

          // Fifth Column
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
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.nights_stay),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h',style: TextStyle(fontSize: 10.0, color: Colors.black),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}