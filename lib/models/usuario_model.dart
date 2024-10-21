class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final String token;
  final String? profileImageUrl;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.token,
    this.profileImageUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['_id'] ?? '', 
      nome: json['nome'] ??
          'Nome não informado',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
      token: json['token'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'token': token,
      'profileImageUrl': profileImageUrl,
    };
  }
}
