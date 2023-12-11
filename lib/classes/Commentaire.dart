class Comment {
  final String userId;
  final String text;
  final double? rating;
  final DateTime timestamp;
  Comment({required this.userId, required this.text, required this.rating,required this.timestamp});

  factory Comment.fromMap(Map<String, dynamic> map) {
    //convertir  map en une instance de la classe Comment
    return Comment(
      userId: map['userId'],
      text: map['text'],
      rating: map['rating'],
      timestamp: map['timestamp'].toDate(),
    );
  }

}