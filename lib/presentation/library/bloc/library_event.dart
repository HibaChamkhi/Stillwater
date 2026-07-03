part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadLibraryEvent extends LibraryEvent {}

class ChangeFilterEvent extends LibraryEvent {
  final String filter;

  const ChangeFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
