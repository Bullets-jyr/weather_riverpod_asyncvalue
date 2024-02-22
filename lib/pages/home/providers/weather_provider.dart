import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/current_weather/current_weather.dart';
import '../../../repositories/providers/weather_repository_provider.dart';

part 'weather_provider.g.dart';

@riverpod
class Weather extends _$Weather {
  @override
  FutureOr<CurrentWeather?> build() {
    // 값이 존재하지 않은 상태는 null로 다루면 됩니다.
    // null: AsyncData(null)
    // Future<CurrentWeather?>.value(null): AsyncLoading() > AsyncData(null)
    return Future<CurrentWeather?>.value(null);
  }

  Future<void> fetchWeather(String city) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentWeather = await ref.read(weatherRepositoryProvider).fetchWeather(city);

      return currentWeather;
    });
  }
}