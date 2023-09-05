import 'package:datamites/helper/color.dart';
import 'package:datamites/model/freshdesk/freshdesk_response_model.dart';
import 'package:datamites/model/freshdesk/frestdesk_code.dart';
import 'package:datamites/pages/freshdesk/ticket_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FreshDeskCard extends StatelessWidget {
  final FreshdeskResponseModel freshdeskData;
  final FreshDeskConstant freshDeskConstant = new FreshDeskConstant();
  final DateFormat formatter = DateFormat.yMMMd().add_jms();

  FreshDeskCard(this.freshdeskData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle idStyle = TextStyle(
        fontSize: 32,
        color: freshDeskConstant.getStatusColor(freshdeskData.status)[1],
        fontWeight: FontWeight.w600);
    TextStyle idNameStyle = new TextStyle(
        fontSize: 12,
        color: freshDeskConstant.getStatusColor(freshdeskData.status)[1],
        fontWeight: FontWeight.w600);
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TicketDetailPage(freshdeskData.id)));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: MainColor.textColorFaint),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                    color: freshDeskConstant
                        .getStatusColor(freshdeskData.status)[0]),
                child: Column(
                  children: [
                    Text(
                      "Ticket ID",
                      style: idNameStyle,
                    ),
                    Text(
                      freshdeskData.id.toString(),
                      style: idStyle,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            color: freshDeskConstant
                                .getStatusColor(freshdeskData.status)[0]),
                        child: Text(
                          freshDeskConstant.getStatusName(freshdeskData.status),
                          style: TextStyle(
                              fontSize: 8,
                              color: freshDeskConstant
                                  .getStatusColor(freshdeskData.status)[1]),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            color: freshDeskConstant
                                .getPriorityColor(freshdeskData.priority)[0]),
                        child: Text(
                          "Priority: ${freshDeskConstant.getPriorityName(freshdeskData.priority)}",
                          style: TextStyle(
                              fontSize: 8,
                              color: freshDeskConstant
                                  .getPriorityColor(freshdeskData.priority)[1]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    freshdeskData.type,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(freshdeskData.subject),
                  Text(
                    DateFormat()
                        .format(DateTime.parse(freshdeskData.created_at)),
                    style: TextStyle(
                        color: MainColor.textColorConst, fontSize: 10),
                    textAlign: TextAlign.end,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
