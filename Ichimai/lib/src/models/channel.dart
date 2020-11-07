class Channel {
  String name;
  DateTime startDate;
  final double latitude;
  final double longitude;
  final String token;

  Channel(
      {this.latitude, this.longitude, this.name, this.startDate, this.token});
}
