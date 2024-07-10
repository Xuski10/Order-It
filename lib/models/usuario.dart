class User {
  final String id;
  final String nombre;
  final String apellido_1;
  final String? apellido_2;
  final DateTime? fechaNacimiento;
  final String email;
  final String telefono;
  final int? rol;

  User({
    required this.id,
    required this.nombre,
    required this.apellido_1,
    this.apellido_2,
    this.fechaNacimiento,
    required this.email,
    required this.telefono,
    this.rol,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      apellido_1: json['apellido_1'],
      apellido_2: json['apellido_2'],
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
      email: json['email'],
      telefono: json['telefono'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido_1': apellido_1,
      'apellido_2': apellido_2,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'email': email,
      'telefono': telefono,// Asegúrate de mapear correctamente el campo aquí también
      'rol': rol,
    };
  }
}