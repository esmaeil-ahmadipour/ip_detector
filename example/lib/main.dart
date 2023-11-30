import 'package:flutter/material.dart';
import 'package:ip_detector/ip_detector.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyHomePage(),
  ));
}

/// # [MyHomePage] Widget Class :
///
/// ## Overview
/// The `MyHomePage` class is a stateful widget that represents the main home page of the Flutter application.
/// It utilizes the `IpDetector` class to fetch information about the user's IP address.
/// The UI dynamically adapts based on the response received from the API.
///
/// ## Properties
/// - **ipDetector**: An instance of the `IpDetector` class used to manage and retrieve IP-related information.
///
/// ## Methods
/// - **initState**: Initializes the state of the widget, creating an instance of `IpDetector` with a specified timeout duration.
/// - **build**: Builds the widget tree based on the current state, displaying a Scaffold with an AppBar and a body containing a FutureBuilder.
///
/// ## `build` Method Logic
/// 1. **AppBar**: Displays an AppBar with a title.
/// 2. **Body**: Utilizes a `FutureBuilder` to handle the asynchronous IP address fetch operation.
///    - **Loading State**: Displays a circular progress indicator while waiting for the response.
///    - **Done State**: Determines the UI based on the type of response.
///      - **Succeed Response**: Calls the `buildSucceedUI` method to display a column with information about the country, city, and IP address.
///      - **Other States**: Calls the `buildOtherThanSucceedUI` method to display a retry button.
///
/// ## Helper Methods
/// ### 1. `buildSucceedUI`
/// - **Description**: Builds a column widget containing information about the country, city, and IP address.
/// - **Return Type**: Widget
///
/// ### 2. `buildOtherThanSucceedUI`
/// - **Description**: Builds a center-aligned widget containing the `RetryButton`.
/// - **Return Type**: Widget
///
/// ## Widget Documentation
/// ### `RetryButton` Widget
/// - **Description**: A `FloatingActionButton` with an icon for retrying an operation.
/// - **Properties**:
///   - `onPress`: A callback function triggered when the button is pressed.
///
/// ### `TextWidget` Widget
/// - **Description**: A customizable text widget based on the title and font size.
/// - **Properties**:
///   - `title`: The text content to be displayed.
///   - `largeText`: A boolean indicating whether to use a large font size (default is false).
///
/// This `MyHomePage` class creates a responsive and dynamic user interface based on the asynchronous IP address fetch operation,
/// enhancing the user experience by displaying relevant information or providing the option to retry the operation in case of failure.
/// The `RetryButton` and `TextWidget` widgets contribute to the modularity and readability of the code.
///
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IpDetector ipDetector;

  @override
  void initState() {
    //  creates an instance of the `IpDetector` class.
    // The chosen timeout duration of one second is intentionally short for testing and observing timeout scenarios.
    ipDetector = IpDetector(timeout: const Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: FutureBuilder(
          future: ipDetector.fetch(enableLog: true),
          builder: (context, snapshot) {
            // when request send and getting data from api (may be get error/succeed state)

            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              // for show succeed ui , we can limit state on succeed like below conditions.

              if (snapshot.data!.type ==
                  IpDetectorResponseType.succeedResponse) {
                // we can show succeed widget in this place .

                return buildSucceedUI();
              } else {
                // we can show other widget for any state in this place.
                // another states may be one of below list :
                //   `IpDetectorResponseType.failedResponse`
                //   `IpDetectorResponseType.networkIssue`
                //   `IpDetectorResponseType.timeOutIssue`
                //   `IpDetectorResponseType.formatExceptionIssue`
                //   `IpDetectorResponseType.otherErrors`
                // in this sample code below ui (below ui is an retry button) used for any state except `IpDetectorResponseType.succeedResponse` .

                return buildOtherThanSucceedUI();
              }
            } else {
              // when request send and waiting for response
              // we can show loading widget in this place .

              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // Helper method to build UI for states other than succeed response.

  Widget buildOtherThanSucceedUI() {
    return Center(
      child: RetryButton(
        onPress: () {
          setState(() {});
        },
      ),
    );
  }

  // Helper method to build UI for succeed response.

  Widget buildSucceedUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const TextWidget('Country :', largeText: true),
        TextWidget('${ipDetector.country()}'),
        const Divider(height: 32),
        const TextWidget(
          'City :',
          largeText: true,
        ),
        TextWidget('${ipDetector.city()}'),
        const Divider(height: 32),
        const TextWidget('IP :', largeText: true),
        TextWidget('${ipDetector.query()}'),
        Container(
          padding: const EdgeInsetsDirectional.only(end: 16),
          alignment: AlignmentDirectional.bottomEnd,
          child: RetryButton(
            onPress: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}

/// ## [RetryButton] Widget Class:
///
/// A FloatingActionButton with an icon for retrying an operation.
///
class RetryButton extends StatelessWidget {
  const RetryButton({super.key, this.onPress});

  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPress,
      child: const Icon(Icons.refresh),
    );
  }
}

/// ## [TextWidget] Widget Class:
///
/// A customizable Text widget based on title and font size..
///
class TextWidget extends StatelessWidget {
  const TextWidget(this.title, {super.key, largeText});

  final String title;
  final bool? largeText = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: largeText!
          ? Theme.of(context).textTheme.headlineLarge
          : Theme.of(context).textTheme.headlineSmall,
    );
  }
}
