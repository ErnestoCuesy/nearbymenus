import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/custom_weekday_label_row.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';

class AuthorizedDates extends StatelessWidget {
  final List<dynamic> authorizedIntDates;

  const AuthorizedDates({Key key, this.authorizedIntDates,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startDate = DateUtils.getFirstDayOfCurrentMonth();
    var endDate = DateUtils.getLastDayOfCurrentMonth();
    final DateFormat monthName = DateFormat(DateFormat.MONTH);
    final month = monthName.format(startDate);
    List<DateTime> selectedDates = List<DateTime>();
    authorizedIntDates.forEach((intDate) {
      selectedDates.add(DateTime.fromMillisecondsSinceEpoch(intDate));
    });
    Calendarro monthCalendarro = Calendarro(
        startDate: startDate,
        endDate: endDate,
        displayMode: DisplayMode.MONTHS,
        selectionMode: SelectionMode.MULTI,
        selectedDates: selectedDates,
        weekdayLabelsRow: CustomWeekdayLabelsRow(),
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Select authorized dates'),
      ),
      body: Column(
        children: <Widget>[
          Container(height: 32.0),
          Text(month,
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(height: 32.0),
          monthCalendarro,
          Container(height: 32.0),
          FormSubmitButton(
            context: context,
            text: 'Save',
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(selectedDates),
          ),
        ],
      ),
    );
  }
}
