import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/current_weather/app_weather.dart';
import '../../../models/current_weather/current_weather.dart';
import '../../../models/custom_error/custom_error.dart';
import 'format_text.dart';
import 'select_city.dart';
import 'show_icon.dart';
import 'show_temperature.dart';

class ShowWeather extends ConsumerWidget {
  final AsyncValue<CurrentWeather?> weatherState;

  const ShowWeather({
    super.key,
    required this.weatherState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return weatherState.when(
      skipError: true,
      data: (CurrentWeather? weather) {
        print('***** in data callback');

        if (weather == null) {
          return const SelectCity();
        }

        final appWeather = AppWeather.fromCurrentWeather(weather);

        // return Center(
        //   child: Text(
        //     appWeather.name,
        //     style: const TextStyle(fontSize: 18),
        //   ),
        // );
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              appWeather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(DateTime.now()).format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '(${appWeather.country})',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       '${appWeather.temp}',
            //       style: const TextStyle(
            //         fontSize: 30,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     const SizedBox(width: 20.0),
            //     Column(
            //       children: [
            //         Text(
            //           '${appWeather.tempMax}',
            //           style: const TextStyle(fontSize: 16),
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           '${appWeather.tempMin}',
            //           style: const TextStyle(fontSize: 16),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTemperature(
                  temperature: appWeather.temp,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    ShowTemperature(
                      temperature: appWeather.tempMax,
                      fontSize: 16.0,
                    ),
                    const SizedBox(height: 10),
                    ShowTemperature(
                      temperature: appWeather.tempMin,
                      fontSize: 16.0,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                ShowIcon(icon: appWeather.icon),
                Expanded(
                  flex: 3,
                  child: FormatText(description: appWeather.description),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        print('***** in error callback');
        // value: previous value가 있을 경우, loading, error state에서 previous value를 return 합니다.
        // previous value가 없는 상태에서는 loading state에서 null을 return하고 error state에서는 error를 rethrow 합니다.
        if (weatherState.value == null) {
          return const SelectCity();
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              (error as CustomError).errMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
      loading: () {
        print('***** in loading callback');
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}