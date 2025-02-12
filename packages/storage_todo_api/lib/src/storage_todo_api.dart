import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_api/src/models/todo/todo.dart';
import 'package:todos_api/todos_api.dart';

class FirestoreStorageTodoApi extends TodosApi {
  final FirebaseFirestore _firestore;
  final CollectionReference _todosCollection;

  FirestoreStorageTodoApi({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _todosCollection = (firestore ?? FirebaseFirestore.instance).collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('tasks');


  @override
  Stream<List<Todo>> getTodos() {
    return _todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    await _todosCollection.doc(todo.id).set(todo.toJson());
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _todosCollection.doc(id).delete();
  }

  @override
  Future<int> clearCompleted() async {
    final querySnapshot = await _todosCollection.where('isCompleted', isEqualTo: true).get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    return querySnapshot.docs.length;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final querySnapshot = await _todosCollection.get();
    int updatedCount = 0;
    for (final doc in querySnapshot.docs) {
      final todo = Todo.fromJson(doc.data() as Map<String, dynamic>);
      if (todo.isCompleted != isCompleted) {
        await doc.reference.update({'isCompleted': isCompleted});
        updatedCount++;
      }
    }
    return updatedCount;
  }

  @override
  Future<void> close() async {
  }
}