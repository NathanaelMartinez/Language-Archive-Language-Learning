import 'package:flutter/material.dart';
import 'content_provider_scenario_screen.dart';

class ContentProviderSelectionScreen extends StatefulWidget {
  @override
  State<ContentProviderSelectionScreen> createState() => _ContentProviderSelectionScreenState();
}

class _ContentProviderSelectionScreenState extends State<ContentProviderSelectionScreen>  {
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contribute',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 25
                ),
              )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contribute content to a scenario',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15
                ),
              )
            )
          ]
        ),
        centerTitle: false,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            // Logout button
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }, 
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.blue
                  ),
                )
              ),
            )
          ],
        )
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return _scrollingCPSelection();
        }
      ),
    );
  }
  
  Widget _scrollingCPSelection() {
    return Center(
      child: ListView(
        children: [
          // Scenario Scroll:
          // TODO: Will need to include curated scenarios
          SizedBox(height: 20),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '[Scenario Title]',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: ((context) => ContentProviderScenarioScreen())),
                        );                        
                      }, 
                      child: const Text('View')
                    )
                  )
                ]
              ),
            )
          ),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '[Scenario Title]',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: ((context) => ContentProviderScenarioScreen())),
                        );                           
                      }, 
                      child: const Text('View')
                    )
                  )
                ]
              ),
            )
          ),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '[Scenario Title]',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: ((context) => ContentProviderScenarioScreen())),
                        );
                      }, 
                      child: const Text('View')
                    )
                  )
                ]
              ),
            )
          ),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '[Scenario Title]',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: ((context) => ContentProviderScenarioScreen())),
                        );
                      }, 
                      child: const Text('View')
                    )
                  )
                ]
              ),
            )
          ),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '[Scenario Title]',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: ((context) => ContentProviderScenarioScreen())),
                        );
                      }, 
                      child: const Text('View')
                    )
                  )
                ]
              ),
            )
          ),
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '[Scenario Title]',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: ((context) => ContentProviderScenarioScreen())),
                        );
                      }, 
                      child: const Text('View')
                    )
                  )
                ]
              ),
            )
          ),
        ],
      )
    );
  }
}