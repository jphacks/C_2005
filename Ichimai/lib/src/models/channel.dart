class Channel {
  String name;
  DateTime startDate;
  final String token;

  Channel({this.name, this.startDate, this.token});

  Channel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        token = json['email'];
}
