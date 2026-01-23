import 'package:dio/dio.dart';

import '../../../error/app_exception.dart';

extension GoogleMapErrorExtension on Object {
  ServerException googleMapErrorToServerException() {
    final error = this;

    if (error is DioException) {
      return error.dioToServerException();
    }

    return ServerException(
      type: ServerExceptionType.unknown,
      message: error.toString(),
    );
  }
}

extension _DioExceptionExtension on DioException {
  ServerException dioToServerException() {
    final statusCode = response?.statusCode;
    final message = error?.toString() ?? '';

    return switch (type) {
      DioExceptionType.badResponse => switch (statusCode) {
          //400 is our business logic errors code.
          //It's handled by error interceptors of each API.
          400 => ServerException(
              type: ServerExceptionType.general,
              message: message,
              code: statusCode,
            ),
          401 => ServerException(
              type: ServerExceptionType.unauthorized,
              message: message,
              code: statusCode,
            ),
          403 => ServerException(
              type: ServerExceptionType.forbidden,
              message: message,
              code: statusCode,
            ),
          404 || 405 || 501 => ServerException(
              type: ServerExceptionType.notFound,
              message: message,
              code: statusCode,
            ),
          409 => ServerException(
              type: ServerExceptionType.conflict,
              message: message,
              code: statusCode,
            ),
          500 || 502 => ServerException(
              type: ServerExceptionType.internal,
              message: message,
              code: statusCode,
            ),
          503 => ServerException(
              type: ServerExceptionType.serviceUnavailable,
              message: message,
              code: statusCode,
            ),
          _ => ServerException(
              type: ServerExceptionType.unknown,
              message: message,
              code: statusCode,
            ),
        },
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        ServerException(
          type: ServerExceptionType.timeOut,
          message: message,
          code: 408,
        ),
      DioExceptionType.connectionError => ServerException(
          type: ServerExceptionType.noInternet,
          message: message,
          code: 101,
        ),
      DioExceptionType.badCertificate => ServerException(
          type: ServerExceptionType.unknown,
          message: message,
          code: statusCode,
        ),
      DioExceptionType.cancel || DioExceptionType.unknown => ServerException(
          type: ServerExceptionType.unknown,
          message: message,
          code: statusCode,
        ),
    };
  }
}
