#!/bin/bash
# Script d'automatisation des tests de montée en charge
# Usage: ./run-load-tests.sh [test-type]

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration des URLs
PRODUCTION_URL="https://ecommerce-55dd8-4d606.web.app"
BLUE_URL="https://ecommerce-55dd8-4d606--blue-kwsqcu8f.web.app"
GREEN_URL="https://ecommerce-55dd8-4d606--green-flohskqk.web.app"

echo -e "${BLUE}🚀 TESTS DE MONTÉE EN CHARGE - E-COMMERCE APP${NC}"
echo "=================================================="

# Fonction pour vérifier qu'Artillery est installé
check_artillery() {
    if ! command -v artillery &> /dev/null; then
        echo -e "${RED}❌ Artillery n'est pas installé${NC}"
        echo -e "${YELLOW}💡 Installation: npm install -g artillery${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Artillery est installé${NC}"
}

# Fonction pour tester si les URLs répondent
check_urls() {
    echo -e "${BLUE}🔍 Vérification des environnements...${NC}"

    # Test Production
    if curl -s --head "$PRODUCTION_URL" | head -n 1 | grep -q "200"; then
        echo -e "${GREEN}✅ Production: $PRODUCTION_URL${NC}"
    else
        echo -e "${RED}❌ Production inaccessible${NC}"
    fi

    # Test Blue
    if curl -s --head "$BLUE_URL" | head -n 1 | grep -q "200"; then
        echo -e "${BLUE}🔵 Blue Channel: $BLUE_URL${NC}"
    else
        echo -e "${YELLOW}⚠️ Blue Channel inaccessible${NC}"
    fi

    # Test Green
    if curl -s --head "$GREEN_URL" | head -n 1 | grep -q "200"; then
        echo -e "${GREEN}🟢 Green Channel: $GREEN_URL${NC}"
    else
        echo -e "${YELLOW}⚠️ Green Channel inaccessible${NC}"
    fi
}

# Fonction pour exécuter un test avec rapport
run_test() {
    local test_name=$1
    local test_file=$2

    echo -e "${BLUE}🏃‍♂️ Lancement du test: $test_name${NC}"
    echo "Fichier: $test_file"
    echo "Heure de début: $(date)"
    echo "----------------------------------------"

    # Créer le dossier de rapports s'il n'existe pas
    mkdir -p reports

    # Lancer le test avec rapport
    artillery run "$test_file" --output "reports/${test_name}-$(date +%Y%m%d-%H%M%S).json"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Test '$test_name' terminé avec succès${NC}"
    else
        echo -e "${RED}❌ Test '$test_name' échoué${NC}"
    fi
    echo "----------------------------------------"
}

# Menu principal
case "$1" in
    "smoke")
        echo -e "${YELLOW}🔥 Test de fumée (Smoke Test)${NC}"
        check_artillery
        check_urls
        run_test "smoke" "smoke-test.yml"
        ;;

    "load")
        echo -e "${BLUE}⚡ Test de charge normale${NC}"
        check_artillery
        run_test "load" "load-test.yml"
        ;;

    "stress")
        echo -e "${RED}💪 Test de stress${NC}"
        check_artillery
        run_test "stress" "stress-test.yml"
        ;;

    "production")
        echo -e "${GREEN}🚀 Test Production${NC}"
        check_artillery
        run_test "production" "production-test.yml"
        ;;

    "blue")
        echo -e "${BLUE}🔵 Test Canal Blue${NC}"
        check_artillery
        run_test "blue-channel" "blue-test.yml"
        ;;

    "green")
        echo -e "${GREEN}🟢 Test Canal Green${NC}"
        check_artillery
        run_test "green-channel" "green-test.yml"
        ;;

    "all")
        echo -e "${YELLOW}🎯 Test complet des 3 environnements${NC}"
        check_artillery
        check_urls

        echo -e "\n${GREEN}🚀 1/3 - Test Production${NC}"
        run_test "production-complete" "production-test.yml"

        echo -e "\n${BLUE}🔵 2/3 - Test Canal Blue${NC}"
        run_test "blue-complete" "blue-test.yml"

        echo -e "\n${GREEN}🟢 3/3 - Test Canal Green${NC}"
        run_test "green-complete" "green-test.yml"

        echo -e "\n${GREEN}🎉 TOUS LES TESTS TERMINÉS !${NC}"
        ;;

    "help"|*)
        echo -e "${YELLOW}📖 Usage: ./run-load-tests.sh [option]${NC}"
        echo ""
        echo "Options disponibles:"
        echo "  smoke      - Test de fumée rapide"
        echo "  load       - Test de charge normale"
        echo "  stress     - Test de stress intensif"
        echo "  production - Test de l'environnement de production"
        echo "  blue       - Test du canal Blue (develop)"
        echo "  green      - Test du canal Green (PR)"
        echo "  all        - Test complet des 3 environnements"
        echo "  help       - Afficher cette aide"
        echo ""
        echo -e "${BLUE}Exemples:${NC}"
        echo "  ./run-load-tests.sh smoke"
        echo "  ./run-load-tests.sh all"
        ;;
esac
