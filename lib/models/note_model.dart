class NoteModel{

   String? noteText;
   String? noteDate;
   String? userId;
   String? noteId;

  NoteModel.fromJson(Map<String, dynamic> json)
  {
    noteText = json['text'];
    noteDate = json['placeDateTime'];
    userId = json['userId'];
    noteId = json['id'];
  }

}