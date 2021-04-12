import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FirestorePage extends StatefulWidget {
  static const id = 'firestore_page';
  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  bool isInEditingMode = true;
  TextEditingController _editingController;
  String note;
  FirebaseFirestore firestore;
  FirebaseAuth _auth;
  DocumentReference usersNote;
  Function getUserDoc;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _editingController = TextEditingController();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserDoc();
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex("Firestore");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    if (_auth != null) {
      if (_auth.currentUser != null) {
        isUserLoggedIn = true;
        usersNote = firestore.collection('users').doc(_auth.currentUser.uid);
      }
    }

    getUserDoc = () async {
      if (isUserLoggedIn) {
        DocumentSnapshot doc = await usersNote.get();
        Map<String, dynamic> userData = doc.data();
        setState(() {
          if (userData != null) {
            _editingController.value = TextEditingValue(text: userData['note']);
            isInEditingMode = userData['editMode'];
          } else {
            print('userData not found');
          }
        });
      }
    };

    saveNote() {
      if (isUserLoggedIn) {
        usersNote
            .set({
              'note': _editingController.text,
              'editMode': isInEditingMode,
            })
            .then((value) => print("Note Added"))
            .catchError((error) => print("Failed to add note: $error"));
      } else {
        _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
        _pageController
            .jumpToPage(_pageNavigator.getPageIndex("FirebaseAuthLogin"));
      }
    }

    Widget lastRow() {
      Widget rowWidget;
      rowWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                'Editing Mode',
                style: TextStyle(fontSize: 20),
              ),
              Switch.adaptive(
                value: isInEditingMode,
                onChanged: (bool newValue) {
                  setState(() {
                    isInEditingMode = newValue;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              saveNote();
            },
            child: Text('Save'),
          ),
        ],
      );
      return rowWidget;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: Colors.teal.shade50,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: TextField(
                    controller: _editingController,
                    maxLines: null,
                    expands: true,
                    maxLength: 1000,
                    readOnly: !isInEditingMode,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a short note.',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          lastRow(),
        ],
      ),
    );
  }
}
