class LoginResponse {
  final String loggedId;
  final String loggedRole;
  final String loggedUserName;
  // final List<String> batchIdList;

  LoginResponse({
    required this.loggedId,
    required this.loggedRole,
    required this.loggedUserName,
    // required this.batchIdList,
  });
// todo i have to change my backend to return user object when user sign in and this format will change it is not correct
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponse(
      loggedId: data['loggedId'],
      loggedRole: data['loggedRole'],
      loggedUserName: data['loggedUserName'],
      // batchIdList: data['batchesIdList']
    );
  }
}
