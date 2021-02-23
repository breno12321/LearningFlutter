import 'dart:io';

import 'package:contactsApp/helpers/contact_helper.dart';
import 'package:contactsApp/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contactsList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllContacts();
  }

  _getAllContacts() {
    helper.getAllContacts().then((value) {
      setState(() {
        contactsList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemBuilder: _contactCard,
        itemCount: contactsList.length,
        padding: EdgeInsets.all(10),
      ),
    );
  }

  Widget _contactCard(BuildContext ctx, int i) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: contactsList[i].img != null
                          ? FileImage(File(contactsList[i].img))
                          : AssetImage("images/avatar.png"),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactsList[i].name ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contactsList[i].email ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      contactsList[i].phone ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(ctx, i);
      },
    );
  }

  void _showOptions(BuildContext ctx, int i) {
    showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (ctx) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                            onPressed: () {
                              launch("tel:${contactsList[i].phone}");
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Ligar",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contact: contactsList[i]);
                            },
                            child: Text(
                              "Editar",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                            onPressed: () {
                              helper.deleteContact(contactsList[i].id);
                              setState(() {
                                contactsList.removeAt(i);
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              "Excluir",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final c = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ContactPage(
                  contact: contact,
                )));
    if (c != null) {
      if (contact != null) {
        await helper.updateContact(c);
      } else {
        await helper.saveContact(c);
      }
      _getAllContacts();
    }
  }
}
