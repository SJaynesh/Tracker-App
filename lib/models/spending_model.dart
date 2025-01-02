class SpendingModel {
  int id;
  String desc;
  num amount;
  String mode;
  String date;
  String time;
  int categoryId;

  SpendingModel({
    required this.id,
    required this.desc,
    required this.amount,
    required this.mode,
    required this.date,
    required this.time,
    required this.categoryId,
  });

  factory SpendingModel.fromMap({required Map<String, dynamic> data}) {
    return SpendingModel(
      id: data['spending_id'],
      desc: data['spending_desc'],
      amount: data['spending_amount'],
      mode: data['spending_mode'],
      date: data['spending_date'],
      time: data['spending_time'],
      categoryId: data['spending_category_id'],
    );
  }
}
