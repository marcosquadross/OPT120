class ActivityModel {
  int? id;
  String title;
  String description;
  DateTime date;

  ActivityModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  ActivityModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        description = map["description"],
        date = map["date"] != null
            ? DateTime.parse(map["date"])
            : DateTime
                .now(); // Usando coalescência nula para fornecer um valor padrão

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
    };
  }
}
