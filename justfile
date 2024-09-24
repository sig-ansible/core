@default:
    just --list

# Run the GitHub all-green workflow LOCALLY
github-all-green *ARGS:
    act -j all_green {{ARGS}}

alias m := molecule
@molecule *ARGS:
    just -f extensions/justfile {{ARGS}}

@test:
    just molecule test-all

@clean:
    just molecule clean

alias w := watch
watch +ARGS:
    watchexec -c -r -d 500ms --print-events -- just {{ARGS}}

# Watch for file changes and re-run pre-commit checks
watch-pre-commit *ARGS:
    watchexec pre-commit run -a
alias wpc := watch-pre-commit

# Watch for file changes and run molecule converge
watch-converge TEST *ARGS:
    watchexec just molecule converge {{TEST}} {{ARGS}}
alias wc := watch-converge
