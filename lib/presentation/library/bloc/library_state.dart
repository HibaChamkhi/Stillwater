part of 'library_bloc.dart';

class LibraryData extends Equatable {
  const LibraryData({required this.all, required this.filter});

  final List<Practice> all;
  final String filter;

  List<Practice> get visible => filter == 'All'
      ? all
      : all.where((p) => p.category == filter).toList();

  @override
  List<Object?> get props => [all, filter];
}

class LibraryState extends UIState<LibraryData> {
  const LibraryState({super.status, super.message, super.data});

  @override
  LibraryState copyWith({UIStatus? status, String? message, LibraryData? data}) {
    return LibraryState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
