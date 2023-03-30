class NotifyFeed {
  NotifyFeed({
    required this.type,
    required this.username,
    required this.userId,
    required this.userProfileImg,
    required this.postId,
    required this.postImg,
    required this.timestamp,
    required this.read,
    required this.followId,
    required this.commentId,
  });

  late final String type;
  late final String username;
  late final String userId;
  late final String userProfileImg;
  late final String postId;
  late final String postImg;
  late final DateTime timestamp;
  late final String read;
  late final String followId;
  late final String commentId;

  NotifyFeed.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    username = json['username'].toString();
    userId = json['userId'].toString();
    userProfileImg = json['userProfileImg'].toString();
    postId = json['postId'].toString();
    postImg = json['postImg'].toString();
    timestamp = json['timestamp'].toDate();
    read = json['read'].toString();
    followId = json['followId'].toString();
    commentId = json['commentId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['username'] = username;
    data['userId'] = userId;
    data['userProfileImg'] = userProfileImg;
    data['postId'] = postId;
    data['postImg'] = postImg;
    data['timestamp'] = timestamp;
    data['read'] = read;
    data['followId'] = followId;
    data['commentId'] = commentId;

    return data;
  }
}

enum Type { like, comment, follow }
