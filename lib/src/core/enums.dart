/// ## [IpDetectorResponseType] Enum Class :
///
/// Enum representing different response types for [IpDetector].
///
/// The [IpDetectorResponseType] enum defines various response types that
/// the API might return. Each type has an associated [message] and [status].
/// These types help categorize the nature of the response received.
///
enum IpDetectorResponseType {
  succeedResponse("succeed", "success"),
  failedResponse("unable to receive data.", "fail"),
  networkIssue("unable to connect the internet.", "fail"),
  timeOutIssue(
      "the attempt to connect to the internet failed due to a timeout.",
      "fail"),
  formatExceptionIssue(
      "the attempt to connect to the internet was unsuccessful due to bad response format.",
      "fail"),
  otherErrors("the received response has error.", "fail");

  final String? message;
  final String? status;

  const IpDetectorResponseType(this.message, this.status);
}

/// ## [IpDetectorExceptionTypes] Enum Class :
///
/// Enum representing different exception types for [IpDetector].
///
/// The [IpDetectorExceptionTypes] enum defines various exception types
/// that might occur during the API request. Each type has an associated [message].
///
enum IpDetectorExceptionTypes {
  timeout("timeoutexception"),
  handshake("handshakeexception"),
  socket("socketexception"),
  format("formatexception");

  final String message;

  const IpDetectorExceptionTypes(this.message);
}
