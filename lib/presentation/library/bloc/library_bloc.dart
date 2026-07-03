import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/error_utils.dart';
import '../../../core/model/ui_state.dart';
import '../../../domain/wellness/models/practice.dart';
import '../../../domain/wellness/repositories/wellness_repository.dart';

part 'library_event.dart';
part 'library_state.dart';

@injectable
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final WellnessRepository repository;

  LibraryBloc(this.repository) : super(const LibraryState()) {
    on<LoadLibraryEvent>(_onLoad);
    on<ChangeFilterEvent>(_onFilter);
  }

  Future<void> _onLoad(LoadLibraryEvent event, Emitter<LibraryState> emit) async {
    emit(state.copyWith(status: UIStatus.loading));
    try {
      final all = repository.getLibrary();
      emit(state.copyWith(
        status: UIStatus.success,
        data: LibraryData(all: all, filter: 'All'),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(status: UIStatus.error, message: mapExceptionToMessage(e)));
    }
  }

  void _onFilter(ChangeFilterEvent event, Emitter<LibraryState> emit) {
    final all = state.data?.all ?? const [];
    emit(state.copyWith(
      status: UIStatus.success,
      data: LibraryData(all: all, filter: event.filter),
    ));
  }
}
