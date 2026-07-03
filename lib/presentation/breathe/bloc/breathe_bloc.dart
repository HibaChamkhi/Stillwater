import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/error_utils.dart';
import '../../../core/model/ui_state.dart';
import '../../../domain/wellness/repositories/wellness_repository.dart';

part 'breathe_event.dart';
part 'breathe_state.dart';

@injectable
class BreatheBloc extends Bloc<BreatheEvent, BreatheState> {
  final WellnessRepository repository;

  BreatheBloc(this.repository) : super(const BreatheState(status: UIStatus.success)) {
    on<CompletePracticeEvent>(_onComplete);
  }

  Future<void> _onComplete(
    CompletePracticeEvent event,
    Emitter<BreatheState> emit,
  ) async {
    emit(state.copyWith(status: UIStatus.loading));
    try {
      await repository.addPracticeTime(event.listened);
      emit(state.copyWith(status: UIStatus.success, data: true));
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }
}
