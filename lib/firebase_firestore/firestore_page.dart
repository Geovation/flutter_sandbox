import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key key}) : super(key: key);
  static const id = 'firestore_page';

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  bool isInEditingMode = true;
  TextEditingController _editingController;
  DocumentReference<Map<String, dynamic>> usersNote;
  Function getUserDoc;
  FirebaseFirestore firestore;
  bool isUserLoggedIn = false;
  String uid = "";

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
    final AppSettings appSettings = Provider.of<AppSettings>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);
    final FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context);
    analytics.logEvent(name: 'firestore_page');
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    final PageController _pageController = _pageNavigator.getPageController;
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex("Firestore");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    Auth auth = Provider.of<Auth>(context);
    isUserLoggedIn = auth.getUserLoginStatus;
    uid = auth.getAuthCurrentUserUID;

    if (uid.isNotEmpty) {
      usersNote = firestore.collection('users').doc(uid);
    }

    getUserDoc = () async {
      if (isUserLoggedIn) {
        DocumentSnapshot<Map<String, dynamic>> doc = await usersNote.get();
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
                localizations.firestoreEditingMode,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Semantics(
                checked: isInEditingMode,
                label: '${localizations.semFirestorePgEditSwitchButton}',
                child: Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: isInEditingMode,
                  onChanged: (bool newValue) {
                    setState(() {
                      isInEditingMode = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          Semantics(
            button: true,
            label: localizations.semFirestorePgSaveButton,
            child: ElevatedButton(
              onPressed: () {
                saveNote();
              },
              child: Text(
                localizations.firestoreSave,
              ),
            ),
          ),
        ],
      );
      return rowWidget;
    }

    Widget bodyView = SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: (appSettings.getCurrentThemeMode == ThemeMode.light)
                ? Colors.teal.shade100
                : Colors.teal.shade900,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Semantics(
                    textField: true,
                    label: localizations.firestoreEnterAShortNote,
                    child: TextField(
                      controller: _editingController,
                      maxLines: null,
                      expands: true,
                      maxLength: 1000,
                      readOnly: !isInEditingMode,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: localizations.firestoreEnterAShortNote,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
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

    return bodyView;
  }
}
