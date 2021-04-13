import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FirestorePage extends StatelessWidget {
  static const id = 'firestore_page';

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    Auth auth = Provider.of<Auth>(context);
    return StreamBuilder(
        stream: auth.onAuthStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;

            isLoggedIn = (user == null) ? false : true;
            return FirestorePageView(isLoggedIn, auth.getAuthCurrentUserUID);
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class FirestorePageView extends StatefulWidget {
  FirestorePageView(this.isUserLoggedIn, this.uid);
  bool isUserLoggedIn;
  String uid;
  @override
  _FirestorePageViewState createState() => _FirestorePageViewState();
}

class _FirestorePageViewState extends State<FirestorePageView> {
  bool isInEditingMode = true;
  TextEditingController _editingController;
  String note;
  DocumentReference usersNote;
  Function getUserDoc;
  FirebaseFirestore firestore;
  bool isUserLoggedIn;
  String uid;

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
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
    isUserLoggedIn = widget.isUserLoggedIn;
    uid = widget.uid;
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex("Firestore");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    if (uid.isNotEmpty) {
      usersNote = firestore.collection('users').doc(uid);
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
