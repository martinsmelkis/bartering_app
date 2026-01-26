import 'package:barter_app/data/local/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  // 1. Annotate the factory method with @preResolve and @singleton.
  // This tells injectable to await this Future during initialization
  // and register the result as a singleton.
  @preResolve
  @singleton
  Future<AppDatabase> get appDatabase => AppDatabase.create();

  @Named('serviceBaseUrl')
  String get serviceBaseUrl {
    if (kIsWeb) {
      return dotenv.env['SERVICE_BASE_URL_WEB'] ?? 'http://localhost:8081';
    } else {
      return dotenv.env['SERVICE_BASE_URL_MOBILE'] ?? 'http://10.0.2.2:8081';
    }
  }

}