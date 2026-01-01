import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'configure_dependencies.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  // Optional: You can specify the generated file name if it's not the default.
  // initializerName: r'$initGetIt',
)
Future<void> configureDependencies() async {
  // 2. The only thing you need to call here is the generated initializer.
  // The generator will handle the @preResolve for you.
  await getIt.init();
}