class User {
  String userId;
  String userName;
  String password;
  String phoneNumber;
  String emailId;
  String userRole;
  bool inBatch;

  User({
    required this.userId,
    required this.userName,
    required this.password,
    required this.phoneNumber,
    required this.emailId,
    required this.userRole,
    required this.inBatch,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"] ?? "", // Provide default values
      userName: json["userName"] ?? "",
      password: json["password"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      emailId: json["emailId"] ?? "",
      userRole: json["userRole"] ?? "",
      inBatch: json["inBatch"] ?? false,
    );
  }
}