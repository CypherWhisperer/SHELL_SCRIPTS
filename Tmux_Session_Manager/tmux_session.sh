#!/bin/bash

# Enhanced Tmux Session Manager with fzf
# Usage: ./tmux-sessions.sh [session_name]
# If no args: fzf selection of existing sessions
# With arg: create/attach to specific session

PREDEFINED_SESSIONS=("cpp" "rust" "web" "bash" "gen")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[tmux-mgr]${NC} $1"
}

success() {
    echo -e "${GREEN}[tmux-mgr]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[tmux-mgr]${NC} $1"
}

error() {
    echo -e "${RED}[tmux-mgr]${NC} $1"
}

# Check if fzf is available
check_fzf() {
    if ! command -v fzf &> /dev/null; then
        error "fzf is required but not installed. Please install fzf first."
        echo "  Ubuntu/Debian: sudo apt install fzf"
        echo "  macOS: brew install fzf"
        echo "  Arch: sudo pacman -S fzf"
        exit 1
    fi
}

# Create predefined sessions if they don't exist
create_predefined_sessions() {
    log "Checking predefined sessions..."
    local created_count=0
    
    for session in "${PREDEFINED_SESSIONS[@]}"; do
        if ! tmux has-session -t "$session" 2>/dev/null; then
            log "Creating session: $session"
            tmux new-session -d -s "$session"
            created_count=$((created_count + 1))
        fi
    done
    
    if [ $created_count -gt 0 ]; then
        success "Created $created_count new sessions"
    else
        log "All predefined sessions already exist"
    fi
}

# Get list of all tmux sessions with status info
get_session_list() {
    if ! tmux list-sessions &>/dev/null; then
        echo ""
        return
    fi
    
    local current_session=""
    if [ -n "$TMUX" ]; then
        current_session=$(tmux display-message -p '#S')
    fi
    
    tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r session; do
        local windows=$(tmux list-windows -t "$session" 2>/dev/null | wc -l)
        local status="[$windows windows]"
        
        if [ "$session" = "$current_session" ]; then
            echo "$session $status (current)"
        else
            echo "$session $status"
        fi
    done
}

# Graceful session switching
switch_to_session() {
    local target_session="$1"
    local current_session=""
    
    # Check if we're inside tmux
    if [ -n "$TMUX" ]; then
        current_session=$(tmux display-message -p '#S')
        
        if [ "$current_session" = "$target_session" ]; then
            warn "Already in session: $target_session"
            return 0
        fi
        
        log "Switching from '$current_session' to '$target_session'"
        # Switch to target session (tmux will handle the switch gracefully)
        tmux switch-client -t "$target_session"
    else
        log "Attaching to session: $target_session"
        tmux attach-session -t "$target_session"
    fi
}

# Create or attach to session
create_or_attach() {
    local session_name="$1"
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        success "Session '$session_name' exists"
        switch_to_session "$session_name"
    else
        log "Creating new session: $session_name"
        tmux new-session -d -s "$session_name"
        switch_to_session "$session_name"
    fi
}

# fzf session selection
select_session_with_fzf() {
    check_fzf
    
    local sessions
    sessions=$(get_session_list)
    
    if [ -z "$sessions" ]; then
        warn "No tmux sessions found"
        return 1
    fi
    
    local selected
    selected=$(echo "$sessions" | fzf \
        --height=40% \
        --border \
        --prompt="Select tmux session: " \
        --preview="echo 'Session: {}' && echo && tmux list-windows -t {1} 2>/dev/null || echo 'No windows info available'" \
        --preview-window="right:50%" \
        --header="↑/↓ navigate • Enter: select • Esc: cancel")
    
    if [ -n "$selected" ]; then
        # Extract session name (first word)
        local session_name
        session_name=$(echo "$selected" | awk '{print $1}')
        switch_to_session "$session_name"
    else
        log "Selection cancelled"
        return 1
    fi
}

# Show help
show_help() {
    echo "Enhanced Tmux Session Manager"
    echo
    echo "Usage:"
    echo "  $0                    # fzf selection of existing sessions"
    echo "  $0 <session_name>     # create/attach to specific session"
    echo "  $0 -h, --help         # show this help"
    echo
    echo "Predefined sessions: ${PREDEFINED_SESSIONS[*]}"
    echo
    echo "Features:"
    echo "  • Auto-creates predefined sessions on first run"
    echo "  • fzf integration for session selection"
    echo "  • Graceful session switching (preserves current session)"
    echo "  • Works both inside and outside tmux"
}

# Main logic
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        "")
            # No arguments: create predefined sessions and show fzf selector
            create_predefined_sessions
            select_session_with_fzf
            ;;
        *)
            # Argument provided: create/attach to specific session
            local session_name="$1"
            create_or_attach "$session_name"
            ;;
    esac
}

# Ensure tmux is available
if ! command -v tmux &> /dev/null; then
    error "tmux is required but not installed"
    exit 1
fi

main "$@"
