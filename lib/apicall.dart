import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'insert_user.dart';


class ApiCall extends StatefulWidget {
  const ApiCall({Key? key}) : super(key: key);

  @override
  State<ApiCall> createState() => _ApiCallState();
}

class _ApiCallState extends State<ApiCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD NEW DATA'),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
            highlightColor: Colors.red,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Insert_User(null);
                  },
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {});
                }
              });
            },
          )
        ],
      ),
      body: FutureBuilder<http.Response>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = jsonDecode(snapshot.data!.body.toString());
            data.reversed;
            return ListView.builder(
              itemCount: jsonDecode(snapshot.data!.body.toString()).length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Insert_User(jsonDecode(
                              snapshot.data!.body.toString())[index]);
                        },
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {});
                      }
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    (jsonDecode(snapshot.data!.body.toString())[
                                            index]['ProductName'])
                                        .toString(),
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              deleteAlert((jsonDecode(
                                      snapshot.data!.body.toString())[index]
                                  ['Product_id'].toString()));
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: getData(),
      ),
    );
  }

  Future<http.Response> getData() async {
    var Response = await http
        .get(Uri.parse('https://630ee82f498924524a816254.mockapi.io/product'));
    return Response;
  }

  Future<http.Response> deletedata(id) async {
    print("Function access======================================$id");
    var Response = await http.delete(
        Uri.parse('https://630ee82f498924524a816254.mockapi.io/product/$id'));
    return Response;
  }

  void deleteAlert(id) {
    print("=================================$id");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert!'),
            content: Text('Are you sure to delete this record?'),
            actions: [
              TextButton(
                onPressed: () async {
                  http.Response res = await deletedata(id);
                  if (res.statusCode == 200) {
                    setState(() {

                    });
                  }
                  Navigator.of(context).pop();
                  print('item deleted');
                },
                child: Text('yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              )
            ],
          );
        });
  }
}
