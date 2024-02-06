import 'package:cloud_firestore/cloud_firestore.dart';

class HomeDataRepository {
  final _cloudFirestore = FirebaseFirestore.instance;

  getInitialData() async {
    final initialDataFromFirebase = await _cloudFirestore
        .collection('testingData')
        .orderBy('timestamp', descending: true)
        .limit(15)
        .get();
    return initialDataFromFirebase;
  }

  getMoreData({lastDocument}) async {
    final dataFromFirebase = await _cloudFirestore
        .collection('testingData')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(15)
        .get();
    print("Data from firebase: ${dataFromFirebase.docs.length}");
    return dataFromFirebase;
  }

  Future<void> addData({required String data}) async {
    await _cloudFirestore.collection('testingData').add({
      'data': data,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteData({required String documentId}) async {
    await _cloudFirestore.collection('testingData').doc(documentId).delete();
  }
}
