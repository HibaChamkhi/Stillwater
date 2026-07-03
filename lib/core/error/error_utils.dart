import 'package:dartz/dartz.dart';
import 'exception.dart';

/// Maps any known exception to a human, gentle message.
String mapExceptionToMessage(Exception e) {
  if (e is CacheException) return e.message;
  if (e is SerializationException) return e.message;
  if (e is UnknownException) return e.message;
  return 'Something slipped — try again in a moment.';
}

/// Wraps a local (offline) operation into an Either, mirroring the
/// `performNetworkRequest` helper used for remote sources in the starter.
Future<Either<Exception, T>> performLocalRequest<T>(
  Future<T> Function() operation,
) async {
  try {
    return Right(await operation());
  } on Exception catch (e) {
    return Left(e);
  } catch (e) {
    return Left(UnknownException(message: e.toString()));
  }
}
