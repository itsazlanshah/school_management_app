class Teacher {
  const Teacher({
    required this.id,
    required this.name,
    required this.cnic,
    required this.department,
    required this.address,
  });

  final String id;
  final String name;
  final String cnic;
  final String department;
  final String address;

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      name: json['name'] as String,
      cnic: json['cnic'] as String,
      department: json['department'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cnic': cnic,
      'department': department,
      'address': address,
    };
  }
}
