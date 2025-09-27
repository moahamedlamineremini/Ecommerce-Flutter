@echo off
setlocal enabledelayedexpansion

REM Script Windows pour les tests de montée en charge
REM Usage: run-load-tests.bat [test-type]

echo.
echo ==========================================
echo 🚀 TESTS DE MONTEE EN CHARGE - E-COMMERCE
echo ==========================================

REM Configuration des URLs
set PRODUCTION_URL=https://ecommerce-55dd8-4d606.web.app
set BLUE_URL=https://ecommerce-55dd8-4d606--blue-kwsqcu8f.web.app
set GREEN_URL=https://ecommerce-55dd8-4d606--green-flohskqk.web.app

REM Vérifier qu'Artillery est installé
echo.
echo 🔍 Vérification d'Artillery...
artillery --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Artillery n'est pas installé ou pas trouvé dans le PATH
    echo.
    echo 💡 Solutions possibles:
    echo    1. Installer Artillery: npm install -g artillery
    echo    2. Vérifier que Node.js est installé: node --version
    echo    3. Redémarrer le terminal après installation
    echo.
    echo 🔧 Installation automatique d'Artillery...
    npm install -g artillery
    if %errorlevel% neq 0 (
        echo ❌ Échec de l'installation d'Artillery
        echo 💡 Installez manuellement: npm install -g artillery
        pause
        exit /b 1
    )
    echo ✅ Artillery installé avec succès
) else (
    for /f "tokens=*" %%i in ('artillery --version 2^>nul') do set ARTILLERY_VERSION=%%i
    echo ✅ Artillery version: !ARTILLERY_VERSION!
)

REM Créer le dossier de rapports
if not exist "reports" (
    mkdir reports
    echo 📁 Dossier reports créé
)

REM Fonction pour afficher l'aide
if "%1"=="" goto :help
if "%1"=="help" goto :help

REM Menu principal
if "%1"=="smoke" (
    echo.
    echo 🔥 Test de fumée - Vérification rapide
    echo ⏱️ Durée: ~1 minute
    echo 👥 Charge: 2 utilisateurs/seconde
    echo 🎯 Cible: %PRODUCTION_URL%
    echo.
    echo ⏳ Démarrage du test...
    artillery run smoke-test.yml --output reports/smoke-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%.json
    if %errorlevel% equ 0 (
        echo.
        echo ✅ Test de fumée terminé avec succès !
    ) else (
        echo.
        echo ❌ Le test a échoué - Vérifiez le fichier smoke-test.yml
    )
    goto :end
)

if "%1"=="load" (
    echo.
    echo ⚡ Test de charge normale
    echo ⏱️ Durée: ~7 minutes
    echo 👥 Charge: jusqu'à 20 utilisateurs/seconde
    echo.
    echo ⏳ Démarrage du test...
    artillery run load-test.yml --output reports/load-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%.json
    if %errorlevel% equ 0 (
        echo.
        echo ✅ Test de charge terminé avec succès !
    ) else (
        echo.
        echo ❌ Le test a échoué
    )
    goto :end
)

if "%1"=="stress" (
    echo.
    echo 💪 Test de stress - ATTENTION: Test intensif !
    echo ⏱️ Durée: ~12 minutes
    echo 👥 Charge: jusqu'à 100 utilisateurs/seconde
    echo.
    set /p confirm="Confirmer le test de stress? (O/N): "
    if /i "!confirm!"=="O" (
        echo ⏳ Démarrage du test de stress...
        artillery run stress-test.yml --output reports/stress-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%.json
    ) else (
        echo Test de stress annulé
    )
    goto :end
)

if "%1"=="production" (
    echo.
    echo 🚀 Test spécifique - Environnement Production
    echo 🎯 URL: %PRODUCTION_URL%
    artillery run production-test.yml --output reports/production-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%.json
    goto :end
)

if "%1"=="blue" (
    echo.
    echo 🔵 Test spécifique - Canal Blue
    echo 🎯 URL: %BLUE_URL%
    artillery run blue-test.yml --output reports/blue-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%.json
    goto :end
)

if "%1"=="green" (
    echo.
    echo 🟢 Test spécifique - Canal Green
    echo 🎯 URL: %GREEN_URL%
    artillery run green-test.yml --output reports/green-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%.json
    goto :end
)

if "%1"=="all" (
    echo.
    echo 🎯 Test complet des 3 environnements
    echo ⚠️ Durée totale: ~15 minutes
    echo.
    set /p confirm="Lancer tous les tests? (O/N): "
    if /i "!confirm!"=="O" (
        echo.
        echo 🚀 1/3 - Test Production
        artillery run production-test.yml --output reports/production-complete-%date:~-4,4%%date:~-10,2%%date:~-7,2%.json

        echo.
        echo 🔵 2/3 - Test Canal Blue
        artillery run blue-test.yml --output reports/blue-complete-%date:~-4,4%%date:~-10,2%%date:~-7,2%.json

        echo.
        echo 🟢 3/3 - Test Canal Green
        artillery run green-test.yml --output reports/green-complete-%date:~-4,4%%date:~-10,2%%date:~-7,2%.json

        echo.
        echo 🎉 TOUS LES TESTS TERMINÉS !
    ) else (
        echo Tests annulés
    )
    goto :end
)

:help
echo.
echo 📖 Usage: run-load-tests.bat [option]
echo.
echo Options disponibles:
echo   smoke      - Test de fumée rapide (1 min)
echo   load       - Test de charge normale (7 min)
echo   stress     - Test de stress intensif (12 min)
echo   production - Test de l'environnement de production
echo   blue       - Test du canal Blue (develop)
echo   green      - Test du canal Green (PR)
echo   all        - Test complet des 3 environnements (15 min)
echo   help       - Afficher cette aide
echo.
echo 🎯 Exemples:
echo   run-load-tests.bat smoke
echo   run-load-tests.bat all
echo.
echo 🔗 URLs testées:
echo   Production: %PRODUCTION_URL%
echo   Blue:       %BLUE_URL%
echo   Green:      %GREEN_URL%
echo.

:end
echo.
echo 📊 Rapports sauvegardés dans le dossier 'reports\'
echo 💡 Conseil: Analysez les temps de réponse et taux d'erreur
pause
