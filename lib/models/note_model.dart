class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map, String docId) {
    return NoteModel(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
