import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: ExpansionTile(
          initiallyExpanded: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Gander is required!';
                  }
                },
                onSaved: (value) {
                  print("Onsave Called for Gender");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Age is required!';
                  }
                },
                onSaved: (value) {
                  print("Onsave Called for Age");
                },
              ),
            )
          ],
          title: Text("Gender/Age"),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: ExpansionTile(
          initiallyExpanded: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'City is required!';
                  }
                },
                onSaved: (value) {
                  print("Onsave Called for City");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Country is required!';
                  }
                },
                onSaved: (value) {
                  print("Onsave Called for Country");
                },
              ),
            )
          ],
          title: Text("City/country"),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
