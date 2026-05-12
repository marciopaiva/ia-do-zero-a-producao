#!/bin/bash

# ci-local.sh — Simula o CI/CD localmente para teste
# Uso: ./ci-local.sh [pdf|epub|html|all] (padrão: all)

set -e  # Para no primeiro erro

COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_RED="\033[31m"
COLOR_BLUE="\033[34m"

log_info()  { echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"; }
log_ok()    { echo -e "${COLOR_GREEN}[OK]${COLOR_RESET} $1"; }
log_warn()  { echo -e "${COLOR_YELLOW}[WARN]${COLOR_RESET} $1"; }
log_error() { echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1"; }

# Verifica se Quarto está instalado
check_quarto() {
    if ! command -v quarto &> /dev/null; then
        log_error "Quarto não encontrado. Instale em https://quarto.org/docs/get-started/"
        exit 1
    fi
    log_ok "Quarto $(quarto --version | head -1) encontrado"
}

# Gera capa caso não exista
generate_cover() {
    if [ ! -f "src/assets/capa.png" ]; then
        log_warn "Capa não encontrada. Gerando capa padrão..."
        mkdir -p src/assets
        if command -v convert &> /dev/null; then
            convert -size 1600x2400 xc:'#2563eb' \
                -gravity center -pointsize 48 -fill white \
                -annotate 0 "IA:\nDo Zero à Produção" \
                src/assets/capa.png
            log_ok "Capa gerada em src/assets/capa.png"
        else
            log_warn "ImageMagick não instalado. Crie src/assets/capa.png manualmente."
        fi
    else
        log_ok "Capa encontrada em src/assets/capa.png"
    fi
}

# Renderiza o ebook
render_book() {
    local format="$1"
    log_info "Renderizando ebook..."

    if [ "$format" = "all" ]; then
        quarto render src/
        log_ok "Todos os formatos gerados em output/"
    else
        quarto render src/ --to "$format"
        log_ok "Formato $format gerado em output/"
    fi

    # Lista arquivos gerados
    if [ -d "output" ]; then
        log_info "Arquivos gerados:"
        ls -lh output/
    fi
}

# Limpa arquivos temporários
clean() {
    log_info "Limpando arquivos temporários..."
    rm -rf _quarto output
    log_ok "Limpeza concluída."
}

# Main
main() {
    local action="${1:-all}"

    log_info "=== CI Local — IA do Zero à Produção ==="

    case "$action" in
        pdf|epub|html|all)
            check_quarto
            generate_cover
            render_book "$action"
            ;;
        clean)
            clean
            ;;
        *)
            echo "Uso: $0 [pdf|epub|html|all|clean]"
            echo "  pdf     — gera apenas PDF"
            echo "  epub    — gera apenas EPUB"
            echo "  html    — gera apenas HTML"
            echo "  all     — gera todos (padrão)"
            echo "  clean   — remove arquivos temporários"
            exit 1
            ;;
    esac

    log_ok "=== Concluído ==="
}

main "$@"
