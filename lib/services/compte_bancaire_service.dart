import '../models/compte_bancaire.dart';

class CompteBancaireService {
  CompteBancaire _compteBancaire = CompteBancaire(solde: 5000.0);

  Future<CompteBancaire> obtenirCompteBancaire() async {
    return _compteBancaire;
  }

  Future<void> deposerArgent({required double montant}) async {
    _compteBancaire.solde += montant;
  }

  Future<void> retirerArgent({required double montant}) async {
    if (_compteBancaire.solde >= montant) {
      _compteBancaire.solde -= montant;
    } else {
      throw Exception('Solde insuffisant');
    }
  }
}
