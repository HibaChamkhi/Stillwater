import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/error_utils.dart';
import '../../../core/model/ui_state.dart';
import '../../../domain/wellness/models/journal_entry.dart';
import '../../../domain/wellness/repositories/wellness_repository.dart';

part 'journal_event.dart';
part 'journal_state.dart';

@injectable
class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final WellnessRepository repository;

  JournalBloc(this.repository) : super(const JournalState()) {
    on<LoadEntriesEvent>(_onLoad);
    on<SaveEntryEvent>(_onSave);
  }

  Future<void> _onLoad(LoadEntriesEvent event, Emitter<JournalState> emit) async {
    emit(state.copyWith(status: UIStatus.loading));
    try {
      final entries = await repository.getEntries();
      emit(state.copyWith(status: UIStatus.success, data: entries));
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }

  Future<void> _onSave(SaveEntryEvent event, Emitter<JournalState> emit) async {
    try {
      await repository.saveEntry(JournalEntry(
        text: event.text,
        mood: event.mood,
        at: DateTime.now(),
      ));
      final entries = await repository.getEntries();
      emit(state.copyWith(status: UIStatus.success, data: entries));
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }
}
