class User {
  final String userName;
  final String phoneNumber;
  final List<String> qrCodes;
  final double totalPoint;
  final int totalCards;

  User(
      {this.userName,
      this.phoneNumber,
      this.qrCodes,
      this.totalPoint = 0.0,
      this.totalCards = 0});

  User.fromMap(Map<String, dynamic> map)
      : phoneNumber = map['phone'],
        userName = map['name'],
        qrCodes = new List<String>.from(
          map['qrCodes'],
        ),
        totalPoint = map['totalPoint'] != null
            ? double.parse(map['totalPoint'].toString())
            : 0.0,
        totalCards = map['totalCards'] != null ? map['totalCards'] : 0;
  // this is going to the tutorial, I was getting
  // this error. type 'List<dynamic>' is not a subtype of type 'List<String>'
}
