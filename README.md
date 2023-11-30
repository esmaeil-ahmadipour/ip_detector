![Screenshot](https://github.com/esmaeil-ahmadipour/esmaeil-ahmadipour/blob/main/upload/packages/ip_detector/ip_detector_banner.png?raw=true "Flutter Glass Banner")

# IP Detector plugin

A flutter package that can identify a user's IP and collect more information from it.

## Installation

To use this plugin, add ip_detector in your `pubspec.yaml`

```
dependencies:
  ip_detector: ^0.0.1
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
    late IpDetector ipDetector;
    
    @override
    void initState() {
      ipDetector = IpDetector(timeout: const Duration(seconds: 1));
      super.initState();
    }
```   

**Step 3 :** Get IP Information And Show In UI

```dart
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: FutureBuilder(
          future: ipDetector.fetch(enableLog: true),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              // Succeed State OR Error State
              if (snapshot.data!.type ==
                  IpDetectorResponseType.succeedResponse) {
                // Succeed State
                return Text('Country from IP :${ipDetector.country()}');
              } else {
                // Error State
                return ElevatedButton(
                  child: const Text('RETRY BUTTON'),
                  onPressed: () {
                    setState(() {});
                  },
                );
              }
            } else {
              // Waiting State
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    }
```

## License
This SDK is available under the MIT license.
