import 'dart:io';
import 'package:contactsApp/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;

  final TextEditingController _nameController = new TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = new Contact();
      print(_editedContact.img);
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          title: Text(_editedContact.name ?? "Novo Contato"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/avatar.png"),
                      )),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((value) {
                    if (value == null) {
                      return;
                    } else {
                      setState(() {
                        _editedContact.img = value.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "name",
                ),
                onChanged: (value) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = value;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.email = value;
                },
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.phone = value;
                },
              ),
            ],
          ),
        ),
      ),
      onWillPop: _requestPop,
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Deseja descartar alterações?"),
                content: Text("Essa operação não pode ser desfeitas"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("Sim")),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")),
                ],
              ));
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
