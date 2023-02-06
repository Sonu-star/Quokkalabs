import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quokkalabs/data_binding/provider/get_contacts_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'contact_details.dart';


class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final alphabets =
  List.generate(26, (index) => String.fromCharCode(index + 65));
  final ItemScrollController _itemScrollController = ItemScrollController();
  //final ItemPositionsListener _itemPositionsListener =ItemPositionsListener.create();
  String header = '';

  int _searchIndex = 0;


  @override
  void initState() {
    GetContactsProvider getContactsProvider =  Provider.of<GetContactsProvider>(context,listen: false);
    _askPermissions(getContactsProvider);
    super.initState();
  }

  Future<void> _askPermissions(GetContactsProvider provider) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (provider != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
           provider.getContacts(context: context);
        });
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }
  
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content:  Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GetContactsProvider>(builder: (context,data,child){
        return SafeArea(child:
          Stack(
            children: [
              SideHeaderListView(
                itemCount: data.contacts.length,
                padding: const EdgeInsets.all(16.0),
                itemExtend: 78.0,
                headerBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      width: 3.0,
                      child: Text(
                        data.contacts[index].displayName!.substring(0, 1),
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ));
                },
                itemBuilder: (BuildContext context, int index) {
                  Contact item = data.contacts[index];
                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ContactDetails(contact: item )));
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                              item.displayName![0],
                            style: const TextStyle(
                              fontSize: 29,
                              color: Colors.black
                            ),
                          ),
                        ),
                        title: Text(
                            item.displayName!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      //subtitle: Text(item.phones![0].value!),
                    ),
                  );
                },
                hasSameHeader: (int a, int b) {
                  return data.contacts[a].displayName!.substring(0, 1) ==  data.contacts[a].displayName!.substring(0, 1);
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: alphabets
                      .map((alphabet) => InkWell(
                    onTap: () {
                      setState(() {
                        _searchIndex = data.contacts.indexWhere((element) => element.displayName![0] == alphabet);
                        if (_searchIndex > 0) _itemScrollController.jumpTo(index: _searchIndex);
                      });

                    },
                    child: Text(
                      alphabet,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ))
                      .toList(),
                ),
              )
            ],
          ) ,

        );

      })
    );
  }

}
