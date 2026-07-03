// Hand-written to mirror injectable's generated output (build_runner was not
// run here). Registers the wellness data graph and one factory per bloc.

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/wellness/data_sources/local/wellness_local_data_source.dart';
import '../../data/wellness/repositories/wellness_repository_impl.dart';
import '../../domain/wellness/repositories/wellness_repository.dart';
import '../../presentation/breathe/bloc/breathe_bloc.dart';
import '../../presentation/journal/bloc/journal_bloc.dart';
import '../../presentation/library/bloc/library_bloc.dart';
import '../../presentation/stats/bloc/stats_bloc.dart';
import '../../presentation/today/bloc/today_bloc.dart';

extension GetItInjectableX on GetIt {
  Future<GetIt> init() async {
    final gh = this;

    // Async singletons (preResolve in the starter).
    final prefs = await SharedPreferences.getInstance();
    gh.registerSingleton<SharedPreferences>(prefs);

    // Data layer.
    gh.registerLazySingleton<WellnessLocalDataSource>(
      () => WellnessLocalDataSourceImpl(gh<SharedPreferences>()),
    );
    gh.registerLazySingleton<WellnessRepository>(
      () => WellnessRepositoryImpl(gh<WellnessLocalDataSource>()),
    );

    // Presentation (one bloc factory per feature).
    gh.registerFactory<TodayBloc>(() => TodayBloc(gh<WellnessRepository>()));
    gh.registerFactory<BreatheBloc>(() => BreatheBloc(gh<WellnessRepository>()));
    gh.registerFactory<LibraryBloc>(() => LibraryBloc(gh<WellnessRepository>()));
    gh.registerFactory<JournalBloc>(() => JournalBloc(gh<WellnessRepository>()));
    gh.registerFactory<StatsBloc>(() => StatsBloc(gh<WellnessRepository>()));

    return gh;
  }
}
