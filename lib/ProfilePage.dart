import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:local_connection_first/singletons/AppData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // [User Input States]
  // final List<bool> _selections = [false, true];  // List<bool> _selections = List.generate(2, (_) => false);
  String _username = "", _password = "";


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the ProfilePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO: Get it working with svg
            Image(
              height: 100,
              // image: NetworkImage('https://api.dicebear.com/9.x/shapes/svg')
              image: AppData().loggedInUser.profileImage != null
                  ? NetworkImage(AppData().loggedInUser.profileImage ?? "")
                  : const AssetImage('assets/images/unknown-person-icon-question-mark.jpg'),
            ),
            if(!AppData().loggedInUser.isLoggedIn)
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email',
                      ),
                      onChanged: (value){
                        _username = value;
                      }
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value){
                        _password = value;
                      }
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primaryFixedDim),
                        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0)),
                      ),
                      onPressed: () async {
                        final success = await AppData().loggedInUser.login(_username, _password);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text('Login successful'),
                            ),
                          );
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                Text('Login failed'),
                            ),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),

            if(AppData().loggedInUser.isLoggedIn)
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      AppData().loggedInUser.username ?? "ERROR",
                    ),
                    // const Text(
                    //   'Profile2',
                    // ),
                    const Text(
                      'Auto-refresh Login',
                    ),
                    ToggleButtons(
                        isSelected: [AppData().loggedInUser.stayLoggedIn, !AppData().loggedInUser.stayLoggedIn],
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        fillColor: Theme.of(context).colorScheme.primaryContainer,
                        onPressed: (int index) {
                          setState(() {
                            // _selections[0] = !_selections[0];
                            // _selections[1] = !_selections[1];
                            AppData().loggedInUser.stayLoggedIn = !AppData().loggedInUser.stayLoggedIn;
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        borderWidth: 2,
                        borderColor: Theme.of(context).colorScheme.primary,
                        selectedBorderColor: Theme.of(context).colorScheme.primary,
                        children: const [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.my_location),
                              Icon(Icons.lock_clock),
                              Text('On'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.location_searching),
                              Icon(Icons.lock),
                              Text('Off'),
                            ],
                          ),
                        ]
                      ),
                  ]
              ),
            ),
            const Text(
              'About Us'
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.share, color: Theme.of(context).colorScheme.primary),
                      const Text('Share'),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.android, color: Theme.of(context).colorScheme.primary),
                      const Text('View'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(icon: const Icon(Icons.commit), color: Theme.of(context).colorScheme.primary, onPressed: () async {
                        // if (await canLaunchUrl(_githubUrl)) {
                        //   await launchUrl(_githubUrl);
                        // } else {
                        //   throw 'Could not launch $_githubUrl';
                        // }
                      }),
                      const Text('Github'),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     Icon(Icons.logout, color: Colors.green[500]),
                  //     const Text('Logout'),
                  //   ],
                  // ),
                ],
              ),
            ),




            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      //   child: Card(
      //     shadowColor: Colors.transparent,
      //     margin: const EdgeInsets.all(8.0),
      //     child: SizedBox.expand(
      //       child: Center(
      //         child: Text(
      //           'Profile',
      //           style: Theme.of(context).textTheme.titleLarge,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}