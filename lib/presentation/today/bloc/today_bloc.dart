import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/error_utils.dart';
import '../../../core/model/ui_state.dart';
import '../../../domain/wellness/repositories/wellness_repository.dart';

part 'today_event.dart';
part 'today_state.dart';

@injectable
class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final WellnessRepository repository;

  TodayBloc(this.repository) : super(const TodayState()) {
    on<LoadTodayEvent>(_onLoad);
    on<ToggleTeaEvent>(_onToggleTea);
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  Future<void> _onLoad(LoadTodayEvent event, Emitter<TodayState> emit) async {
    emit(state.copyWith(status: UIStatus.loading));
    try {
      final stats = await repository.getStats();
      final tea = await repository.getTeaDone();
      emit(state.copyWith(
        status: UIStatus.success,
        data: TodayData(
          userName: stats.userName,
          greetingWord: _greeting,
          streakDays: stats.streakDays,
          teaDone: tea,
        ),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }

  Future<void> _onToggleTea(ToggleTeaEvent event, Emitter<TodayState> emit) async {
    try {
      final current = state.data?.teaDone ?? false;
      await repository.setTeaDone(!current);
      add(LoadTodayEvent());
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }
}
