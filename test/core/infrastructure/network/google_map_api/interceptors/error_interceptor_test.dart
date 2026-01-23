import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:deliverzler/core/infrastructure/network/google_map_api/interceptors/error_interceptor.dart';

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class MockDioException extends Mock implements DioException {}

void main() {
  late MockResponseInterceptorHandler mockResponseInterceptorHandler;
  late MockErrorInterceptorHandler mockErrorInterceptorHandler;
  late ErrorInterceptor errorInterceptor;

  setUpAll(() {
    registerFallbackValue(MockDioException());
  });

  setUp(() {
    mockResponseInterceptorHandler = MockResponseInterceptorHandler();
    mockErrorInterceptorHandler = MockErrorInterceptorHandler();
    errorInterceptor = ErrorInterceptor();
  });

  group('onResponse', () {
    test(
      "should call handler.reject if response.data['status'] != 'OK' "
      // `RejectError` will be handled at the onError callBack.
      'with DioException: [same response, same response.requestOptions, RejectError]',
      () async {
        // GIVEN
        final tResponse = Response(
          requestOptions: RequestOptions(),
          data: {'status': 'invalid'},
          statusCode: 200,
        );
        // WHEN
        errorInterceptor.onResponse(tResponse, mockResponseInterceptorHandler);
        // THEN
        verify(
          () => mockResponseInterceptorHandler.reject(
            any(
              that: isA<DioException>()
                  .having((e) => e.response, 'response', equals(tResponse))
                  .having(
                    (e) => e.response?.requestOptions,
                    'requestOptions',
                    equals(tResponse.requestOptions),
                  )
                  .having((e) => e.error, 'error', isA<RejectError>()),
            ),
            true,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockResponseInterceptorHandler);
      },
    );

    test(
      "should call handler.next if response.data['status'] == 'OK'",
      () async {
        // GIVEN
        final tResponse = Response(
          requestOptions: RequestOptions(),
          data: {'status': 'OK'},
          statusCode: 200,
        );
        // WHEN
        errorInterceptor.onResponse(tResponse, mockResponseInterceptorHandler);
        // THEN
        verify(() => mockResponseInterceptorHandler.next(tResponse)).called(1);
        verifyNoMoreInteractions(mockResponseInterceptorHandler);
      },
    );
  });

  group('onError', () {
    const tErrorMessage = 'error_message_test';
    const resultStatusCode = 400;
    const resultErrorType = DioExceptionType.badResponse;

    test(
      'should call handler.next if error is not RejectError',
      () async {
        // GIVEN
        final tError = DioException(
          response: Response(
            requestOptions: RequestOptions(),
            data: {'status': tErrorMessage},
            statusCode: 500,
          ),
          requestOptions: RequestOptions(),
        );
        // WHEN
        await errorInterceptor.onError(tError, mockErrorInterceptorHandler);
        // THEN
        verify(() => mockErrorInterceptorHandler.next(tError)).called(1);
        verifyNoMoreInteractions(mockErrorInterceptorHandler);
      },
    );

    test(
      'should call handler.reject if the error is RejectError '
      'with proper DioException: [error message from backend / statusCode 400 / DioExceptionType.badResponse]',
      () async {
        // GIVEN
        final tError = DioException(
          response: Response(
            requestOptions: RequestOptions(),
            data: {'status': tErrorMessage},
            statusCode: 500,
          ),
          requestOptions: RequestOptions(),
          error: RejectError(),
        );
        // WHEN
        await errorInterceptor.onError(tError, mockErrorInterceptorHandler);
        // THEN
        verify(
          () => mockErrorInterceptorHandler.reject(
            any(
              that: isA<DioException>()
                  .having((e) => e.response?.statusCode, 'statusCode', equals(resultStatusCode))
                  .having((e) => e.error, 'error', equals(tErrorMessage))
                  .having((e) => e.type, 'type', equals(resultErrorType)),
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockErrorInterceptorHandler);
      },
    );

    /*
    test(
      'should override DioException message with error message from backend '
      'and override DioException type with DioExceptionType.response '
      'if response.statusCode is 400',
      () async {
        // GIVEN
        final tError = DioException(
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error_description': tErrorMessage},
            statusCode: 400,
          ),
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.other,
        );
        // WHEN
        errorInterceptor.onError(tError, mockErrorInterceptorHandler);
        // THEN
        expect(tError.message, tErrorMessage);
        expect(tError.type, tErrorType);
        expect(tError.response!.statusCode, 400);
      },
    );

    test(
      'should call handler.reject if response.statusCode is 400',
      () async {
        // GIVEN
        final tError = DioException(
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error_description': tErrorMessage},
            statusCode: 400,
          ),
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.other,
        );
        // WHEN
        errorInterceptor.onError(tError, mockErrorInterceptorHandler);
        // THEN
        verify(() => mockErrorInterceptorHandler.reject(tError)).called(1);
        verifyNoMoreInteractions(mockErrorInterceptorHandler);
      },
    );

    test(
      'should override DioException message with error message from backend '
      'and override DioException type with DioExceptionType.response '
      'if response.statusCode is 424',
      () async {
        // GIVEN
        final tError = DioException(
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error_description': tErrorMessage},
            statusCode: 424,
          ),
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.other,
        );
        // WHEN
        errorInterceptor.onError(tError, mockErrorInterceptorHandler);
        // THEN
        expect(tError.message, tErrorMessage);
        expect(tError.type, tErrorType);
        expect(tError.response!.statusCode, 424);
      },
    );

    test(
      'should call handler.reject if response.statusCode is 424',
      () async {
        // GIVEN
        final tError = DioException(
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error_description': tErrorMessage},
            statusCode: 424,
          ),
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.other,
        );
        // WHEN
        errorInterceptor.onError(tError, mockErrorInterceptorHandler);
        // THEN
        verify(() => mockErrorInterceptorHandler.reject(tError)).called(1);
        verifyNoMoreInteractions(mockErrorInterceptorHandler);
      },
    ); */
  });
}
