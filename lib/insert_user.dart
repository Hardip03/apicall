import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Insert_User extends StatefulWidget {

  Map? map;
  Insert_User(this.map);

  @override
  State<Insert_User> createState() => _Insert_UserState();
}

class _Insert_UserState extends State<Insert_User> {
  var userNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = widget.map==null?'':widget.map!['ProductName'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Text(
                          'Enter UserName',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: userNameController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter UserName';
                          }
                        },
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if(widget.map==null){
                                    insertUser().then((value) => Navigator.of(context).pop(true));
                                  }
                                  else{
                                    updateUser(widget.map!['Product_id']).then((value) => Navigator.of(context).pop(true));
                                  }
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Future<void> insertUser() async{
    Map map = {};

    map['ProductName']=userNameController.text;

    var response1 = await http.post(Uri.parse('https://630ee82f498924524a816254.mockapi.io/product'),body: map);
    print(response1.body);
  }


  Future<void> updateUser(id) async{
    Map map = {};

    map['ProductName']=userNameController.text;

    var response1 = await http.put(Uri.parse('https://630ee82f498924524a816254.mockapi.io/product/$id'),body: map);
    print(response1.body);
  }
}
