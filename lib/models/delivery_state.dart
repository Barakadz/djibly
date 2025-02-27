class DeliveryState {
  String state;
  String date;

  DeliveryState({ this.state, this.date});

  factory DeliveryState.fromJson(Map<String, dynamic> json) {
    return DeliveryState(
        state: json['state'],
        date: json['created_at']);
  }
}