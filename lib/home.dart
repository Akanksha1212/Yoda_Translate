import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController txt = TextEditingController();
  // ignore: non_constant_identifier_names
  Future<String> translated_text = Future.value('');

  Future<String> _translateYoda(String originalText) async {
    var url = 'https://api.funtranslations.com/translate/yoda';

    try {
      var response = await http.post(url, body: {'text': originalText});

      String body = response.body;
      Map<String, dynamic> decodedBody = jsonDecode(body);

      if (decodedBody.containsKey('contents')) {
        return decodedBody['contents']['translated'];
      } else {
        return 'Free limit(5 API Calls/Hour) reached! Please try again in an hour.';
      }
    } catch (e) {
      return 'Something went wrong, please restart the app and try again!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Write your text here...',
                    ),
                    onSubmitted: (String value) async {
                      translated_text = _translateYoda(value);
                      setState(() {});
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: FutureBuilder<String>(
                  future: translated_text,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Result:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${snapshot.data}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                        )
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        )
                      ];
                    } else {
                      children = <Widget>[
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 20,
                          height: 20,
                        ),
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
