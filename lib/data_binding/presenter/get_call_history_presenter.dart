import '../../../api/data/rest_ds.dart';

abstract class GetCallHistoryContract {
  void onGetCallHistoryError(String errorTxt);
  void onGetCallHistorySuccess(dynamic response);
}

class GetCallHistoryPresenter {
  final GetCallHistoryContract _view;
  RestDataSource api = RestDataSource();

  GetCallHistoryPresenter(this._view);

  Future getCallHistory({required String searchNumber}) async {
    try {
      var res = await api.getHistory(searchNumber: searchNumber);
      return _view.onGetCallHistorySuccess(res);
    } catch (e) {
      return _view.onGetCallHistoryError(e.toString());
    }
  }

}