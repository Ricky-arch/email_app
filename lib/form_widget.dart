import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send1() async {
    String username = 'srvsutradhar13@gmail.com';
    String password = '8787300192';
    final smtpServer = gmail(username, password);
    final messaged = Message()
      ..from = Address(username, name.text)
      ..recipients.add('srvsutradhar7@gmail.com')
      ..subject = subject.text + ' ${DateTime.now()}'
      ..text = message.text
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(messaged, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);

    await connection.send(messaged);

    await connection.close();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    emailController.dispose();
    subject.dispose();
    message.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: name,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter Name*';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(.8)),
                            hintText: "Name"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter Email*';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(.8)),
                            hintText: "Email"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: subject,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter Subject*';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(.8)),
                            hintText: "Subject"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: message,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter Message*';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(.8)),
                            hintText: "Message"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.yellow,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await send1();
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Sending ur Quote')));
                      }
                    },
                    child: Text('Send Message'),
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
