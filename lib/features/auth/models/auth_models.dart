class UserDto {
  final int id;
  final String email;
  final String nombre;
  final int rolId;
  final String rolNombre;

  UserDto({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rolId,
    required this.rolNombre,
  });

  factory UserDto.fromJson(Map<String, dynamic> j) => UserDto(
        id: (j['id'] ?? 0) as int,
        email: (j['email'] ?? '') as String,
        nombre: (j['nombre'] ?? '') as String,
        rolId: (j['rolId'] ?? j['role']?['id'] ?? 0) as int,
        rolNombre: (j['rolNombre'] ?? j['role']?['nombre'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nombre': nombre,
        'rolId': rolId,
        'rolNombre': rolNombre,
      };
}

class AuthResponse {
  final UserDto user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> j) => AuthResponse(
        user: UserDto.fromJson(j['user'] as Map<String, dynamic>),
        token: (j['token'] ?? '') as String,
      );
}
