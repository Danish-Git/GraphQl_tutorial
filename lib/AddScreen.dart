import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  TextEditingController _id = TextEditingController();
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _gen = TextEditingController();
  TextEditingController _ipadd = TextEditingController();

  String _queryString = r"""
            mutation insert_data($id: Int!, $fname: String!, $lname: String!, $email: String!, $gen: String!, $ipadd: String!) {
            insert_mockdata(objects: {id: $id, first_name: $fname, last_name: $lname, email: $email, gender: $gen, ip_address: $ipadd}) {
              returning {
                id
                first_name
                last_name
                email
                gender
                ip_address
              }
            }
          }
      """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Screen"),
      ),
      body: Mutation(
        options: MutationOptions(
          document:  gql(_queryString),
        ),
        builder: (RunMutation insert, QueryResult result) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(controller: _id, decoration: InputDecoration(hintText: "Id"),),
                TextField(controller: _fname, decoration: InputDecoration(hintText: "First Name"),),
                TextField(controller: _lname, decoration: InputDecoration(hintText: "Last Name"),),
                TextField(controller: _email, decoration: InputDecoration(hintText: "Email"),),
                TextField(controller: _gen, decoration: InputDecoration(hintText: "Gender"),),
                TextField(controller: _ipadd, decoration: InputDecoration(hintText: "IP Address"),),
                RaisedButton(onPressed: () {
                  insert(<String, dynamic> {
                    "id": int.parse(_id.text.trim()),
                    "fname": _fname.text.trim(),
                    "lname": _lname.text.trim(),
                    "email": _email.text.trim(),
                    "gen": _gen.text.trim(),
                    "ipadd": _ipadd.text.trim()
                  });
                  },
                child: Text("submit".toUpperCase()),),
                Text("Result : \n ${result.data?.values?.toString()}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
