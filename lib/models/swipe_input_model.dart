class SwipeInputModel {
  SwipeInputModel({required this.receiverId, required this.senderId, required this.site});
  String receiverId;
  String senderId;
  String site;
  Map<String, dynamic> toMap() {
    Map<String, dynamic> swipeInputParameter = {
     'receiver_id': receiverId,
      'context': site,
      'sender_id': senderId,
    };
    return swipeInputParameter;
  }
}