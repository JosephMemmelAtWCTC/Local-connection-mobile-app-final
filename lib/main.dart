import 'package:flutter/material.dart';
import 'package:local_connection_first/ProfilePage.dart';
import 'package:local_connection_first/MapMainPage.dart';
import 'package:local_connection_first/ManagePage.dart';
import 'package:local_connection_first/helpers/ResourcesSystem.dart';
import 'package:local_connection_first/singletons/AppData.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),

    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});
  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;


  @override
  void initState() {
    super.initState();

    print("before");
    AppData().currentLocalLocations.then((locations) {
      print("LocalLocationsLength: ${locations.length}");
      // print("currentLocalLocations countA + ${locations}");
    }).catchError((error) {
      // Handle errors here
      print('Error updating count: $error');
    });
    print("after");

    AppData().updateUserLocation().then((_) {
      // Code to execute after the location is updated
      print('Location updated successfully!');
    }).catchError((error) {
      // Handle errors here
      print('Error updating location: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if(index == 0){
            // !!!!!!!!!!!!!!!NAV
          }
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            // icon: Badge(child: Icon(Icons.map)),
            icon: const Icon(Icons.map),
            label: 'Local',
          ),
          const NavigationDestination(
            // icon: Badge(
              // label: Text('2'),
              // child:
            icon: const Icon(Icons.edit),
            // ),
            label: 'Post',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.perm_identity_outlined),
            icon: const Icon(Icons.perm_identity),
            label: AppData().loggedInUser.isLoggedIn ? "Login" : "Profile",
          ),
        ],
      ),
      body: <Widget>[
        const MapMainPage(title: "Title"),
        /// Notifications page
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Column(
        //     children: <Widget>[
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 1'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 2'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        const ManagePage(title: "Title"),

        /// Messages page
        // ListView.builder(
        //   reverse: true,
        //   itemCount: 2,
        //   itemBuilder: (BuildContext context, int index) {
        //     if (index == 0) {
        //       return Align(
        //         alignment: Alignment.centerRight,
        //         child: Container(
        //           margin: const EdgeInsets.all(8.0),
        //           padding: const EdgeInsets.all(8.0),
        //           decoration: BoxDecoration(
        //             color: theme.colorScheme.primary,
        //             borderRadius: BorderRadius.circular(8.0),
        //           ),
        //           child: Text(
        //             'Hello',
        //             style: theme.textTheme.bodyLarge!
        //                 .copyWith(color: theme.colorScheme.onPrimary),
        //           ),
        //         ),
        //       );
        //     }
        //     return Align(
        //       alignment: Alignment.centerLeft,
        //       child: Container(
        //         margin: const EdgeInsets.all(8.0),
        //         padding: const EdgeInsets.all(8.0),
        //         decoration: BoxDecoration(
        //           color: theme.colorScheme.primary,
        //           borderRadius: BorderRadius.circular(8.0),
        //         ),
        //         child: Text(
        //           'Hi!',
        //           style: theme.textTheme.bodyLarge!
        //               .copyWith(color: theme.colorScheme.onPrimary),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        /// Profile page
          const ProfilePage(title: "Title")
      ][currentPageIndex],
    );
  }
}
