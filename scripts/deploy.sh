#!/bin/bash

# Script de déploiement Blue-Green local pour Firebase Hosting
# Usage: ./deploy.sh [blue|green|promote]

set -e

PROJECT_ID="ecommerce-55dd8"
CURRENT_CHANNEL=""
INACTIVE_CHANNEL=""

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier les prérequis
check_prerequisites() {
    print_status "Vérification des prérequis..."

    if ! command -v flutter &> /dev/null; then
        print_error "Flutter n'est pas installé"
        exit 1
    fi

    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI n'est pas installé. Installez avec: npm install -g firebase-tools"
        exit 1
    fi

    print_success "Prérequis OK"
}

# Construire l'application
build_app() {
    print_status "Construction de l'application Flutter..."
    flutter clean
    flutter pub get
    flutter analyze
    flutter test
    flutter build web --release --web-renderer canvaskit
    print_success "Construction terminée"
}

# Déployer sur un canal spécifique
deploy_to_channel() {
    local channel=$1
    print_status "Déploiement sur le canal '$channel'..."

    firebase hosting:channel:deploy $channel --project $PROJECT_ID --expires 30d

    local preview_url=$(firebase hosting:channel:list --project $PROJECT_ID | grep $channel | awk '{print $3}')
    print_success "Déployé sur: $preview_url"
    echo "Preview URL: $preview_url" > .deployment-url
}

# Promouvoir vers la production
promote_to_live() {
    print_status "Promotion vers la production..."

    # Demander confirmation
    read -p "Êtes-vous sûr de vouloir promouvoir vers la production? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Promotion annulée"
        exit 0
    fi

    # Lister les canaux disponibles
    print_status "Canaux disponibles:"
    firebase hosting:channel:list --project $PROJECT_ID

    read -p "Entrez le nom du canal à promouvoir: " source_channel

    firebase hosting:clone $PROJECT_ID:$source_channel $PROJECT_ID:live
    print_success "Promotion vers la production réussie!"
    print_success "URL de production: https://$PROJECT_ID.web.app"
}

# Fonction principale
main() {
    local action=${1:-"help"}

    case $action in
        "blue")
            check_prerequisites
            build_app
            deploy_to_channel "blue"
            ;;
        "green")
            check_prerequisites
            build_app
            deploy_to_channel "green"
            ;;
        "promote")
            promote_to_live
            ;;
        "status")
            print_status "État des déploiements:"
            firebase hosting:channel:list --project $PROJECT_ID
            ;;
        "help"|*)
            echo "Usage: $0 [blue|green|promote|status]"
            echo ""
            echo "Commandes:"
            echo "  blue     - Déployer sur le canal blue"
            echo "  green    - Déployer sur le canal green"
            echo "  promote  - Promouvoir un canal vers la production"
            echo "  status   - Afficher l'état des canaux"
            echo ""
            echo "Workflow Blue-Green:"
            echo "1. Déployez sur le canal inactif (blue ou green)"
            echo "2. Testez l'application sur l'URL de prévisualisation"
            echo "3. Promouvez vers la production avec 'promote'"
            ;;
    esac
}

main "$@"
