# Script de déploiement Blue-Green pour Firebase Hosting (PowerShell)
# Usage: .\deploy.ps1 [blue|green|promote|status]

param(
    [Parameter(Position=0)]
    [ValidateSet("blue", "green", "promote", "status", "help")]
    [string]$Action = "help"
)

$PROJECT_ID = "ecommerce-55dd8"

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

    flutter build web --release --web-renderer canvaskit
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Write-Success "Construction terminée"
}

# Déployer sur un canal spécifique
function Deploy-ToChannel {
    param([string]$Channel)

    Write-Status "Déploiement sur le canal '$Channel'..."

    firebase hosting:channel:deploy $Channel --project $PROJECT_ID --expires 30d
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    # Récupérer l'URL de prévisualisation
    $channelList = firebase hosting:channel:list --project $PROJECT_ID | Out-String
    $lines = $channelList -split "`n"
    $channelLine = $lines | Where-Object { $_ -match $Channel }

    if ($channelLine) {
        $url = ($channelLine -split "\s+")[2]
        Write-Success "Déployé sur: $url"
        $url | Out-File -FilePath ".deployment-url" -Encoding UTF8
    }
}

# Promouvoir vers la production
function Invoke-PromoteToLive {
    Write-Status "Promotion vers la production..."

    # Demander confirmation
    $confirmation = Read-Host "Êtes-vous sûr de vouloir promouvoir vers la production? (y/N)"
    if ($confirmation -notmatch "^[Yy]$") {
        Write-Warning "Promotion annulée"
        return
    }

    # Lister les canaux disponibles
    Write-Status "Canaux disponibles:"
    firebase hosting:channel:list --project $PROJECT_ID

    $sourceChannel = Read-Host "Entrez le nom du canal à promouvoir"

    firebase hosting:clone "${PROJECT_ID}:${sourceChannel}" "${PROJECT_ID}:live"
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Promotion vers la production réussie!"
        Write-Success "URL de production: https://$PROJECT_ID.web.app"
    }
}

# Afficher le statut
function Show-Status {
    Write-Status "État des déploiements:"
    firebase hosting:channel:list --project $PROJECT_ID
}

# Afficher l'aide
function Show-Help {
    Write-Host "Usage: .\deploy.ps1 [blue|green|promote|status]"
    Write-Host ""
    Write-Host "Commandes:"
    Write-Host "  blue     - Déployer sur le canal blue"
    Write-Host "  green    - Déployer sur le canal green"
    Write-Host "  promote  - Promouvoir un canal vers la production"
    Write-Host "  status   - Afficher l'état des canaux"
    Write-Host ""
    Write-Host "Workflow Blue-Green:"
    Write-Host "1. Déployez sur le canal inactif (blue ou green)"
    Write-Host "2. Testez l'application sur l'URL de prévisualisation"
    Write-Host "3. Promouvez vers la production avec 'promote'"
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
        Invoke-PromoteToLive
    }
    "status" {
        Show-Status
    }
    default {
        Show-Help
    }
}
