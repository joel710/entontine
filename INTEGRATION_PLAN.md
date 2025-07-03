# Plan d'intégration Supabase & Paygate Mobile pour eTontine

## 1. Supabase – Backend général

### a. Authentification
- Utiliser Supabase Auth pour gérer l'inscription, la connexion, la réinitialisation de mot de passe.
- Stocker les tokens JWT côté client pour sécuriser les requêtes.

### b. Base de données (PostgreSQL)
- Créer les tables principales :
  - `users` (infos utilisateur, profil)
  - `tontines` (nom, montant, fréquence, seuil, créateur, etc.)
  - `memberships` (liens user-tontine, statut, rôle)
  - `transactions` (dépôts, retraits, transferts, statut, date, montant, user_id, tontine_id)
  - `notifications` (user_id, message, type, date, lu/non lu)
- Utiliser les policies RLS (Row Level Security) pour sécuriser l'accès aux données.

### c. API Supabase
- Utiliser le client Supabase Flutter pour toutes les opérations CRUD.
- Utiliser les fonctions serverless (Edge Functions) pour la logique métier complexe (ex : calcul des parts, notifications automatiques).

### d. Stockage
- Utiliser Supabase Storage pour stocker les avatars ou documents éventuels.

---

## 2. Paygate Mobile – Transactions financières

### a. Création d'un compte marchand Paygate
- Obtenir les identifiants API (clé publique/privée, merchant ID, etc.)

### b. Intégration Flutter
- Créer un service Dart pour appeler l'API Paygate (dépôt, retrait, vérification de statut).
- Sécuriser les appels (signature, HTTPS).
- Gérer les callbacks/notifications de paiement (webhook côté Supabase ou polling côté app).

### c. Scénarios d'utilisation
- **Dépôt** : L'utilisateur saisit le montant, choisit le moyen de paiement (Moov, Orange, etc.), l'app appelle Paygate, puis enregistre la transaction dans Supabase.
- **Retrait** : L'utilisateur demande un retrait, l'app appelle Paygate, puis met à jour le statut dans Supabase.
- **Historique** : Les transactions sont synchronisées entre Paygate et Supabase.

---

## 3. Sécurité & Bonnes pratiques

- Toujours vérifier les statuts de paiement côté serveur (Supabase Function) avant de créditer/débiter un compte.
- Ne jamais stocker les clés secrètes dans l'app Flutter : utiliser les Edge Functions pour les opérations sensibles.
- Utiliser HTTPS partout.

---

## 4. Étapes d'intégration technique

### a. Supabase
1. Créer un projet Supabase et configurer les tables.
2. Générer les policies RLS.
3. Installer le package `supabase_flutter` dans ton projet.
4. Configurer l'authentification et la gestion de session.
5. Remplacer les appels API actuels par des appels Supabase (CRUD).

### b. Paygate
1. Créer un compte marchand Paygate.
2. Lire la documentation API Paygate Mobile.
3. Créer un service Dart pour les appels API (dépôt, retrait, statut).
4. Intégrer les appels dans les écrans concernés (dépôt, retrait).
5. Gérer les retours et statuts de paiement.

### c. Edge Functions (optionnel mais recommandé)
1. Créer des fonctions serverless sur Supabase pour :
   - Vérifier les paiements Paygate
   - Gérer les webhooks Paygate
   - Automatiser les notifications

---

## 5. Exemple de structure de code

```dart
// Authentification Supabase
final supabase = Supabase.instance.client;
await supabase.auth.signInWithPassword(email: ..., password: ...);

// CRUD Tontine
await supabase.from('tontines').insert({...});
final tontines = await supabase.from('tontines').select().eq('user_id', userId);

// Paiement Paygate (pseudo-code)
final response = await http.post(
  Uri.parse('https://api.paygate.com/payment'),
  headers: {...},
  body: {...},
);
// Vérifier le statut, puis enregistrer dans Supabase
```

---

## 6. Ressources

- [Supabase Flutter Docs](https://supabase.com/docs/guides/with-flutter)
- [Paygate Mobile API Docs](https://paygate.tg/api-docs)
- [Exemple d'intégration Flutter + Supabase](https://github.com/supabase/supabase-flutter) 