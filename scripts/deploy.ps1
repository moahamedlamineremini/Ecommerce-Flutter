# Script de déploiement Blue-Green pour Firebase Hosting (PowerShell)
# Usage: .\deploy.ps1 [blue|green|promote|status|rollback]

param(
    [Parameter(Position=0)]
    [ValidateSet("blue", "green", "promote", "status", "rollback", "help")]
    [string]$Action = "help"
)

$PROJECT_ID = "ecommerce-55dd8-4d606"

# Fonctions d'affichage
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Vérifier les prérequis
function Test-Prerequisites {
    Write-Status "Vérification des prérequis..."

    if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
        Write-Error-Custom "Flutter n'est pas installé ou pas dans le PATH"
        exit 1
    }

    if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
        Write-Error-Custom "Firebase CLI n'est pas installé. Installez avec: npm install -g firebase-tools"
        exit 1
    }

    # Vérifier l'authentification Firebase CLI
    $loginCheck = firebase projects:list 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Pas connecté à Firebase. Exécutez: firebase login"
        exit 1
    }

    Write-Success "Prérequis OK"
}

# Construire l'application
function Build-App {
    Write-Status "Construction de l'application Flutter..."

    flutter clean
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    flutter pub get
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    flutter analyze
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    flutter test
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    # Construction web avec option pour éviter les problèmes de liens symboliques
    flutter build web --release --no-tree-shake-icons
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Write-Success "Construction terminée"
}

# Déployer sur un canal spécifique
function Deploy-ToChannel {
    param([string]$Channel)

    Write-Status "Déploiement sur le canal Firebase '$Channel'..."

    firebase hosting:channel:deploy $Channel --project $PROJECT_ID --expires 30d
    if ($LASTEXITCODE -eq 0) {
        # Récupérer l'URL du canal
        $channelInfo = firebase hosting:channel:list --project $PROJECT_ID | Select-String $Channel
        if ($channelInfo) {
            Write-Success "Déployé avec succès sur le canal '$Channel'"
            Write-Host ""
            Write-Host "URL du canal: https://$PROJECT_ID--$Channel-randomid.web.app" -ForegroundColor Cyan
            Write-Host "Console Firebase: https://console.firebase.google.com/project/$PROJECT_ID/hosting" -ForegroundColor Yellow
        }
    }
}

# Promouvoir vers la production
function Invoke-PromoteToLive {
    Write-Status "Promotion d'un canal vers la production..."

    # Lister les canaux disponibles
    Write-Status "Canaux disponibles:"
    firebase hosting:channel:list --project $PROJECT_ID

    Write-Host ""
    $sourceChannel = Read-Host "Entrez le nom du canal à promouvoir (blue/green)"

    if ($sourceChannel -and ($sourceChannel -eq "blue" -or $sourceChannel -eq "green")) {
        $confirmation = Read-Host "Confirmer la promotion du canal '$sourceChannel' vers la production? (y/N)"
        if ($confirmation -match "^[Yy]$") {
            firebase hosting:clone "${PROJECT_ID}:${sourceChannel}" "${PROJECT_ID}:live" --project $PROJECT_ID
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Promotion vers la production réussie!"
                Write-Host ""
                Write-Host "URL de production: https://$PROJECT_ID.web.app" -ForegroundColor Green
                Write-Host "URL Firebase: https://$PROJECT_ID.firebaseapp.com" -ForegroundColor Green
            }
        }
    } else {
        Write-Warning "Canal invalide. Utilisez 'blue' ou 'green'."
    }
}

# Afficher le statut
function Show-Status {
    Write-Status "État des canaux Firebase Hosting:"
    firebase hosting:channel:list --project $PROJECT_ID

    Write-Host ""
    Write-Status "URLs importantes:"
    Write-Host "Production: https://$PROJECT_ID.web.app" -ForegroundColor Green
    Write-Host "Canal Blue: https://$PROJECT_ID--blue-xxx.web.app" -ForegroundColor Blue
    Write-Host "Canal Green: https://$PROJECT_ID--green-xxx.web.app" -ForegroundColor Green
    Write-Host "Console: https://console.firebase.google.com/project/$PROJECT_ID/hosting" -ForegroundColor Yellow
}

# Rollback
function Invoke-Rollback {
    Write-Status "Rollback des déploiements Firebase:"
    Write-Host ""

    # Lister les canaux disponibles
    Write-Status "Canaux disponibles pour rollback:"
    firebase hosting:channel:list --project $PROJECT_ID

    Write-Host ""
    Write-Status "Options de rollback:"
    Write-Host "1. Via Firebase Console (recommandé): https://console.firebase.google.com/project/$PROJECT_ID/hosting"
    Write-Host "2. Via CLI: Promouvoir un canal précédent"

    $choice = Read-Host "Voulez-vous promouvoir un canal existant vers la production? (y/N)"
    if ($choice -match "^[Yy]$") {
        Invoke-PromoteToLive
    }
}

# Afficher l'aide
function Show-Help {
    Write-Host "Usage: .\deploy.ps1 [blue|green|promote|status|rollback]"
    Write-Host ""
    Write-Host "Commandes:"
    Write-Host "  blue     - Déployer sur le canal blue (staging)"
    Write-Host "  green    - Déployer sur le canal green (pre-prod)"
    Write-Host "  promote  - Promouvoir un canal vers la production"
    Write-Host "  status   - Afficher l'état des canaux"
    Write-Host "  rollback - Effectuer un rollback"
    Write-Host ""
    Write-Host "Workflow Blue-Green Firebase:"
    Write-Host "1. Développez et testez localement"
    Write-Host "2. Déployez sur canal inactif (blue/green)"
    Write-Host "3. Testez sur l'URL du canal"
    Write-Host "4. Promouvez vers la production"
    Write-Host ""
    Write-Host "Configuration requise:"
    Write-Host "- Firebase CLI: npm install -g firebase-tools"
    Write-Host "- Authentification: firebase login"
    Write-Host "- Projet configuré: firebase use ecommerce-55dd8-4d606"
}

# Fonction principale
switch ($Action) {
    "blue" {
        Test-Prerequisites
        Build-App
        Deploy-ToChannel "blue"
    }
    "green" {
        Test-Prerequisites
        Build-App
        Deploy-ToChannel "green"
    }
    "promote" {
        Test-Prerequisites
        Invoke-PromoteToLive
    }
    "status" {
        Test-Prerequisites
        Show-Status
    }
    "rollback" {
        Test-Prerequisites
        Invoke-Rollback
    }
    default {
        Show-Help
    }
}
