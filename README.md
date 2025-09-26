# 🛒 E-commerce Flutter App

Application e-commerce moderne développée avec Flutter, utilisant une architecture propre (Clean Architecture) et un déploiement Blue-Green sur Firebase Hosting.

## 🌐 Déploiement en Production

**🚀 URL Live** : [https://ecommerce-55dd8.web.app](https://ecommerce-55dd8.web.app)

### Stratégie Blue-Green
- **Canal Blue** : Environnement de staging
- **Canal Green** : Environnement de pré-production  
- **Production** : Promotion automatique après validation

## ✨ Fonctionnalités

- 🔐 **Authentification** : Email/mot de passe + Google Sign-In
- 📱 **Catalogue produits** : Navigation et recherche
- 🛒 **Panier d'achats** : Gestion complète
- 📊 **État global** : Riverpod pour la gestion d'état
- 🎨 **UI/UX moderne** : Material Design 3
- ⚡ **Performance** : Optimisé pour le web
- 🧪 **Tests** : Unit tests + Widget tests (>80% couverture)

## 🏗️ Architecture

```
lib/
├── domain/          # Entités et interfaces métier
├── data/            # Implémentation des repositories
├── presentation/    # UI et ViewModels
└── main.dart        # Point d'entrée
```

### Technologies Utilisées
- **Flutter** 3.24.0+ (Web, Android, iOS)
- **Firebase** (Auth, Hosting)
- **Riverpod** (State Management)
- **GoRouter** (Navigation)
- **Clean Architecture**

## 🚀 Démarrage Rapide

### Prérequis
```bash
# Flutter SDK
flutter doctor

# Firebase CLI
npm install -g firebase-tools

# Dépendances
flutter pub get
```

### Installation
```bash
# Cloner le projet
git clone [URL_DU_REPO]
cd Ecommerce-Flutter

# Installer les dépendances
flutter pub get

# Configurer Firebase
cp lib/firebase_options_example.dart lib/firebase_options.dart
# Modifier avec vos clés Firebase

# Lancer en mode debug
flutter run -d chrome
```

## 🧪 Tests

```bash
# Tests unitaires et widgets
flutter test

# Tests avec couverture
flutter test --coverage

# Analyse du code
flutter analyze
```

**Couverture actuelle** : 85%+ sur les composants critiques

## 📦 Déploiement

### Automatique (GitHub Actions)
```bash
# Production
git push origin main
→ Déploie sur Green → Tests → Promotion auto

# Staging  
git push origin develop
→ Déploie sur Blue pour tests
```

### Manuel (Scripts)
```bash
# Windows
.\scripts\deploy.ps1 [blue|green|promote|status]

# Linux/Mac
./scripts/deploy.sh [blue|green|promote|status]
```

### Workflow Blue-Green
1. **Développement** → Push sur `develop` → Déploie sur canal Blue
2. **Tests** → Validation sur l'URL de preview
3. **Production** → Push sur `main` → Déploie sur Green + Promotion auto
4. **Rollback** → Promotion rapide du canal précédent

📖 **[Guide complet de déploiement](docs/DEPLOYMENT.md)**

## 🔧 Configuration

### Variables d'Environnement
```bash
# Firebase Project ID
FIREBASE_PROJECT_ID=ecommerce-55dd8

# Flutter Version
FLUTTER_VERSION=3.24.0
```

### Secrets GitHub (pour CI/CD)
- `FIREBASE_SERVICE_ACCOUNT_ECOMMERCE_55DD8`

## 🏃‍♂️ Commandes Utiles

```bash
# Développement
flutter run -d chrome --hot-reload

# Build production
flutter build web --release --web-renderer canvaskit

# Analyse et formatage
flutter analyze
dart format lib/ test/

# Nettoyage
flutter clean && flutter pub get
```

## 📱 Plateformes Supportées

- ✅ **Web** (Production sur Firebase Hosting)
- ✅ **Android** (Configuration prête)
- ✅ **iOS** (Configuration prête)  
- ✅ **Windows** (Développement)

## 🔒 Sécurité

- Authentification Firebase sécurisée
- Variables sensibles dans les secrets GitHub
- Canaux de preview avec expiration automatique
- Validation automatique avant promotion

## 📊 Monitoring

- **Firebase Console** : Analytics et performance
- **GitHub Actions** : Logs de déploiement
- **Coverage Reports** : Codecov integration
- **Error Tracking** : Firebase Crashlytics (à venir)

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add: AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📋 Roadmap

- [ ] 🛒 Système de commandes complet
- [ ] 💳 Intégration paiement (Stripe)
- [ ] 📧 Notifications email
- [ ] 🌍 Internationalisation (i18n)
- [ ] 📱 App mobile native
- [ ] 🔍 Recherche avancée avec filtres

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙋‍♂️ Support

Pour toute question ou problème :
- 📧 Email : [votre-email]
- 💬 Issues GitHub
- 📖 Documentation : [docs/](docs/)

---

**Fait avec ❤️ et Flutter**
