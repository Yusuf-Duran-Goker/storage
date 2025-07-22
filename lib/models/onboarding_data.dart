class OnboardingData {
  final String uid;
  final String gender;
  final int age;
  final List<String> interests;

  OnboardingData({
    required this.uid,
    required this.gender,
    required this.age,
    required this.interests,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'gender': gender,
    'age': age,
    'interests': interests,
  };

  factory OnboardingData.fromJson(Map<String, dynamic> json) => OnboardingData(
    uid: json['uid'] as String,
    gender: json['gender'] as String,
    age: json['age'] as int,
    interests: List<String>.from(json['interests'] as List<dynamic>),
  );
}
