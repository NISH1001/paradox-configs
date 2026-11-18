default:
  just --list

[doc("""
Create a new git worktree with Python virtual environment setup.
Examples:
* Create worktree for branch 'feature/foo-bar' with Python 3.11
just worktree feature/foo-bar 3.11
* Create worktree for branch 'hotfix/bug-123' with Python 3.12
just worktree hotfix/bug-123 3.12
* Create worktree for branch 'develop' with default Python (3.12)
just worktree develop
""")]
worktree branch python="3.12" working_dir=invocation_directory():
    #!/bin/bash
    set -euo pipefail
    # Change to the directory where just was invoked
    cd "{{working_dir}}"
    
    # Create .worktrees directory if it doesn't exist
    mkdir -p .worktrees
    
    # Replace forward slashes in branch name with dashes for directory name
    safe_branch=$(echo "{{branch}}" | sed 's/\//-/g')
    worktree_path=".worktrees/${safe_branch}"
    
    echo "Creating git worktree for branch '{{branch}}' at path: $worktree_path"
    
    # Check if branch already exists locally
    if git show-ref --verify --quiet "refs/heads/{{branch}}"; then
        echo "Branch '{{branch}}' already exists locally, checking it out"
        git worktree add "$worktree_path" "{{branch}}"
    elif git show-ref --verify --quiet "refs/remotes/origin/{{branch}}"; then
        echo "Branch '{{branch}}' exists on remote, checking it out"
        git worktree add "$worktree_path" "origin/{{branch}}" -b "{{branch}}"
    else
        echo "Creating new branch '{{branch}}'"
        # Get the default branch name from remote
        default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5 2>/dev/null || echo "main")
        
        # Try to create worktree from remote default branch, fallback to local if remote doesn't exist
        if git show-ref --verify --quiet "refs/remotes/origin/$default_branch"; then
            echo "Creating worktree from origin/$default_branch"
            git worktree add "$worktree_path" "origin/$default_branch" -b "{{branch}}"
        elif git show-ref --verify --quiet "refs/heads/$default_branch"; then
            echo "Creating worktree from local $default_branch"
            git worktree add "$worktree_path" "$default_branch" -b "{{branch}}"
        else
            echo "Creating worktree from current branch"
            git worktree add "$worktree_path" -b "{{branch}}"
        fi
    fi
    
    echo "Moving into worktree directory: $worktree_path"
    cd "$worktree_path"
    
    # Create virtual environment with uv (with python version if specified)
    echo "Creating virtual environment with uv using Python {{python}}..."
    uv venv --python "{{python}}"
    
    # Activate the virtual environment and install project in editable mode
    echo "Installing project in editable mode..."
    source .venv/bin/activate
    uv pip install -e .
    
    echo "✅ Worktree setup complete!"
    echo "📁 Worktree location: $worktree_path"
    echo "🐍 To activate the environment, run: source $worktree_path/.venv/bin/activate"

[doc("""
Remove a git worktree and clean up its directory.
Examples:
* Remove worktree for branch 'feature/foo-bar'
just worktree-remove feature/foo-bar
* Remove worktree for branch 'hotfix/bug-123'  
just worktree-remove hotfix/bug-123
""")]
worktree-remove branch working_dir=invocation_directory():
    #!/bin/bash
    set -euo pipefail
    # Change to the directory where just was invoked
    cd "{{working_dir}}"
    
    # Replace forward slashes in branch name with dashes for directory name
    safe_branch=$(echo "{{branch}}" | sed 's/\//-/g')
    worktree_path=".worktrees/${safe_branch}"
    
    # Check if worktree directory exists
    if [ ! -d "$worktree_path" ]; then
        echo "❌ Worktree directory not found: $worktree_path"
        echo "Available worktrees:"
        if [ -d ".worktrees" ]; then
            ls -1 .worktrees/ | sed 's/^/  /'
        else
            echo "  No worktrees found"
        fi
        exit 1
    fi
    
    echo "Removing git worktree for branch '{{branch}}' at path: $worktree_path"
    
    # Remove the git worktree (this also removes the directory)
    git worktree remove "$worktree_path" --force
    
    echo "✅ Worktree removed successfully!"
    echo "🗑️  Directory cleaned up: $worktree_path"

[doc("List all existing git worktrees.")]
worktree-list working_dir=invocation_directory():
    #!/bin/bash
    set -euo pipefail
    # Change to the directory where just was invoked
    cd "{{working_dir}}"
    
    echo "📋 Git worktrees:"
    git worktree list
    
    echo ""
    echo "📁 Local worktree directories:"
    if [ -d ".worktrees" ]; then
        ls -la .worktrees/
    else
        echo "  No .worktrees directory found"
    fi

[doc("Run pytest. Usage: just test (basic) or just test akd (with coverage for akd package) or just test . (with full coverage)")]
test cov="" working_dir=invocation_directory():
    #!/bin/bash
    set -euo pipefail
    cd "{{working_dir}}"
    
    if [ -z "{{cov}}" ]; then
        python -m pytest tests/ -v
    else
        python -m pytest --cov={{cov}} --cov-report=term-missing tests/ -v
    fi

[doc("""
Run a Python script with unbuffered output, displaying and logging to a file.
Examples:
* just lpython test_log.py log.txt
* just lpython my_script.py output.log
""")]
lpython script log_file working_dir=invocation_directory():
    #!/bin/bash
    set -euo pipefail
    cd "{{working_dir}}"
    python -u "{{script}}" 2>&1 | tee -a "{{log_file}}"

[doc("""
Search using natural language query converted to ripgrep command.
Examples:
* just search "find all openai imports in marimo notebooks"
* just search "search for BaseAgent in python files only"
* just search "find TODO comments in current directory"
* just search "case sensitive search for OpenAI" dry_run=true
""")]
search query dry_run="false" working_dir=invocation_directory():
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{working_dir}}"

    # Check for OpenAI API key
    if [ -z "${OPENAI_API_KEY:-}" ]; then
        echo "Error: Set OPENAI_API_KEY environment variable"
        exit 1
    fi

    # Function to check safety
    check_safety() {
        local cmd="$1"
        local DANGEROUS_PATTERNS=("rm " "mv " "cp " "dd " "mkfs" ">" ">>" ";" "&&" "||" "curl" "wget" "nc " "telnet" "chmod" "chown" "sudo" "su " "eval" "exec")

        for pattern in "${DANGEROUS_PATTERNS[@]}"; do
            if echo "$cmd" | grep -q "$pattern"; then
                echo "⚠️  WARNING: Dangerous pattern '$pattern' detected"
                echo "❌ Command blocked for safety."
                return 1
            fi
        done

        if ! echo "$cmd" | grep -q "^rg "; then
            echo "❌ Invalid: must start with 'rg'"
            return 1
        fi
        return 0
    }

    # Function to generate command
    generate_command() {
        local user_query="$1"
        local additional_context="$2"

        local base_context="Current directory: $(pwd)\nCommon flags: -i (case insensitive), -w (word boundary), -g (glob pattern), --max-depth (depth limit), -l (files only)\nFor OR searches use pipe character in regex\nFor marimo notebooks only if asked: rg PATTERN \$(rg -l import marimo)\nFor jupyter notebooks only if asked: rg PATTERN -g *.ipynb\nOutput ONLY the rg command, nothing else. No destructive operations."

        local PROMPT="Convert this search query into a ripgrep command. Return ONLY the command:\n\nQuery: $user_query\n\n$base_context$additional_context"

        local JSON_PAYLOAD=$(jq -n --arg prompt "$PROMPT" '{model: "gpt-4o-mini", messages: [{role: "user", content: $prompt}]}')

        curl -s https://api.openai.com/v1/chat/completions \
            -H "Authorization: Bearer $OPENAI_API_KEY" \
            -H "content-type: application/json" \
            -d "$JSON_PAYLOAD" | jq -r '.choices[0].message.content' | grep -o 'rg.*' | head -1
    }

    # Main loop
    ATTEMPT=1
    MAX_ATTEMPTS=3
    CONTEXT=""

    while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
        echo "🔄 Attempt $ATTEMPT/$MAX_ATTEMPTS"

        RG_CMD=$(generate_command "{{query}}" "$CONTEXT")
        echo "🔍 Generated: $RG_CMD"
        echo ""

        if ! check_safety "$RG_CMD"; then
            exit 1
        fi

        if [ "{{dry_run}}" = "true" ]; then
            echo "✅ Safe - dry run mode"
            exit 0
        fi

        echo "Execute? [y/N] "
        read -r response

        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "❌ Cancelled"
            exit 0
        fi

        echo ""
        echo "Running..."

        if eval "$RG_CMD"; then
            echo ""
            echo "✅ Done!"
            exit 0
        else
            EXIT_CODE=$?
            if [ $EXIT_CODE -eq 1 ]; then
                echo ""
                echo "❌ No matches found."

                if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
                    echo ""
                    echo "Try:"
                    echo "  1) OR search with key terms"
                    echo "  2) Remove word boundaries (partial match)"
                    echo "  3) Search subdirectories"
                    echo "  4) Different file types"
                    echo "  5) Custom feedback"
                    echo "  q) Quit"
                    echo -n "Choose [1-5/q]: "
                    read -r choice

                    case $choice in
                        1) CONTEXT="\n\nPrevious failed. Try OR pattern with multiple keywords." ;;
                        2) CONTEXT="\n\nPrevious failed. Remove -w flag, use -i for case insensitive." ;;
                        3) CONTEXT="\n\nPrevious failed. Remove or increase --max-depth." ;;
                        4) CONTEXT="\n\nPrevious failed. Try different file patterns or types." ;;
                        5)
                            echo -n "Your feedback: "
                            read -r feedback
                            CONTEXT="\n\nPrevious failed. User says: $feedback"
                            ;;
                        q|Q) echo "Exiting."; exit 0 ;;
                        *) CONTEXT="\n\nPrevious failed. Try different approach." ;;
                    esac

                    ATTEMPT=$((ATTEMPT + 1))
                else
                    echo ""
                    echo "Max attempts reached."
                    exit 0
                fi
            else
                echo ""
                echo "Failed with exit code $EXIT_CODE"
                exit $EXIT_CODE
            fi
        fi
    done
