class User {
  final String userName;
  final String phoneNumber;
  final List<String> qrCodes;

  User({this.userName, this.phoneNumber, this.qrCodes});

  User.fromMap(Map<String, dynamic> map)
      : phoneNumber = map['phone'],
        userName = map['name'],
        qrCodes = new List<String>.from(
            map['qrCodes']); // this is going to the tutorial, I was getting
  // this error. type 'List<dynamic>' is not a subtype of type 'List<String>'
}
