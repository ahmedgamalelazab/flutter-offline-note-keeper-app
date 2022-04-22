/**
 * @description : Note Model that the user will be dealing with 
 */

class Note {
  int? id;
  String? title;
  String? description;
  String? date;
  String? createdAt;
  String? updatedAt;
  String? backgroundColor;

  Note(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.backgroundColor,
      this.createdAt,
      this.updatedAt});

  Note.fromMap(Map<String, dynamic> noteMap) {
    id = noteMap['id'];
    title = noteMap['title'];
    description = noteMap['description'];
    date = noteMap['date'];
    createdAt = noteMap['createdAt'];
    updatedAt = noteMap['updatedAt'];
    backgroundColor = noteMap['backgroundColor'];
  }

  Map<String, dynamic> topMap() {
    return {
      "id": id ?? 0,
      "title": title ?? "undefined",
      "description": description ?? "undefined",
      "date": date ?? "undefined",
      "createdAt": createdAt ?? "undefined",
      "updatedAt": updatedAt ?? "undefined",
      "backgroundColor": backgroundColor ?? "undefined"
    };
  }
}
