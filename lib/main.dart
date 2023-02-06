import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokkalabs/data_binding/provider/get_contacts_provider.dart';
import 'package:quokkalabs/view/contact/contact_list.dart';

import 'data_binding/provider/get_call_history_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetContactsProvider()),
        ChangeNotifierProvider(create: (_) => GetCallHistoryProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ContactList(),

      ),
    );
  }
}


