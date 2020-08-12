import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/sign_in/terms_and_conditions_text.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms And Conditions'),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  child: Text(
                    TERMS_AND_CONDITIONS_TEXT,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text(
                      'I AGREE TO TERMS AND CONDITIONS',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text(
                      'I DO NOT AGREE',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
