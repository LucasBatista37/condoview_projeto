class Condominium {
  final String name;
  final String address;
  final String cnpj;

  Condominium({
    required this.name,
    required this.address,
    required this.cnpj,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'cnpj': cnpj,
    };
  }
}
