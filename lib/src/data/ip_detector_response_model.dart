import '../../ip_detector.dart';

/// ## [IpDetectorResponseModel] Class :
///
/// Model class representing the response from the IP detection API.
///
/// The [IpDetectorResponseModel] class encapsulates the data and type of
/// response received from the IP detection API. It includes a [data] field,
/// which is a map containing details about the IP address, and a [type] field,
/// representing the response type, defined by the [IpDetectorResponseType] enum.
///
class IpDetectorResponseModel {
  /// A map containing details about the IP address, such as country, region, etc.
  final Map<String, dynamic>? data;

  /// The type of the response, indicating success or failure.
  final IpDetectorResponseType type;

  /// Creates an instance of [IpDetectorResponseModel].
  ///
  /// The [type] parameter specifies the response type, and [data] is an optional
  /// map containing details about the IP address.
  IpDetectorResponseModel({required this.type, this.data});
}
