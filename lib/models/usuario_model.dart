class Usuario {
  final String id;
  final String nome;
  final String email;
  final String token;
  final String? profileImageUrl;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.token,
    this.profileImageUrl,
  });
}
