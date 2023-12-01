import 'package:flutter/material.dart';
import 'package:ip_detector/ip_detector.dart';

/// ## [DemoScreen] Class Documentation:
///
/// The `IpDetectorWidget` class is a Flutter `StatefulWidget` that demonstrates the usage of the `IpDetector` class for fetching IP-related information and handling different states.
void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple.shade900,
            foregroundColor: Colors.white),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade900),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    ),
  );
}

/// ## [DemoScreen] Class Documentation:
///
/// The `IpDetectorWidget` class is a Flutter `StatefulWidget` that demonstrates the usage of the `IpDetector` class for fetching IP-related information and handling different states.
///
/// ### Class Overview:
///
/// - This class displays a screen with IP-related information fetched using the `IpDetector` class.
/// - It demonstrates the use of `FutureBuilder` to handle different states (Waiting, Succeed, and Error) during the IP detection process.
/// - The screen includes a retry button for error states to allow users to attempt IP detection again.
///
class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

/// ### [_DemoScreenState] Class Overview:
///
/// - This class is part of the state management for the [DemoScreen] widget.
/// - It initializes an instance of the `IpDetector` class in the `initState` method with a specified timeout duration of one second.
/// - The chosen timeout duration is intentionally short for testing and observing timeout scenarios during IP detection.
///
/// ### Properties:
///
/// - [ipDetector] : An instance of the `IpDetector` class used for fetching IP-related information.
/// - [ipDetectionFuture] : A future representing the IP detection process, used in the `FutureBuilder`.
///
/// ### Initialization:
///
/// - The [initState] method is overridden to create an instance of the `IpDetector` class during the widget's initialization.
/// - The chosen timeout duration of one second ensures a relatively short wait time during the IP detection process.
///
class _DemoScreenState extends State<DemoScreen> {
  late final IpDetector ipDetector;
  Future<IpDetectorResponseModel>? ipDetectionFuture;

  @override
  void initState() {
    /// Creates an instance of the `IpDetector` class.
    /// The chosen timeout duration of ten seconds is intentionally set for testing and observing timeout scenarios.
    ipDetector = IpDetector(timeout: const Duration(seconds: 10));

    /// Initiates the IP detection process and assigns the resulting future to `ipDetectionFuture`.
    ipDetectionFuture = ipDetector.fetch(enableLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DemoScreen"),
      ),
      // FutureBuilder Widget : Handles different states (Waiting, Succeed, and Error) during the IP detection process.
      body: FutureBuilder(
        future: ipDetectionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
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
                    color: Theme.of(context).primaryColor,
                    child: const Text('RETRY BUTTON'),
                    onPressed: () {
                      ipDetectionFuture = ipDetector.fetch(enableLog: true);
                      setState(() {});
                    }),
              );
            }
          } else {
            // This code scope is `Waiting` State , and `CircularProgressIndicator` widget shown during the waiting state.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Text('RETRY'),
          onPressed: () {
            ipDetectionFuture = ipDetector.fetch(enableLog: true);
            setState(() {});
          }),
    );
  }
}
