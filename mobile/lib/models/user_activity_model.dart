class UserActivityModel {
  int userId;
  int activityId;
  DateTime deliveryDate;
  double score;

  UserActivityModel({
    required this.userId,
    required this.activityId,
    required this.deliveryDate,
    required this.score,
  });

  UserActivityModel.fromMap(Map<String, dynamic> map)
      : userId = map["user_id"],
        activityId = map["activity_id"],
        deliveryDate = map["delivery_date"] != null
            ? DateTime.parse(map["delivery_date"])
            : DateTime.now(),
        score = map["score"];

  Map<String, dynamic> toMap() {
    return {
      "user_id": userId,
      "activity_id": activityId,
      "delivery_date": deliveryDate,
      "score": score,
    };
  }
}
