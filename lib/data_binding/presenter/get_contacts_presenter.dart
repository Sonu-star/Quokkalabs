import '../../../api/data/rest_ds.dart';

abstract class GetContactsContract {
  void onGetContactsError(String errorTxt);
  void onGetContactsSuccess(dynamic response);
}


class GetContactsPresenter {
  final GetContactsContract _view;
  RestDataSource api = RestDataSource();

  GetContactsPresenter(this._view);

  Future getContacts() async {
    try {
      var res = await api.getContacts();
      return _view.onGetContactsSuccess(res);
    } catch (e) {
      return _view.onGetContactsError(e.toString());
    }
  }

}