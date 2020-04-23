import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/section.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/section/menu_section_details_form.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuSectionDetailsPage extends StatelessWidget {
  final Session session;
  final Database database;
  final Section section;

  const MenuSectionDetailsPage({Key key, this.session, this.database, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter menu section details'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: MenuSectionDetailsForm.create(
                context, session, database, section),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
