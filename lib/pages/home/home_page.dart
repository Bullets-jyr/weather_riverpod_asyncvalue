import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod_asyncvalue/extensions/async_value_xx.dart';
import 'package:weather_riverpod_asyncvalue/pages/home/providers/weather_provider.dart';
import 'package:weather_riverpod_asyncvalue/repositories/providers/weather_repository_provider.dart';

import '../../models/current_weather/current_weather.dart';
import '../../models/custom_error/custom_error.dart';
import '../search/search_page.dart';
import 'widgets/show_weather.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero, () {
  //     ref.read(weatherProvider.notifier).fetchWeather('london');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<CurrentWeather?>>(
      weatherProvider,
          (previous, next) {
        // Only Error
        next.whenOrNull(
          error: (error, stackTrace) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text((error as CustomError).errMsg),
                );
              },
            );
          },
        );
      },
    );

    final weatherState = ref.watch(weatherProvider);
    print(weatherState.toStr);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              city = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              print('city: $city');
              if (city != null) {
                ref.read(weatherProvider.notifier).fetchWeather(city!);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ShowWeather(weatherState: weatherState),
      floatingActionButton: FloatingActionButton(
        // button disabled
        onPressed: city == null
            ? null
            : () {
          ref.read(weatherProvider.notifier).fetchWeather(city!);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
