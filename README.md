# 🛒 E-commerce Flutter App

Application e-commerce moderne développée avec Flutter, utilisant une architecture propre (Clean Architecture) et un déploiement Blue-Green sur Firebase Hosting.

## 🌐 Déploiement en Production

**🚀 URL Live** : [https://ecommerce-55dd8-4d606.web.app](https://ecommerce-55dd8-4d606.web.app)

### Stratégie Blue-Green Firebase
- **Canal Blue** : Environnement de staging (`ecommerce-55dd8-4d606--blue-xxx.web.app`)
- **Canal Green** : Environnement de pré-production (`ecommerce-55dd8-4d606--green-xxx.web.app`)
- **Production Live** : Promotion automatique après validation (`ecommerce-55dd8-4d606.web.app`)

## ✨ Fonctionnalités

- 🔐 **Authentification** : Email/mot de passe + Google Sign-In
- 📱 **Catalogue produits** : Navigation et recherche
- 🛒 **Panier d'achats** : Gestion complète
- 📊 **État global** : Riverpod pour la gestion d'état
- 🎨 **UI/UX moderne** : Material Design 3
- ⚡ **Performance** : Optimisé pour le web avec Firebase CDN
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
- **Flutter** 3.24.0+ (Web optimisé)
- **Firebase** (Hosting, Authentication)
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

# Configuration Firebase déjà prête dans firebase_options.dart

# Configurer Firebase CLI
firebase login
firebase use ecommerce-55dd8-4d606

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
# Pull Request → Canal Green automatique
git checkout -b feature/ma-feature
git push origin feature/ma-feature
# Créer PR → URL preview générée

# Develop → Canal Blue automatique  
git push origin develop
→ Déploie sur canal Blue pour staging

# Production → Déploiement live automatique
git push origin main
→ Build → Tests → Déploiement production
```

### Manuel (Scripts)
```bash
# Windows
.\scripts\deploy.ps1 [blue|green|promote|status|rollback]

# Exemples:
.\scripts\deploy.ps1 blue       # Canal Blue (staging)
.\scripts\deploy.ps1 green      # Canal Green (pre-prod)
.\scripts\deploy.ps1 promote    # Promotion vers production
```

### Workflow Blue-Green Firebase
1. **Développement** → Push develop → Canal Blue automatique
2. **Pre-prod** → PR → Canal Green automatique
3. **Tests** → Validation sur URLs des canaux
4. **Production** → Push main → Déploiement live
5. **Rollback** → Promotion canal précédent en 1-click

📖 **[Guide complet de déploiement](docs/DEPLOYMENT.md)**

## 🔧 Configuration

### Firebase Project
- **Project ID** : `ecommerce-55dd8-4d606`
- **Authentication** : Configuré pour Email/Password + Google
- **Hosting** : Channels Blue-Green configurés

### Secrets GitHub (pour CI/CD)
- `FIREBASE_SERVICE_ACCOUNT_ECOMMERCE_55DD8` : Clé de service Firebase

## 🏃‍♂️ Commandes Utiles

```bash
# Développement
flutter run -d chrome --hot-reload

# Build production
flutter build web --release --web-renderer canvaskit

# Déploiement Firebase
firebase hosting:channel:deploy blue    # Canal Blue
firebase hosting:channel:deploy green   # Canal Green
firebase deploy --only hosting          # Production directe

# Analyse et formatage
flutter analyze
dart format lib/ test/

# Nettoyage
flutter clean && flutter pub get
```

## 📱 Plateformes Supportées

- ✅ **Web** (Production sur Firebase Hosting)
- ✅ **Android** (Configuration Firebase prête)
- ✅ **iOS** (Configuration prête)  
- ✅ **Windows** (Développement)

## 🔒 Sécurité et Performance

- **Firebase Security Rules** : Authentification sécurisée
- **HTTPS par défaut** : Certificats automatiques
- **CDN global** : Performance optimisée mondialement
- **Channels isolés** : Environnements séparés pour tests
- **Firebase Analytics** : Monitoring intégré

## 📊 Monitoring

- **Firebase Console** : https://console.firebase.google.com/project/ecommerce-55dd8-4d606
- **Hosting Analytics** : Métriques de performance
- **GitHub Actions** : Logs de déploiement complets
- **Coverage Reports** : Codecov integration

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add: AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request → Canal preview automatique

## 📋 Roadmap

- [ ] 🛒 Système de commandes complet
- [ ] 💳 Intégration paiement (Stripe)
- [ ] 📧 Notifications email
- [ ] 🌍 Internationalisation (i18n)
- [ ] 📱 App mobile native
- [ ] 🔍 Recherche avancée avec filtres
- [ ] 📈 Firebase Analytics avancés

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙋‍♂️ Support

Pour toute question ou problème :
- 📧 Email : [votre-email]
- 💬 Issues GitHub
- 📖 Documentation : [docs/](docs/)
- 🔥 Firebase Console : https://console.firebase.google.com/project/ecommerce-55dd8-4d606

---

**Fait avec ❤️ et Flutter • Déployé sur Firebase Hosting**
