# 🚀 GUIDE DES TESTS DE MONTÉE EN CHARGE

## 📋 Ce qui a été créé pour toi :

### 1. **Structure des tests**
```
load-tests/
├── package.json              # Configuration npm
├── smoke-test.yml            # Test de fumée (vérification rapide)
├── load-test.yml             # Test de charge normale
├── stress-test.yml           # Test de stress (limites)
├── production-test.yml       # Test spécifique Production
├── blue-test.yml            # Test spécifique Canal Blue
├── green-test.yml           # Test spécifique Canal Green
├── run-load-tests.sh        # Script automatique (Linux/Mac)
├── run-load-tests.bat       # Script automatique (Windows)
└── reports/                 # Dossier des rapports (créé auto)
```

## 🎯 **Tes 3 environnements de test :**

1. **🚀 Production** : https://ecommerce-55dd8-4d606.web.app
2. **🔵 Canal Blue** : https://ecommerce-55dd8-4d606--blue-kwsqcu8f.web.app
3. **🟢 Canal Green** : https://ecommerce-55dd8-4d606--green-flohskqk.web.app

## 🛠️ **Installation et utilisation :**

### Étape 1: Installation d'Artillery
```bash
# Installer Artillery globalement
npm install -g artillery

# Vérifier l'installation  
artillery --version
```

### Étape 2: Aller dans le dossier de tests
```bash
cd "C:\Users\remin\Documents\flutter\Nouveau dossier\Ecommerce-Flutter\load-tests"
```

### Étape 3: Lancer les tests (Windows)
```cmd
# Test rapide des 3 environnements
run-load-tests.bat smoke

# Test de charge normale
run-load-tests.bat load

# Test de stress (intense) 
run-load-tests.bat stress

# Test d'un environnement spécifique
run-load-tests.bat production
run-load-tests.bat blue
run-load-tests.bat green

# Test complet de tous les environnements
run-load-tests.bat all
```

## 📊 **Types de tests expliqués :**

### 🔥 **Smoke Test** (Test de fumée)
- **Durée** : 1 minute
- **Charge** : 2 utilisateurs/seconde
- **But** : Vérifier que les 3 sites répondent correctement
- **Parfait pour** : Validation rapide après déploiement

### ⚡ **Load Test** (Test de charge)
- **Durée** : 7 minutes total
- **Charge** : Montée de 5 → 20 → 5 utilisateurs/seconde
- **But** : Simuler l'usage normal attendu
- **Parfait pour** : Valider les performances en usage réel

### 💪 **Stress Test** (Test de stress)
- **Durée** : 12 minutes total
- **Charge** : Montée agressive jusqu'à 100 utilisateurs/seconde
- **But** : Trouver les limites et points de rupture
- **Parfait pour** : Savoir combien d'utilisateurs ton site peut supporter

## 📈 **Métriques à surveiller :**

### ✅ **Bonnes performances :**
- **Temps de réponse** : < 2 secondes
- **Taux de succès** : > 95%
- **Débit** : Stable même sous charge

### ⚠️ **Performances moyennes :**
- **Temps de réponse** : 2-5 secondes
- **Taux de succès** : 90-95%
- **Débit** : Légère baisse sous charge

### ❌ **Performances problématiques :**
- **Temps de réponse** : > 5 secondes
- **Taux de succès** : < 90%
- **Erreurs** : Timeouts, erreurs 5xx

## 🎯 **Plan de test recommandé :**

### 1. **Validation initiale**
```bash
run-load-tests.bat smoke
```
→ Vérifier que tout fonctionne

### 2. **Test de performance**  
```bash
run-load-tests.bat load
```
→ Valider les performances normales

### 3. **Test de résistance**
```bash
run-load-tests.bat stress  
```
→ Trouver les limites

### 4. **Comparaison des environnements**
```bash
run-load-tests.bat all
```
→ Comparer Blue vs Green vs Production

## 📊 **Analyse des résultats :**

Les rapports sont sauvegardés dans `reports/` avec :
- **Statistiques détaillées** de chaque test
- **Temps de réponse** min/max/moyen
- **Taux de succès/erreur**
- **Graphiques** de performance dans le temps

## 💡 **Conseils pratiques :**

1. **Commence petit** : Smoke test → Load test → Stress test
2. **Compare les environnements** : Blue vs Green vs Production
3. **Teste régulièrement** : Après chaque déploiement
4. **Surveille Firebase** : Quotas et limites dans la console
5. **Documente les résultats** : Pour suivre l'évolution des performances
