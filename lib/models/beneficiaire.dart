class Beneficiary {
  final String name;
  final String accountNumber;

  Beneficiary({required this.name, required this.accountNumber});

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      name: json['name'],
      accountNumber: json['accountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accountNumber': accountNumber,
    };
  }
}
