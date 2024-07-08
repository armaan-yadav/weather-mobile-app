import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/addiional_information_card.dart';
import 'package:weather_app/hourly_weather_foreast_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getWeatherInformation() async {
    try {
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=Ambala,in&APPID=b83e119d4bb406be46d54989bfa40323'),
      );
      final data = jsonDecode(result.body);

      if (data["cod"] != "200") {
        throw "An unexpected error occured.";
      }

      return data;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          FutureBuilder(
            future: getWeatherInformation(),
            builder: (context, snapshot) => IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getWeatherInformation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final list = snapshot.data?["list"];
          final temp = snapshot.data?["list"][0]["main"]["temp"];
          final pressure =
              snapshot.data?["list"][0]["main"]["pressure"].toString();
          final humidity =
              snapshot.data?["list"][0]["main"]["humidity"].toString();
          final windSpeed =
              snapshot.data?["list"][0]["wind"]["speed"].toString();
          final currentWeather =
              snapshot.data?["list"][0]["weather"][0]["main"];
          final description =
              snapshot.data?["list"][0]["weather"][0]["description"];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                //! main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 3,
                          sigmaY: 3,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "$temp K",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                currentWeather == "Clouds"
                                    ? Icons.cloud
                                    : currentWeather == "Rain"
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                size: 60,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentWeather,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //! forecast
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weather Forecast",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i <= 4; i++)
                              HourlyForecastCard(
                                icon: list[i]["weather"][0]["main"] == "Clouds"
                                    ? Icons.cloud
                                    : currentWeather == "Rain"
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                time: list[i]["dt_txt"]
                                    .toString()
                                    .substring(11, 16),
                                value: list[i]["weather"][0]["main"],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //! additional information
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AdditionalInformationCard(
                            icon: Icons.water_drop,
                            name: "Humidity",
                            value: humidity.toString(),
                          ),
                          AdditionalInformationCard(
                            icon: Icons.air,
                            name: "Wind Speed",
                            value: windSpeed.toString(),
                          ),
                          AdditionalInformationCard(
                            icon: Icons.beach_access,
                            name: "Pressure",
                            value: pressure.toString(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
