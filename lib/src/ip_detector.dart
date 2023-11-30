import 'package:flutter/foundation.dart';

import '../ip_detector.dart';

/// ## [IpDetector] class :
///
/// A class for detecting IP information using an API.
///
/// The [IpDetector] class allows you to retrieve details about the current user's IP address,
/// such as country, region, city, etc., by making requests to an external API.
///
class IpDetector {
  /// [timeout] : The timeout duration for API requests.
  final Duration? timeout;

  /// ## [IpDetector] Constructor :
  ///
  /// Creates an `IpDetector` with an optional [timeout] for API requests.
  ///
  /// The `timeout` parameter specifies the duration for API requests, and the default
  /// value is set to 30 seconds.
  ///
  IpDetector({this.timeout = const Duration(seconds: 30)});

  /// [_response] Variable :
  ///
  /// The last response received from the IP detection API.
  ///
  IpDetectorResponseModel? _response;

  /// ## [getResponse] Getter Method :
  ///
  /// Gets the last response received from the IP detection API.
  ///
  /// Returns the last `IpDetectorResponseModel` received from the API.
  ///
  IpDetectorResponseModel? get getResponse => _response;

  /// [setResponse] Method :
  ///
  /// Sets the response for the IP detection API.
  ///
  /// The [value] parameter is an [IpDetectorResponseModel] containing the response
  /// received from the API.
  ///
  setResponse(IpDetectorResponseModel? value) {
    _response = value;
  }

  /// ## [fetch] Method :
  ///
  /// Fetches IP information by making an API request.
  ///
  /// The [fetch] method sends a request to the 'http://demo.ip-api.com/json/' endpoint
  /// to retrieve information about the current IP address. It decodes the JSON response
  /// and then processes the response using [responseHasResult] if successful.
  ///
  /// If an exception occurs during the request, it catches the exception, generates
  /// an error response using [responseHasError], and returns the error response.
  ///
  /// Returns an [IpDetectorResponseModel] containing either the retrieved data or error details.
  ///
  /// ### Parameters
  /// - [enableLog] : A boolean flag indicating whether to enable logging.
  /// If set to true, additional logs will be printed during the fetch process. Defaults to false.
  ///
  Future<IpDetectorResponseModel> fetch({bool? enableLog = false}) async {
    try {
      Map<String, dynamic> jsonResponse = jsonDecode(
          (await get(Uri.parse('http://demo.ip-api.com/json/'))
                  .timeout(timeout!))
              .body);
      return responseHasResult(jsonResponse, enableLog);
    } on Exception catch (e) {
      return responseHasError("$e", enableLog);
    }
  }

  /// ## [responseHasResult] Method :
  ///
  /// Process the API response when it contains successful results.
  ///
  /// The `responseHasResult` method takes a [Map] of [String] to [dynamic] data,
  /// typically representing the response from the IP detection API. It checks if
  /// the status in the response is "success". If it is, it creates a successful
  /// [IpDetectorResponseModel], sets the response using [setResponse], and returns
  /// the response.
  ///
  /// If the status is not "success", it creates a failed response [IpDetectorResponseModel],
  /// sets the response, and returns the response.
  ///
  /// The successful response includes various details such as country, region, city, etc.,
  /// and is of type [IpDetectorResponseType.succeedResponse].
  ///
  /// When the status in the API response is not "success," the [responseHasResult]
  /// method creates a failed response [IpDetectorResponseModel]. It sets the response
  /// type to [IpDetectorResponseType.failedResponse] and includes details about the failure,
  /// such as the status and an error message.
  ///
  /// The failed response is then set using [setResponse], and the method returns the current response.
  ///
  /// Additionally, if the [enableLog] parameter is set to `true`, the method prints the type
  /// and data of the current response using `debugPrint`.
  ///
  IpDetectorResponseModel responseHasResult(Map<String, dynamic> data,
      [bool? enableLog = false]) {
    if ("${data["status"]}".toLowerCase() == "success") {
      setResponse(IpDetectorResponseModel(
        data: {
          "status": "${data["status"]}",
          "country": "${data["country"]}",
          "countryCode": "${data["countryCode"]}",
          "region": "${data["region"]}",
          "regionName": "${data["regionName"]}",
          "city": "${data["city"]}",
          "zip": "${data["zip"]}",
          "lat": "${data["lat"]}",
          "lon": "${data["lon"]}",
          "timezone": "${data["timezone"]}",
          "isp": "${data["isp"]}",
          "org": "${data["org"]}",
          "as": "${data["as"]}",
          "query": "${data["query"]}"
        },
        type: IpDetectorResponseType.succeedResponse,
      ));
      if (enableLog == true) {
        debugPrint("type:${getResponse!.type}");
        debugPrint("data:${getResponse!.data}");
      }
      return getResponse!;
    } else {
      setResponse(IpDetectorResponseModel(
          type: IpDetectorResponseType.failedResponse,
          data: {
            "status": IpDetectorResponseType.failedResponse.status,
            "error": IpDetectorResponseType.failedResponse.message
          }));
      if (enableLog == true) {
        debugPrint("type:${getResponse!.type}");
        debugPrint("data:${getResponse!.data}");
      }
      return getResponse!;
    }
  }

  /// ## [responseHasError] Method :
  ///
  /// Processes the API response with errors.
  ///
  /// Based on the error message, the method sets the appropriate error response
  /// and returns the [IpDetectorResponseModel].
  ///
  /// Additionally, if the [enableLog] parameter is set to `true`, the method prints the type
  /// and data of the current response using `debugPrint`.
  ///
  IpDetectorResponseModel responseHasError(String errorMessage,
      [bool? enableLog = false]) {
    // Convert the error message to lowercase for case-insensitive comparison.
    final String error = errorMessage.toLowerCase();

    // Check if the error message contains socket or handshake related issues.
    if (error.contains(IpDetectorExceptionTypes.socket.message) ||
        error.contains(IpDetectorExceptionTypes.handshake.message)) {
      // Set the response with the network issue type and details.
      setResponse(
        IpDetectorResponseModel(
            type: IpDetectorResponseType.networkIssue,
            data: {
              "status": IpDetectorResponseType.networkIssue.status,
              "error": IpDetectorResponseType.networkIssue.message
            }),
      );
      if (enableLog == true) {
        debugPrint("type:${getResponse!.type}");
        debugPrint("data:${getResponse!.data}");
      }
      return getResponse!;
    }

    // Check if the error message contains timeout-related issues.
    if (error.contains(IpDetectorExceptionTypes.timeout.message)) {
      // Set the response with the timeout issue type and details.
      setResponse(
        IpDetectorResponseModel(
          type: IpDetectorResponseType.timeOutIssue,
          data: {
            "status": IpDetectorResponseType.timeOutIssue.status,
            "error": IpDetectorResponseType.timeOutIssue.message
          },
        ),
      );
      if (enableLog == true) {
        debugPrint("type:${getResponse!.type}");
        debugPrint("data:${getResponse!.data}");
      }
      return getResponse!;
    }

    // Check if the error message contains wrong response variables formats.
    if (error.contains(IpDetectorExceptionTypes.format.message)) {
      setResponse(
        IpDetectorResponseModel(
          type: IpDetectorResponseType.formatExceptionIssue,
          data: {
            "status": IpDetectorResponseType.formatExceptionIssue.status,
            "error": IpDetectorResponseType.formatExceptionIssue.message
          },
        ),
      );
      if (enableLog == true) {
        debugPrint("type:${getResponse!.type}");
        debugPrint("data:${getResponse!.data}");
      }
      return getResponse!;
    }

    // If none of the specific issues are identified, set the response as other errors.
    setResponse(
      IpDetectorResponseModel(
        type: IpDetectorResponseType.otherErrors,
        data: {
          "status": IpDetectorResponseType.otherErrors.status,
          "error": IpDetectorResponseType.otherErrors.message
        },
      ),
    );
    if (enableLog == true) {
      debugPrint("type:${getResponse!.type}");
      debugPrint("data:${getResponse!.data}");
    }
    return getResponse!;
  }

  /// ## [country] Method :
  ///
  /// Gets the `country` information from the last API response.
  ///
  String? country() => getResponse?.data?["country"];

  /// ## [countryCode] Method :
  ///
  /// Gets the `countryCode` information from the last API response.
  ///
  String? countryCode() => getResponse?.data?["countryCode"];

  /// ## [region] Method :
  ///
  /// Gets the `region` information from the last API response.
  ///
  String? region() => getResponse?.data?["region"];

  /// ## [regionName] Method :
  ///
  /// Gets the `regionName` information from the last API response.
  ///
  String? regionName() => getResponse?.data?["regionName"];

  /// ## [city] Method :
  ///
  /// Gets the `city` information from the last API response.
  ///
  String? city() => getResponse?.data?["city"];

  /// ## [zip] Method :
  ///
  /// Gets the `zip` code information from the last API response.
  ///
  String? zip() => getResponse?.data?["zip"];

  /// ## [lat] Method :
  ///
  /// Gets the `lat` information from the last API response.
  ///
  String? lat() => getResponse?.data?["lat"];

  /// ## [lon] Method :
  ///
  /// Gets the `lon` information from the last API response.
  ///
  String? lon() => getResponse?.data?["lon"];

  /// ## [timezone] Method :
  ///
  /// Gets the `timezone` information from the last API response.
  ///
  String? timezone() => getResponse?.data?["timezone"];

  /// ## [isp] Method :
  ///
  /// Gets the `isp` information from the last API response.
  ///
  String? isp() => getResponse?.data?["isp"];

  /// ## [org] Method :
  ///
  /// Gets the `org` information from the last API response.
  ///
  String? org() => getResponse?.data?["org"];

  /// ## [as] Method :
  ///
  /// Gets the `as` or `Autonomous System` information from the last API response.
  ///
  String? as() => getResponse?.data?["as"];

  /// ## [query] Method :
  ///
  /// Gets the `query` information from the last API response.
  ///
  String? query() => getResponse?.data?["query"];

  /// ## [type] Method :
  ///
  /// Gets the `type` information from the last API response.
  /// This method attempts to access the type property of the last response received by the IpDetector instance (getResponse) .
  ///
  IpDetectorResponseType? type() => getResponse?.type;
}
