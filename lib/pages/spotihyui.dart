import 'package:flutter/material.dart';

class Spotify extends StatefulWidget {
  const Spotify({super.key});

  @override
  State<Spotify> createState() => _SpotifyState();
}

class _SpotifyState extends State<Spotify> {
  var Sections = [
    {"Sect": 'Liked songs', "pics": "link.com"},
    {"Sect": 'Strike(Holster)', "pics": "link.com"},
    {"Sect": 'Hip Hop Mix', "pics": "link.com"},
    {"Sect": 'ODUMODUBLVCK', "pics": "link.com"},
    {"Sect": 'This is ODUMODUBLVCK', "pics": "link.com"},
    {"Sect": 'Travis Scott', "pics": "link.com"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: Colors.black26,
          title: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Good morning',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  )),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.notifications_none_sharp,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.history, color: Colors.white),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 8, right: 0, bottom: 8, top: 8),
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Text(
                        'Music',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Text(
                        'Podcasts & Shows',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8),
                itemCount: 6,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  return Section(
                    sectname: Sections[index]['Sect'],
                    sectpic: Sections[index]['pics'],
                  );
                },
              ),
            ),
            Container()
          ],
        ));
  }
}

class Section extends StatelessWidget {
  final sectname;
  final sectpic;
  const Section({super.key, required this.sectname, required this.sectpic});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.withOpacity(0.5),
      child: Row(),
    );
  }
}
