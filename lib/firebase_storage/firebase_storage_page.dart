import 'dart:io' as io;

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sandbox/app_settings.dart';
import 'package:flutter_sandbox/auth.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'save_as/save_as.dart';

/// Enum representing the upload task types the example app supports.
enum UploadType {
  string,
  file,
  clear,
}

class FirebaseStoragePage extends StatefulWidget {
  static const id = "firebase_storage_page";
  const FirebaseStoragePage({Key key}) : super(key: key);

  @override
  _FirebaseStoragePageState createState() => _FirebaseStoragePageState();
}

class _FirebaseStoragePageState extends State<FirebaseStoragePage> {
  List<firebase_storage.UploadTask> _uploadTasks = [];

  /// The user selects a file, and the task is added to the list.
  Future<firebase_storage.UploadTask> uploadFile(PickedFile file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/some-image.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }

  firebase_storage.UploadTask uploadString() {
    const String putStringText =
        'This upload has been generated using the putString method! Check the metadata too!';

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/put-string-example.txt');

    // Start upload of putString
    return ref.putString(putStringText,
        metadata: firebase_storage.SettableMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'example': 'putString'}));
  }

  Future<void> handleUploadType(UploadType type) async {
    final PageNavigatorCustom _pageNavigator =
        context.read<PageNavigatorCustom>();

    if (!context.read<Auth>().getUserLoginStatus) {
      _pageNavigator.getPageController
          .jumpToPage(_pageNavigator.getPageIndex("FirebaseAuthLogin"));
      return;
    }

    switch (type) {
      case UploadType.string:
        setState(() {
          _uploadTasks = [..._uploadTasks, uploadString()];
        });
        break;
      case UploadType.file:
        PickedFile file =
            await ImagePicker().getImage(source: ImageSource.gallery);
        firebase_storage.UploadTask task = await uploadFile(file);
        if (task != null) {
          setState(() {
            _uploadTasks = [..._uploadTasks, task];
          });
        }
        break;
      case UploadType.clear:
        setState(() {
          _uploadTasks = [];
        });
        break;
    }
  }

  void _removeTaskAtIndex(int index) {
    setState(() {
      _uploadTasks = _uploadTasks..removeAt(index);
    });
  }

  Future<void> _downloadBytes(firebase_storage.Reference ref) async {
    final bytes = await ref.getData();
    await saveAsBytes(bytes, 'some-image.jpg');
  }

  Future<void> _downloadLink(firebase_storage.Reference ref) async {
    final link = await ref.getDownloadURL();

    await Clipboard.setData(ClipboardData(
      text: link,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Success!\n Copied download URL to Clipboard!',
        ),
      ),
    );
  }

  Future<void> _downloadFile(firebase_storage.Reference ref) async {
    final io.Directory systemTempDir = io.Directory.systemTemp;
    final io.File tempFile = io.File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
          'at path: ${ref.fullPath} \n'
          'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppSettings appSettings = Provider.of<AppSettings>(context);
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex('Cloud Storage');
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      floatingActionButton: Semantics(
        label: localizations.semFirestoreStoragePgFABButton,
        child: SpeedDial(
          marginEnd: 18,
          marginBottom: 20,
          icon: Icons.add,
          activeIcon: Icons.remove,
          buttonSize: 56.0,
          visible: true,
          closeManually: false,
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.white,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.redAccent.shade200,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.text_fields,
                color: Colors.grey.shade900,
              ),
              backgroundColor:
                  (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Colors.orange.shade200
                      : Colors.orange.shade900,
              labelBackgroundColor:
                  (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Colors.orange.shade200
                      : Colors.orange.shade900,
              label: 'Upload string',
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
              onTap: () => handleUploadType(UploadType.string),
            ),
            SpeedDialChild(
              child: Icon(
                Icons.file_copy,
                color: Colors.grey.shade900,
              ),
              backgroundColor:
                  (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Colors.orange.shade200
                      : Colors.orange.shade900,
              labelBackgroundColor:
                  (appSettings.getCurrentThemeMode == ThemeMode.light)
                      ? Colors.orange.shade200
                      : Colors.orange.shade900,
              label: 'Upload local file',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => handleUploadType(UploadType.file),
            ),
            if (_uploadTasks.isNotEmpty)
              SpeedDialChild(
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.grey.shade800,
                ),
                backgroundColor:
                    (appSettings.getCurrentThemeMode == ThemeMode.light)
                        ? Colors.orange.shade200
                        : Colors.orange.shade900,
                labelBackgroundColor:
                    (appSettings.getCurrentThemeMode == ThemeMode.light)
                        ? Colors.orange.shade200
                        : Colors.orange.shade900,
                label: 'Clear list',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => handleUploadType(UploadType.clear),
              ),
          ],
        ),
      ),
      body: _uploadTasks.isEmpty
          ? const Center(child: Text("Press the '+' button to add a new file."))
          : ListView.builder(
              itemCount: _uploadTasks.length,
              itemBuilder: (context, index) => UploadTaskListTile(
                task: _uploadTasks[index],
                onDismissed: () => _removeTaskAtIndex(index),
                onDownloadLink: () {
                  return _downloadLink(_uploadTasks[index].snapshot.ref);
                },
                onDownload: () {
                  if (kIsWeb) {
                    return _downloadBytes(_uploadTasks[index].snapshot.ref);
                  } else {
                    return _downloadFile(_uploadTasks[index].snapshot.ref);
                  }
                },
              ),
            ),
    );
  }
}

/// Displays the current state of a single UploadTask.
class UploadTaskListTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const UploadTaskListTile({
    Key key,
    this.task,
    this.onDismissed,
    this.onDownload,
    this.onDownloadLink,
  }) : super(key: key);

  final firebase_storage.UploadTask /*!*/ task;

  final VoidCallback onDismissed;

  final VoidCallback onDownload;

  final VoidCallback onDownloadLink;

  String _bytesTransferred(firebase_storage.TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_storage.TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (
        BuildContext context,
        AsyncSnapshot<firebase_storage.TaskSnapshot> asyncSnapshot,
      ) {
        Widget subtitle = const Text('---');
        firebase_storage.TaskSnapshot snapshot = asyncSnapshot.data;
        firebase_storage.TaskState state = snapshot?.state;

        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is firebase_core.FirebaseException &&
              (asyncSnapshot.error as firebase_core.FirebaseException).code ==
                  'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            // print(asyncSnapshot.error);
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null) {
          subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
        }

        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: ($) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (state == firebase_storage.TaskState.running)
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: task.pause,
                  ),
                if (state == firebase_storage.TaskState.running)
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: task.cancel,
                  ),
                if (state == firebase_storage.TaskState.paused)
                  IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: task.resume,
                  ),
                if (state == firebase_storage.TaskState.success)
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                if (state == firebase_storage.TaskState.success)
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: onDownloadLink,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
