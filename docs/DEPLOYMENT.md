# Guide de Déploiement Blue-Green sur Firebase Hosting

## Vue d'ensemble

Le déploiement Blue-Green permet de déployer en toute sécurité une nouvelle version de l'application en utilisant deux environnements distincts (Blue et Green). Cette stratégie minimise les temps d'arrêt et permet un rollback instantané.

## Architecture

```
Production (Live) ←→ Blue Channel
                 ←→ Green Channel
```

### Avantages
- **Zero downtime** : Passage instantané entre les versions
- **Rollback rapide** : Retour immédiat à la version précédente
- **Testing sécurisé** : Test complet avant mise en production
- **Isolation** : Séparation complète des environnements

## Configuration Initiale

### 1. Prérequis

```bash
# Installer Flutter (si pas déjà fait)
# Télécharger depuis https://flutter.dev

# Installer Firebase CLI
npm install -g firebase-tools

# Se connecter à Firebase
firebase login
```

### 2. Configuration GitHub Secrets

Dans votre repository GitHub, allez dans **Settings > Secrets and variables > Actions** et ajoutez :

- `FIREBASE_SERVICE_ACCOUNT_ECOMMERCE_55DD8` : Clé de service Firebase (JSON)

#### Génération de la clé de service :

1. Allez dans [Firebase Console](https://console.firebase.google.com/)
2. Sélectionnez votre projet `ecommerce-55dd8`
3. **Project Settings > Service Accounts**
4. **Generate new private key**
5. Encodez le JSON en base64 : `base64 -i firebase-key.json`
6. Copiez le résultat dans le secret GitHub

### 3. Initialisation Firebase Hosting

```bash
# Dans le répertoire du projet
firebase init hosting

# Suivre les instructions :
# - Sélectionner le projet ecommerce-55dd8
# - Public directory: build/web
# - Configure as SPA: Yes
# - Setup automatic builds: No
```

## Utilisation

### Méthode 1 : GitHub Actions (Automatique)

#### Push sur `main` (Production)
```bash
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin main
```

**Workflow automatique :**
1. 🧪 Tests et analyse
2. 🏗️ Build de l'application
3. 🚀 Déploiement sur canal `green`
4. 🔍 Tests de fumée automatiques
5. ✅ Promotion automatique vers production (si tests OK)

#### Push sur `develop` (Staging)
```bash
git push origin develop
```
- Déploie automatiquement sur le canal `blue`
- Idéal pour les tests de staging

### Méthode 2 : Scripts Locaux

#### Windows (PowerShell)
```powershell
# Déployer sur Blue
.\scripts\deploy.ps1 blue

# Déployer sur Green
.\scripts\deploy.ps1 green

# Voir le statut
.\scripts\deploy.ps1 status

# Promouvoir vers production
.\scripts\deploy.ps1 promote
```

#### Linux/Mac (Bash)
```bash
# Rendre le script exécutable
chmod +x scripts/deploy.sh

# Déployer sur Blue
./scripts/deploy.sh blue

# Déployer sur Green
./scripts/deploy.sh green

# Voir le statut
./scripts/deploy.sh status

# Promouvoir vers production
./scripts/deploy.sh promote
```

### Méthode 3 : Firebase CLI Direct

```bash
# Construire l'app
flutter build web --release

# Déployer sur un canal
firebase hosting:channel:deploy blue --expires 30d

# Lister les canaux
firebase hosting:channel:list

# Promouvoir vers production
firebase hosting:clone ecommerce-55dd8:blue ecommerce-55dd8:live
```

## Workflow Blue-Green Recommandé

### 1. Développement
```bash
# Branche develop pour les features
git checkout develop
git pull origin develop

# Développer la fonctionnalité
# ...

git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin develop
```
→ **Déploie automatiquement sur canal `blue`**

### 2. Staging et Tests
- L'application est déployée sur `https://ecommerce-55dd8--blue-xyz.web.app`
- Tests manuels et automatiques
- Validation des fonctionnalités

### 3. Production
```bash
# Merger vers main
git checkout main
git merge develop
git push origin main
```
→ **Déploie sur canal `green` puis promeut vers production**

### 4. Rollback (si nécessaire)
```bash
# Via GitHub Actions (manual workflow)
# Ou via script local
./scripts/deploy.sh promote
# Sélectionner le canal précédent
```

## Monitoring et URLs

### URLs d'Environnement
- **Production** : `https://ecommerce-55dd8.web.app`
- **Blue Channel** : `https://ecommerce-55dd8--blue-xyz.web.app`
- **Green Channel** : `https://ecommerce-55dd8--green-xyz.web.app`

### Monitoring
- **Firebase Console** : https://console.firebase.google.com/project/ecommerce-55dd8/hosting
- **GitHub Actions** : Onglet Actions du repository
- **Logs** : Firebase Console > Hosting > Usage

## Tests de Fumée

Les tests automatiques vérifient :
- ✅ Chargement de l'application
- ✅ Absence d'erreurs critiques
- ✅ Navigation de base
- ✅ Temps de réponse acceptable

## Sécurité

### Bonnes Pratiques
- Les canaux de prévisualisation expirent après 30 jours
- Authentification requise pour les actions de production
- Logs complets de tous les déploiements
- Rollback facile via Firebase Console

### Variables d'Environnement
- `FIREBASE_PROJECT_ID` : ID du projet Firebase
- `FLUTTER_VERSION` : Version Flutter utilisée
- Secrets GitHub pour l'authentification

## Dépannage

### Problèmes Courants

#### 1. Échec de Build
```bash
# Vérifier les dépendances
flutter pub get
flutter pub upgrade

# Nettoyer et reconstruire
flutter clean
flutter build web --release
```

#### 2. Échec de Déploiement
```bash
# Vérifier l'authentification
firebase login
firebase projects:list

# Vérifier la configuration
firebase use ecommerce-55dd8
```

#### 3. Tests de Fumée Échoués
- Vérifier l'URL de déploiement
- Valider les tests localement
- Consulter les logs GitHub Actions

### Support
- **Firebase Support** : https://firebase.google.com/support
- **Flutter Issues** : https://github.com/flutter/flutter/issues
- **GitHub Actions** : https://docs.github.com/actions

## Métriques de Succès

- ⚡ **Temps de déploiement** : < 5 minutes
- 🎯 **Disponibilité** : > 99.9%
- 🔄 **Temps de rollback** : < 30 secondes
- 🧪 **Couverture de tests** : > 80%
