import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:quokkalabs/data_binding/presenter/get_contacts_presenter.dart';

import '../../utils/loader.dart';


class GetContactsProvider extends ChangeNotifier implements GetContactsContract {
  late GetContactsPresenter getContactsPresenter;
  late BuildContext providerContext;

  // late List<GetContactsModel> getContactsList = [];
  // late GetContactsModel getContactsData;


  GetContactsProvider() {
    getContactsPresenter = GetContactsPresenter(this);
  }


  void getContacts({required BuildContext context}) {
    providerContext = context;
    onLatestLoading(true, providerContext);
    getContactsPresenter.getContacts();
  }

  @override
  void onGetContactsError(String errorTxt) {
    onLatestLoading(false, providerContext);
    print('ERROR $errorTxt');
  }

  late List<Contact> contacts = [];

  @override
  void onGetContactsSuccess(response) {
    onLatestLoading(false, providerContext);
     contacts = response;
    notifyListeners();
  }
}
