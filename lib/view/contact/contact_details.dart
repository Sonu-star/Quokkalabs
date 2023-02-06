import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokkalabs/data_binding/provider/get_call_history_provider.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;
  const ContactDetails({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool isEdit = true;

  @override
  void initState() {
    GetCallHistoryProvider getCallHistoryProvider =  Provider.of<GetCallHistoryProvider>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getCallHistoryProvider.getCallHistory(searchNumber: widget.contact.phones![0].value!, context: context);
    });
    nameController = TextEditingController(text: widget.contact.displayName);
    numberController = TextEditingController(text: '${widget.contact.phones![0].value}');
    super.initState();
  }

  updateContact() async{
    Contact c = widget.contact;

    c.displayName = nameController.text;
    //c.phones = [Item(label: 'Mobile', value: numberController.text)];

    await ContactsService.updateContact(c);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Consumer<GetCallHistoryProvider>(builder: (context,data,child){
        return SafeArea(child: ListView(
          children: [

            Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: CustomPaint(
                    painter: CurvedPainter(),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      child:

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: (){Navigator.pop(context);},
                            child:  const Icon(Icons.arrow_back_ios_new, size: 20,color: Colors.black,),
                          ),
                          Expanded(child: Container()),

                          isEdit?
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isEdit = false;
                              });
                            },
                            child: const Icon(Icons.edit, size: 20,color: Colors.blue,),
                          ): GestureDetector(
                            onTap: (){
                              setState(() {
                                isEdit = true;
                              });
                              updateContact();
                            },
                            child: const Icon(Icons.save, size: 20,color: Colors.blue,),
                          ),
                          const SizedBox(width: 20,)
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade500,
                      child: Text(
                        widget.contact.displayName![0],
                        style: const TextStyle(
                            fontSize: 29,
                            color: Colors.black
                        ),
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 65,
                      alignment: Alignment.center,
                      child:  isEdit?
                      Text(
                        widget.contact.displayName!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ):
                      TextField(
                        textAlign: TextAlign.center,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        autocorrect: false,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter name',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87
                          ),
                        ),

                      ),
                    ),

                  ],
                )

              ],
            ),
            const SizedBox(height: 20,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.phone,size: 27,color: Colors.grey,),
                  const SizedBox(width: 10,),
                  Text(
                    '${widget.contact.phones![0].value}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87
                    ),
                  ),
                  Expanded(child: Container()),
                  const Icon(Icons.video_camera_back_outlined,size: 27,color: Colors.blue,),
                  const SizedBox(width: 20,),
                  const Icon(Icons.chat_bubble_outline_outlined,size: 27,color: Colors.blue,),
                  const SizedBox(width: 10,),
                ],
              ),
            ),

            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Call History',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height/2.3,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.callHistory.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.callHistory[index].date!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(10)
                                      ),

                                      child: Text(data.callHistory[index].simName!),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(data.callHistory[index].mobileNumber!),

                                  ],
                                )


                              ],
                            ),
                            Expanded(child: Container()),
                            Text(
                              'Duration : ${data.callHistory[index].duration!} Sec',
                              textAlign: TextAlign.start,
                            ),
                          ],
                        )
                    );
                  }),
            )
          ],
        ));

      })
    );
  }
}


class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 15;

    var path = Path();

    //path.moveTo(0, size.height * 0.5);
    path.addArc(Rect.fromCenter(center: Offset(size.width/2,size.height * 0.3), width: size.width*1.7, height: 300), 100, 300);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
