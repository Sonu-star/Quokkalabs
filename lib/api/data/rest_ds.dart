import 'dart:async';

import 'package:call_log/call_log.dart';
import 'package:contacts_service/contacts_service.dart';

import '../../model/model.dart';

class RestDataSource {
  List<CallHistoryModel> callHistory = [];
  CallHistoryModel callHistoryModel = CallHistoryModel();
  //var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt); // 12/31/2000, 10:00 PM



  //@@@@@@@@@@@@@@@@
  Future getContacts() async {
    List<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    return contacts;
  }

  Future getHistory({required String searchNumber}) async{

    final Iterable<CallLogEntry> result = await CallLog.query();
    result.forEach((element) {
      if(element.number==searchNumber) {
        callHistory.add(
          CallHistoryModel(
              date: '${DateTime.fromMillisecondsSinceEpoch(element.timestamp!)}',
              simName: element.simDisplayName,
              mobileNumber: '${element.formattedNumber}',
              duration: '${element.duration}')
      );
      }
    });
    return callHistory;

  }






}
