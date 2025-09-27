# Guide de Déploiement Blue-Green sur Vercel

## Vue d'ensemble

Le déploiement Blue-Green sur Vercel utilise les **Preview Deployments** (Blue) et **Production Deployments** (Green) pour permettre des déploiements sûrs avec possibilité de rollback instantané.

## Architecture Vercel

```
Production (Green) ←→ Custom Domain
Preview (Blue)     ←→ Generated Preview URLs
```

### Avantages Vercel
- **Preview URLs automatiques** : Chaque commit/PR génère une URL unique
- **Zero downtime** : Basculement instantané via DNS
- **Rollback en 1-click** : Via dashboard ou CLI
- **Edge Network** : Performance mondiale optimisée
- **Analytics intégrés** : Monitoring en temps réel

## Configuration Initiale

### 1. Prérequis

```bash
# Installer Node.js et npm
# https://nodejs.org

# Installer Vercel CLI
npm install -g vercel

# Installer Flutter
# https://flutter.dev

# Se connecter à Vercel
vercel login
```

### 2. Configuration du Projet Vercel

```bash
# Dans le répertoire du projet
vercel link

# Suivre les instructions :
# - Link to existing project? N
# - Project name: ecommerce-flutter
# - Directory: ./
```

### 3. Configuration GitHub Secrets

Dans **Settings > Secrets and variables > Actions** :

- `VERCEL_TOKEN` : Token d'API Vercel
- `VERCEL_ORG_ID` : ID de votre organisation
- `VERCEL_PROJECT_ID` : ID du projet

#### Génération des secrets :

```bash
# 1. Générer le token
vercel token

# 2. Récupérer les IDs
cat .vercel/project.json
# Copiez "orgId" et "projectId"
```

### 4. Configuration Automatique

Le fichier `vercel.json` est déjà configuré avec :
- Build command Flutter optimisé
- Rewrites pour SPA
- Headers de cache performants
- Variables d'environnement

## Utilisation

### Méthode 1 : GitHub Actions (Automatique)

#### Pull Request (Blue Environment)
```bash
git checkout -b feature/nouvelle-fonctionnalité
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin feature/nouvelle-fonctionnalité
# Créer la PR sur GitHub
```

**Résultat :**
- ✅ Tests automatiques
- 🚀 Déploiement Preview automatique
- 💬 Commentaire PR avec URL preview
- 🔵 Environment Blue actif

#### Push sur Main (Green Environment)
```bash
git checkout main
git merge feature/nouvelle-fonctionnalité
git push origin main
```

**Workflow automatique :**
1. 🧪 Tests et analyse
2. 🏗️ Build optimisé
3. 🚀 Déploiement Production
4. 🔍 Tests de fumée
5. ✅ Notification de succès

### Méthode 2 : Scripts Locaux

#### Windows (PowerShell)
```powershell
# Déployer en preview (Blue)
.\scripts\deploy.ps1 preview

# Déployer en production (Green)
.\scripts\deploy.ps1 production

# Voir le statut
.\scripts\deploy.ps1 status

# Rollback
.\scripts\deploy.ps1 rollback
```

### Méthode 3 : Vercel CLI Direct

```bash
# Construire l'app
flutter build web --release

# Déployer en preview
vercel deploy

# Déployer en production
vercel deploy --prod

# Lister les déploiements
vercel ls

# Rollback
vercel rollback [URL]
```

## Workflow Blue-Green Recommandé

### 1. Développement Local
```bash
# Tester localement
flutter run -d chrome

# Vérifier les tests
flutter test --coverage
flutter analyze
```

### 2. Preview Deployment (Blue)
```bash
# Créer une PR ou push sur develop
git push origin feature/ma-feature
```
→ **URL Preview générée automatiquement**

### 3. Tests et Validation
- Tester sur l'URL preview
- Valider les fonctionnalités
- Reviews de code via PR

### 4. Production Deployment (Green)
```bash
# Merger vers main
git checkout main
git merge feature/ma-feature
git push origin main
```
→ **Déploiement production automatique**

### 5. Monitoring Post-Déploiement
- Vérifier les métriques Vercel
- Monitorer les erreurs
- Valider les performances

## URLs et Environnements

### Structure des URLs
- **Production** : `https://votre-domain.vercel.app`
- **Preview** : `https://ecommerce-flutter-[hash]-[team].vercel.app`
- **Branch** : `https://ecommerce-flutter-git-[branch]-[team].vercel.app`

### Domaines Personnalisés
```bash
# Ajouter un domaine
vercel domains add votre-domain.com

# Configurer via dashboard Vercel
# Settings > Domains > Add Domain
```

## Tests Automatisés

### Tests de Fumée Intégrés
Les tests automatiques vérifient :
- ✅ Chargement Flutter complet
- ✅ Absence d'erreurs JavaScript
- ✅ Navigation fonctionnelle
- ✅ Performance acceptable

### Tests Locaux
```bash
# Tests Flutter
flutter test

# Tests E2E avec Playwright (optionnel)
npm install @playwright/test
npx playwright test
```

## Monitoring et Analytics

### Métriques Vercel
- **Real User Monitoring** : Performance réelle
- **Core Web Vitals** : Métriques de qualité
- **Function Logs** : Debugging
- **Bandwidth Usage** : Consommation

### Dashboard
- **Vercel Dashboard** : https://vercel.com/dashboard
- **Analytics** : Métriques détaillées
- **Deployments** : Historique complet

## Sécurité et Performance

### Optimisations Automatiques
- **Edge Caching** : CDN mondial
- **Image Optimization** : Compression automatique
- **Compression** : Gzip/Brotli
- **Tree Shaking** : Code mort éliminé

### Variables d'Environnement
```bash
# Via CLI
vercel env add FLUTTER_WEB

# Via Dashboard
# Settings > Environment Variables
```

### Sécurité
- **HTTPS par défaut** : Certificats automatiques
- **Headers de sécurité** : Configuration dans vercel.json
- **Preview Protection** : Accès contrôlé aux previews

## Rollback et Recovery

### Rollback Automatique
```bash
# Via CLI
vercel rollback https://deployment-url

# Via Dashboard
# Deployments > Previous deployment > Promote to Production
```

### Stratégies de Recovery
1. **Rollback immédiat** : < 30 secondes
2. **Hotfix deployment** : Correction rapide
3. **Feature flag** : Désactivation sélective

## Dépannage

### Problèmes Courants

#### 1. Build Failures
```bash
# Vérifier la configuration
cat vercel.json

# Tester le build localement
flutter build web --release

# Vérifier les logs
vercel logs
```

#### 2. Routing Issues
```bash
# Vérifier les rewrites dans vercel.json
# S'assurer que le SPA routing est configuré
```

#### 3. Performance Issues
```bash
# Analyser avec Vercel Analytics
# Optimiser les assets
flutter build web --web-renderer canvaskit
```

### Support
- **Vercel Docs** : https://vercel.com/docs
- **Community** : https://github.com/vercel/vercel/discussions
- **Status Page** : https://vercel-status.com

## Coûts et Limites

### Plan Gratuit (Hobby)
- **Deployments** : Illimités
- **Bandwidth** : 100GB/mois
- **Builds** : 6000 minutes/mois
- **Serverless Functions** : 12 par déploiement

### Optimisation des Coûts
- **Build Cache** : Réutilisation des builds
- **Asset Optimization** : Compression automatique
- **Edge Caching** : Réduction de la bande passante

## Métriques de Succès

- ⚡ **Temps de build** : < 3 minutes
- 🌍 **Time to First Byte** : < 200ms
- 🎯 **Uptime** : > 99.99%
- 🔄 **Temps de rollback** : < 30 secondes
- 📊 **Core Web Vitals** : Excellents scores
