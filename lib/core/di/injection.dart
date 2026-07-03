import 'package:get_it/get_it.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

/// Initialises the dependency graph.
///
/// NOTE: the starter uses injectable's generated `getIt.init()`. build_runner
/// wasn't run in this environment, so [init] is hand-written in
/// injection.config.dart to match the generated shape. The @injectable
/// annotations remain on each class, so regenerating later is a drop-in.
Future<GetIt> configureDependencies() => getIt.init();
