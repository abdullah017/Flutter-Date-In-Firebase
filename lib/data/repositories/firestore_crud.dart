import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_in_firebase/data/models/task_model.dart';

class FireStoreCrud {
  FireStoreCrud();

  final _firestore = FirebaseFirestore.instance;

  Future<void> addTask({required TaskModel task}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.add(task.tojson());
  }

  Stream<List<TaskModel>> getTasks({required String mydate}) {
    return _firestore
        .collection('tasks')
        .where('date', isEqualTo: mydate)
        .snapshots(includeMetadataChanges: true)
        .map((snapshor) => snapshor.docs
            .map((doc) => TaskModel.fromjson(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateTask(
      {required String title,
      note,
      docid,
      date,
      starttime,
      endtime,
      required int reminder,
      colorindex}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.doc(docid).update({
      'title': title,
      'note': note,
      'date': date,
      'starttime': starttime,
      'endtime': endtime,
      'reminder': reminder,
      'colorindex': colorindex,
    });
  }

  Future<void> deleteTask({required String docid}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.doc(docid).delete();
  }
}
