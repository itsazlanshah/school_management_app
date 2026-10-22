class Student {
  const Student({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.phone,
    required this.department,
    required this.address,
  });

  final String id;
  final String name;
  final String fatherName;
  final String cnic;
  final String phone;
  final String department;
  final String address;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String,
      cnic: json['cnic'] as String,
      phone: json['phone'] as String,
      department: json['department'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fatherName': fatherName,
      'cnic': cnic,
      'phone': phone,
      'department': department,
      'address': address,
    };
  }
}
