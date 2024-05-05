class CompteBancaire {
  double solde;

  CompteBancaire({required this.solde});

  // Méthode pour désérialiser un JSON en objet CompteBancaire
  factory CompteBancaire.fromJson(Map<String, dynamic> json) {
    return CompteBancaire(
      solde: json['solde'] ?? 0.0,
    );
  }

  // Méthode pour sérialiser un objet CompteBancaire en JSON
  Map<String, dynamic> toJson() {
    return {
      'solde': solde,
    };
  }
}
