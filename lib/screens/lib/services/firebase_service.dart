import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import '../models/transaction_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- NOTES CRUD OPERATIONS ---

  // Get Notes Stream
  Stream<List<NoteModel>> getNotes() {
    return _db
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add Note
  Future<void> addNote(NoteModel note) async {
    await _db.collection('notes').add(note.toMap());
  }

  // Update Note
  Future<void> updateNote(NoteModel note) async {
    await _db.collection('notes').doc(note.id).update(note.toMap());
  }

  // Delete Note
  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }

  // --- TRANSACTIONS / SAVINGS CRUD OPERATIONS ---

  // Get Transactions Stream
  Stream<List<TransactionModel>> getTransactions() {
    return _db
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add Transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  // Delete Transaction
  Future<void> deleteTransaction(String id) async {
    await _db.collection('transactions').doc(id).delete();
  }
}
