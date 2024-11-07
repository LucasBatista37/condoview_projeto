class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final String? profileImageUrl;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.profileImageUrl,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    print('Log: Mapeando dados do usuário no fromJson: $json'); // Log para verificar os dados recebidos
    return Usuario(
      id: json['_id'] ?? '',
      nome: json['nome'] ?? 'Nome não informado',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'profileImageUrl': profileImageUrl,
    };
  }
}
