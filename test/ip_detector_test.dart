import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ip_detector/src/ip_detector.dart';
import 'package:ip_detector/src/core/enums.dart';
import 'package:ip_detector/src/data/ip_detector_response_model.dart';

void main() {
  group('IpDetector Response Testing', () {
    test('Test `failed response` ', () async {
      final ipDetector = IpDetector();
      IpDetectorResponseModel sampleMockData = IpDetectorResponseModel(
        data: {
          'status': IpDetectorResponseType.failedResponse.status,
          'error': IpDetectorResponseType.failedResponse.message
        },
        type: IpDetectorResponseType.failedResponse,
      );
      ipDetector.setResponse(sampleMockData);

      expect(
          ipDetector.getResponse?.type, IpDetectorResponseType.failedResponse);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(sampleMockData.type,
          ipDetector.responseHasResult(sampleMockData.data!).type);
      expect(sampleMockData.data,
          ipDetector.responseHasResult(sampleMockData.data!).data);

      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.failedResponse.status);
    });

    test('Test `succeed response` ', () async {
      final ipDetector = IpDetector();
      IpDetectorResponseModel sampleMockData = IpDetectorResponseModel(
        data: {
          "status": "success",
          "country": "Latvia",
          "countryCode": "LV",
          "region": "RIX",
          "regionName": "Riga",
          "city": "Riga",
          "zip": "LV-1063",
          "lat": "56.9496",
          "lon": "24.0978",
          'timezone': "Europe/Riga",
          'isp': "Melbikomas UAB",
          "org": "Melbikomas UAB",
          'as': "AS56630 Melbikomas UAB",
          "query": "185.135.85.66"
        },
        type: IpDetectorResponseType.succeedResponse,
      );
      ipDetector.setResponse(sampleMockData);

      expect(
          ipDetector.getResponse?.type, IpDetectorResponseType.succeedResponse);
      expect(ipDetector.getResponse?.data?.values, sampleMockData.data?.values);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(sampleMockData.type,
          ipDetector.responseHasResult(sampleMockData.data!).type);
      expect(sampleMockData.data,
          ipDetector.responseHasResult(sampleMockData.data!).data);
      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.succeedResponse.status);

      expect(ipDetector.country(), ipDetector.getResponse?.data!['country']);

      expect(ipDetector.countryCode(),
          ipDetector.getResponse?.data!['countryCode']);

      expect(ipDetector.region(), ipDetector.getResponse?.data!['region']);

      expect(
          ipDetector.regionName(), ipDetector.getResponse?.data!['regionName']);

      expect(ipDetector.city(), ipDetector.getResponse?.data!['city']);

      expect(ipDetector.zip(), ipDetector.getResponse?.data!['zip']);

      expect(ipDetector.lat(), ipDetector.getResponse?.data!['lat']);

      expect(ipDetector.lon(), ipDetector.getResponse?.data!['lon']);

      expect(ipDetector.timezone(), ipDetector.getResponse?.data!['timezone']);

      expect(ipDetector.isp(), ipDetector.getResponse?.data!['isp']);

      expect(ipDetector.org(), ipDetector.getResponse?.data!['org']);

      expect(ipDetector.as(), ipDetector.getResponse?.data!['as']);

      expect(ipDetector.query(), ipDetector.getResponse?.data!['query']);

      expect(ipDetector.type(), ipDetector.getResponse?.type);
    });
  });

  group('IpDetector Catch Error Testing', () {
    test('Test `Handshake Exception`', () async {
      final ipDetector = IpDetector();

      late String errorMessage;
      try {
        throw const HandshakeException("");
      } catch (e) {
        errorMessage = "$e".toLowerCase();
      }
      ipDetector.responseHasError(errorMessage);
      expect(ipDetector.getResponse?.type, IpDetectorResponseType.networkIssue);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.networkIssue.status);
      expect(ipDetector.getResponse?.data!['error'],
          IpDetectorResponseType.networkIssue.message!);
      expect(errorMessage.contains(IpDetectorExceptionTypes.handshake.message),
          true);
    });

    test('Test `Socket Exception`', () async {
      final ipDetector = IpDetector();

      late String errorMessage;
      try {
        throw const SocketException("");
      } catch (e) {
        errorMessage = "$e".toLowerCase();
      }
      ipDetector.responseHasError(errorMessage);
      expect(ipDetector.getResponse?.type, IpDetectorResponseType.networkIssue);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.networkIssue.status);
      expect(ipDetector.getResponse?.data!['error'],
          IpDetectorResponseType.networkIssue.message!);
      expect(
          errorMessage.contains(IpDetectorExceptionTypes.socket.message), true);
    });

    test('Test `Timeout Exception`', () async {
      final ipDetector = IpDetector();

      late String errorMessage;
      try {
        throw TimeoutException("");
      } catch (e) {
        errorMessage = "$e".toLowerCase();
      }
      ipDetector.responseHasError(errorMessage);
      expect(ipDetector.getResponse?.type, IpDetectorResponseType.timeOutIssue);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.timeOutIssue.status);
      expect(ipDetector.getResponse?.data!['error'],
          IpDetectorResponseType.timeOutIssue.message);
      expect(errorMessage.contains(IpDetectorExceptionTypes.timeout.message),
          true);
    });

    test('Test `Format Exception`', () async {
      final ipDetector = IpDetector();

      late String errorMessage;
      try {
        throw const FormatException("");
      } catch (e) {
        errorMessage = "$e".toLowerCase();
      }
      ipDetector.responseHasError(errorMessage);
      expect(ipDetector.getResponse?.type,
          IpDetectorResponseType.formatExceptionIssue);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.formatExceptionIssue.status);
      expect(ipDetector.getResponse?.data!['error'],
          IpDetectorResponseType.formatExceptionIssue.message);

      expect(
          errorMessage.contains(IpDetectorExceptionTypes.format.message), true);
    });

    test('Test `Other Errors`', () async {
      final ipDetector = IpDetector();

      late String errorMessage;
      try {
        throw Exception("");
      } catch (e) {
        errorMessage = "$e".toLowerCase();
      }
      ipDetector.responseHasError(errorMessage);
      expect(ipDetector.getResponse?.type, IpDetectorResponseType.otherErrors);
      expect(ipDetector.getResponse?.data, isNotNull);
      expect(ipDetector.getResponse?.data!['status'],
          IpDetectorResponseType.otherErrors.status);
      expect(ipDetector.getResponse?.data!['error'],
          IpDetectorResponseType.otherErrors.message);
    });
  });
}
