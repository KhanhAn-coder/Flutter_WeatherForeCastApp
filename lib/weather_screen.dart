import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secret.dart';

import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;


  Future <Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "Ho Chi Minh";
    try{
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if(data['cod'] != "200"){
        throw 'An unexpected error occurred';
      }

      return data;
      //data['list'][0]['main']['temp'];
    }catch(e){
      throw e.toString();
    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",
        style: TextStyle(fontWeight: FontWeight.bold,
        ),
      ),
        centerTitle: true,
        actions: [
            IconButton(onPressed:(){
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh)
          )
        ],

      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.runtimeType);
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'] - 272.15;
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              Card(
                elevation: 10,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            Text("${currentTemp.toStringAsFixed(0)}°C", style:const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           const SizedBox(height: 16,),
                           Icon(
                              currentSky == "Clouds" || currentSky == "Rain" ? Icons.cloud : Icons.sunny,
                              size: 64,
                            ),
                           const SizedBox(height: 16,),
                             Text(currentSky.toString(), style: const TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              //Weather Forecast Card
              const Text("Hourly Forecast",
              style: TextStyle(fontSize: 24,  fontWeight: FontWeight.bold),
            ),
              const SizedBox(height: 16,),
               /*SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:  [
                    for(int i=0; i<data['list'].length-1; i++)
                      HourlyForecastItem(
                          time: data['list'][i+1]['dt'].toString(),
                          degree: data['list'][i+1]['main']['temp'].toString(),
                          icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds' || data['list'][i+1]['weather'][0]['main'] == 'Rain' ? Icons.cloud:Icons.sunny),

                  ],
                ),
              ),*/
              SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      final hourlyForeCast = data['list'][index+1];
                      final hourlySky = hourlyForeCast['weather'][0]['main'];
                      final hourlyTemp = hourlyForeCast['main']['temp'] - 272.15;
                      final time = DateTime.parse(hourlyForeCast['dt_txt']);
                      return HourlyForecastItem(
                          time: DateFormat.Hm().format(time),
                          degree: hourlyTemp.toStringAsFixed(0),
                          icon: hourlySky == "Clouds" || hourlySky == "Rain" ? Icons.cloud:Icons.sunny);
                    }),
              ),

              const SizedBox(height: 20,),

              const Text("Additional Information",
                style: TextStyle(fontSize: 24,  fontWeight: FontWeight.bold),
              ),
              //Additional information
              const SizedBox(height: 16,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: currentHumidity.toString()
                  ),
                  AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: currentWindSpeed.toString()
                  ),
                  AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toString()),

                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}





