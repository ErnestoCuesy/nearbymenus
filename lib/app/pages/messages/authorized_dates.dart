import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';

class AuthorizedDates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var startDate = DateUtils.getFirstDayOfCurrentMonth();
    var endDate = DateUtils.getLastDayOfNextMonth();
    List<DateTime> authorizedDates = List<DateTime>();
    Calendarro monthCalendarro = Calendarro(
        startDate: startDate,
        endDate: endDate,
        displayMode: DisplayMode.MONTHS,
        selectionMode: SelectionMode.MULTI,
        weekdayLabelsRow: CustomWeekdayLabelsRow(),
        onTap: (date) {
          if (authorizedDates.contains(date)) {
            authorizedDates.remove(date);
          } else {
            authorizedDates.add(date);
          }
          print("onTap: $date");
        });
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select access dates'),
      ),
      body: Column(
        children: <Widget>[
          Container(height: 32.0),
          monthCalendarro,
          FormSubmitButton(
            context: context,
            text: 'Authorize',
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(authorizedDates),
          ),
        ],
      ),
    );
  }
}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}