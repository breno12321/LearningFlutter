import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

String contactTable = "contactTable";
String idColumn = "idColumn";
String nameColumn = "nameColumn";
String emailColumn = "emailColumn";
String phoneColumn = "phoneColumn";
String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map<String, dynamic>> response = await dbContact.query(contactTable,
        columns: [
          idColumn,
          nameColumn,
          emailColumn,
          phoneColumn,
          imgColumn,
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (response.length > 0) {
      return Contact.fromMap(response.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact c) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, c.toMap(),
        where: "$idColumn = ?", whereArgs: [c.id]);
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    List listResponse = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for (Map m in listResponse) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future<void> closeConn() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> mapContact = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    if (id != null) {
      mapContact[idColumn] = id;
    }
    return mapContact;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }

  int id;
  String name;
  String email;
  String phone;
  String img;
}
