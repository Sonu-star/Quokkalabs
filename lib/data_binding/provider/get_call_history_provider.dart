import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:quokkalabs/data_binding/presenter/get_call_history_presenter.dart';
import 'package:quokkalabs/model/model.dart';
import '../../utils/loader.dart';


class GetCallHistoryProvider extends ChangeNotifier implements GetCallHistoryContract {
  late GetCallHistoryPresenter getCallHistoryPresenter;
  late BuildContext providerContext;
  late List<CallHistoryModel> callHistory = [];


  GetCallHistoryProvider() {
    getCallHistoryPresenter = GetCallHistoryPresenter(this);
  }

  void getCallHistory({required String searchNumber, required BuildContext context}) {
    providerContext = context;
    onLatestLoading(true, providerContext);
    getCallHistoryPresenter.getCallHistory(searchNumber: searchNumber);
    callHistory.clear();

  }

  @override
  void onGetCallHistoryError(String errorTxt) {
    onLatestLoading(false, providerContext);
    print('ERROR $errorTxt');
  }


  @override
  void onGetCallHistorySuccess(response) {
    onLatestLoading(false, providerContext);
    callHistory = response;
    notifyListeners();
  }
}
