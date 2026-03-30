class SignUpRequest {
  final String name;
  final String email;
  final String password;

  SignUpRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };
}

class SignInRequest {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class SignInResponse {
  final String accessToken;
  final String userId;

  SignInResponse({required this.accessToken, required this.userId});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      accessToken: json['access_token'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final int identificationCount;
  final String memberSince;

  UserProfile({
    required this.name,
    required this.email,
    required this.identificationCount,
    required this.memberSince,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      identificationCount: json['identification_count'] ?? 0,
      memberSince: json['member_since'] ?? 'Unknown',
    );
  }
}
