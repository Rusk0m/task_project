import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_api/src/models/todo/todo.dart';
import 'package:todos_api/todos_api.dart';

class FirestoreStorageTodoApi extends TodosApi {
  final FirebaseFirestore _firestore;
  CollectionReference? _todosCollection;

  FirestoreStorageTodoApi(this._firestore) {
    _updateCollection();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _updateCollection();
    });
  }
  void _updateCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _firestore.clearPersistence(); // Очищаем кеш, если разлогинились
    }
    _todosCollection = user != null
        ? _firestore.collection('users').doc(user.uid).collection('tasks')
        : null;
  }

  @override
  Stream<List<Todo>> getTodos() {
    if (_todosCollection == null) {
      return Stream.value(
          [],); // Возвращаем пустой список, если пользователь не авторизован
    }
    return _todosCollection!.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Todo.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    if (_todosCollection == null) {
      throw Exception("Пользователь не авторизован");
    }
    await _todosCollection!.doc(todo.id).set(todo.toJson());
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (_todosCollection == null) {
      throw Exception("Пользователь не авторизован");
    }
    await _todosCollection!.doc(id).delete();
  }

  @override
  Future<int> clearCompleted() async {
    if (_todosCollection == null) {
      throw Exception("Пользователь не авторизован");
    }
    final querySnapshot =
        await _todosCollection!.where('isCompleted', isEqualTo: true).get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    return querySnapshot.docs.length;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    if (_todosCollection == null) {
      throw Exception("Пользователь не авторизован");
    }
    final querySnapshot = await _todosCollection!.get();
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
  Future<void> close() async {}
}
