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

[doc("""
List all existing git worktrees.
""")]
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
