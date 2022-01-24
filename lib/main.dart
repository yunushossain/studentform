import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studentform/user.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = "My App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  TextEditingController addressController = TextEditingController();
  // int gender = 0;
  var _gender ;
  var courseTypes = ["Gave","Jee","WPS"];

  var selectedCourseType ;

  // bool valuefirst = false;
  // bool valuesecond = false;
  // bool valuethird = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Student',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Registration form',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Student Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(

                controller: mobileController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                // obscureText: true,
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Gender :"),
            ),

            ListTile(
              title: const Text('Male'),
              leading: Radio(
                value: "male",
                groupValue: _gender,
                onChanged: ( value) {
                  setState(() {
                    _gender = value;
                  });
                },
                activeColor: Colors.red,
              ),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio(
                value: "female",
                groupValue: _gender,
                onChanged: ( value) {
                  setState(() {
                    _gender = value;
                  });
                },
                activeColor: Colors.red,
              ),
            ),


            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Courses :"),
            ),


            DropdownButtonFormField(

              items: courseTypes.map((String coursetype){
                return DropdownMenuItem(
                  value: coursetype,
                  child: Text(coursetype),
                );
              }).toList(),
              onChanged: (newValue){
                setState(() => selectedCourseType = newValue);
              },
              value: selectedCourseType,
            ),




            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(

                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),


            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    print(nameController.text);
                    print(mobileController.text);
                    print(emailController.text);
                    print(selectedCourseType);

                    print(addressController.text);
                    print(_gender);


                    String name = nameController.text.toString();
                    String email = emailController.text.toString();
                    String mobile = mobileController.text.toString();
                    String address = addressController.text.toString();
                    // String gen = gender == 0? 'Male': 'Female';


                    User user = new User(
                        address:address,
                        courses: selectedCourseType,
                        email: email ,
                        gender: _gender,
                        mobile: mobile,
                        name: name
                    );
                    fetchResult(user).then((res) {

                      print(res.body.toString());
                      const snackBar = SnackBar(
                        content: Text('registration Successfull'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);



                    });
                  },
                )
            ),

          ],
        ));
  }
}






Future<http.Response> fetchResult(User user) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  final response = await http
      .post(Uri.parse('http://localhost:8082/student/save'),headers: requestHeaders,body: jsonEncode(user.toMap()));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return  response;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}