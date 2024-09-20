@default:
    just --list

# Run the GitHub all-green workflow LOCALLY
github-all-green *ARGS:
    act -j all_green {{ARGS}}

alias m := molecule

@molecule *ARGS:
    cd extensions && just {{ARGS}}

@test:
    just molecule test-all

@clean:
    just molecule clean

# Watch for file changes and re-run pre-commit checks
watch-pre-commit *ARGS:
    watchexec pre-commit run -a

# Watch for file changes and run molecule converge
watch-converge TEST *ARGS:
    watchexec just molecule converge {{TEST}} {{ARGS}}
alias wc := watch-converge
