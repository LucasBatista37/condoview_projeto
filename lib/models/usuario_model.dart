class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final String? profileImageUrl;
  final String? telefone; 
  final String? apartamento; 

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.profileImageUrl,
    this.telefone, 
    this.apartamento, 
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    print('Log: Mapeando dados do usuário no fromJson: $json');
    return Usuario(
      id: json['_id'] ?? '',
      nome: json['nome'] ?? 'Nome não informado',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
      profileImageUrl: json['profileImage'],
      telefone: json['telefone'],
      apartamento: json['apartamento'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'profileImageUrl': profileImageUrl,
      'telefone': telefone,
      'apartamento': apartamento, 
    };
  }
}
