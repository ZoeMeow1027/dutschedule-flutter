class DUTAccount {
  final String sessionId;
  final String username;
  final String password;
  final bool rememberLogin;

  const DUTAccount({
    required this.username,
    required this.password,
    this.rememberLogin = false,
    this.sessionId = "",
  });

  DUTAccount.fromJson(Map<String, dynamic> json)
      : username = json['username'] ?? '',
        password = json['password'] ?? '',
        sessionId = json['sessionid'] ?? '',
        rememberLogin = json['remmeberlogin'] ?? false;

  Map<String, dynamic> toJson() => {
        'sessionid': sessionId,
        'username': username,
        'password': password,
        'rememberlogin': rememberLogin
      };
}
