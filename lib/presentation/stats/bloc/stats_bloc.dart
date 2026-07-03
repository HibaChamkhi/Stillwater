import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/error_utils.dart';
import '../../../core/model/ui_state.dart';
import '../../../domain/wellness/models/wellness_stats.dart';
import '../../../domain/wellness/repositories/wellness_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

@injectable
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final WellnessRepository repository;

  StatsBloc(this.repository) : super(const StatsState()) {
    on<LoadStatsEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadStatsEvent event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: UIStatus.loading));
    try {
      final stats = await repository.getStats();
      emit(state.copyWith(status: UIStatus.success, data: stats));
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }
}
