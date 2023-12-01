![Screenshot](https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/ip_detector/ip_detector_banner.png?raw=true "Flutter Glass Banner")

# IP Detector plugin

A flutter package that can identify a user's IP and collect more information from it.

## Installation

To use this plugin, add ip_detector in your `pubspec.yaml`

```
dependencies:
  ip_detector: ^0.0.2
```

Or install automatically using this command

```
$ flutter pub add ip_detector
```

## Super simple to use :

For example in a StateFul class follow the steps below.

**Step 1 :** Add Import

```dart
import 'package:ip_detector/ip_detector.dart';
```   

**Step 2 :** Initial object

```dart
  late final IpDetector ipDetector;
  Future<IpDetectorResponseModel>? ipDetectionFuture;

@override
void initState() {
  ipDetector = IpDetector(timeout: const Duration(seconds: 10));
  ipDetectionFuture = ipDetector.fetch(enableLog: true);
  super.initState();
}
```   

**Step 3 :** Get IP Information And Show In UI

```dart
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("DemoScreen")),
    // FutureBuilder Widget : Handles different states (Waiting, Succeed, and Error) during the IP detection process.
    body: FutureBuilder(
      future: ipDetectionFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          // This code scope includes `Succeed` and `Error` states.
          if (snapshot.data!.type == IpDetectorResponseType.succeedResponse) {
            // This code scope is `Succeed` state , and `ListView` widget displays IP-related information when the detection is successful.
            return ListView(
              children: [
                Text('Country : ${ipDetector.country()}'),
                Text('Region Name : ${ipDetector.regionName()}'),
                Text('City : ${ipDetector.city()}'),
                Text('IP : ${ipDetector.query()}'),
                Text('ISP : ${ipDetector.isp()}'),
                Text('Latitude: ${ipDetector.lat()}'),
                Text('Longitude : ${ipDetector.lon()}'),
                Text('Time Zone : ${ipDetector.timezone()}'),
              ],
            );
          } else {
            // This code scope is `Error` state , and `MaterialButton` widget displays a retry button for error states to allow users to attempt IP detection again.
            return Center(
              child: MaterialButton(
                  shape: const StadiumBorder(),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  child: const Text('RETRY BUTTON'),
                  onPressed: () {
                    ipDetectionFuture = ipDetector.fetch(enableLog: true);
                    setState(() {});
                  }
              ),
            );
          }
        } else {
          // This code scope is `Waiting` State , and `CircularProgressIndicator` widget shown during the waiting state.
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
        child: const Text('RETRY'), onPressed: () {
      ipDetectionFuture = ipDetector.fetch(enableLog: true);
      setState(() {});
    }),
  );
}
```

---

#### Example UI for `Succeed` response :

<img src="https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/ip_detector/succeed.gif?raw=true"/>

---

#### Example UI for retry button for `Failed`/`Error`/`Exception` response :

<img src="https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/ip_detector/retry.gif?raw=true"/>

---

## License
This SDK is available under the MIT license.
