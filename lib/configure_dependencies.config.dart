// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:barter_app/data/local/app_database.dart' as _i397;
import 'package:barter_app/repositories/chat_repository.dart' as _i1006;
import 'package:barter_app/repositories/user_repository.dart' as _i33;
import 'package:barter_app/screens/initialize_screen/initialize_cubit.dart'
    as _i646;
import 'package:barter_app/screens/interests_screen/cubit/interests_cubit.dart'
    as _i838;
import 'package:barter_app/screens/location_picker_screen/cubit/location_picker_cubit.dart'
    as _i159;
import 'package:barter_app/screens/notifications_screen/cubit/notifications_cubit.dart'
    as _i568;
import 'package:barter_app/screens/onboarding_screen/cubit/onboarding_cubit.dart'
    as _i12;
import 'package:barter_app/services/api_client.dart' as _i205;
import 'package:barter_app/services/app_module.dart' as _i716;
import 'package:barter_app/services/chat_notification_service.dart' as _i636;
import 'package:barter_app/services/secure_storage_service.dart' as _i607;
import 'package:barter_app/services/settings_service.dart' as _i627;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i205.ApiClient>(() => _i205.ApiClient.create());
    gh.factory<_i607.SecureStorageService>(
      () => _i607.SecureStorageService.new(),
    );
    await gh.singletonAsync<_i397.AppDatabase>(
      () => appModule.appDatabase,
      preResolve: true,
    );
    gh.singleton<_i636.ChatNotificationService>(
      () => _i636.ChatNotificationService(),
    );
    gh.singleton<_i627.SettingsService>(() => _i627.SettingsService());
    gh.factory<_i568.NotificationsCubit>(
      () => _i568.NotificationsCubit(gh<_i205.ApiClient>()),
    );
    gh.factory<String>(
      () => appModule.serviceBaseUrl,
      instanceName: 'serviceBaseUrl',
    );
    gh.lazySingleton<_i33.UserRepository>(
      () => _i33.UserRepository(gh<_i607.SecureStorageService>()),
    );
    gh.factory<_i12.OnboardingCubit>(
      () => _i12.OnboardingCubit(gh<_i33.UserRepository>()),
    );
    gh.factory<_i838.InterestsCubit>(
      () => _i838.InterestsCubit(
        gh<_i205.ApiClient>(),
        gh<_i33.UserRepository>(),
      ),
    );
    gh.singleton<_i1006.ChatRepository>(
      () => _i1006.ChatRepository(gh<_i397.AppDatabase>()),
    );
    gh.factory<_i646.InitializeCubit>(
      () => _i646.InitializeCubit(
        gh<_i33.UserRepository>(),
        gh<_i205.ApiClient>(),
      ),
    );
    gh.factory<_i159.LocationPickerCubit>(
      () => _i159.LocationPickerCubit(
        gh<_i205.ApiClient>(),
        gh<_i33.UserRepository>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i716.AppModule {}
