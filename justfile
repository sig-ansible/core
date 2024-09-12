@default:
    just --list

@check:
    just extensions/check

# Run the GitHub all-green workflow LOCALLY
github-all-green *ARGS:
    act -j all_green {{ARGS}}

# Watch for file changes and re-run pre-commit checks
watch-pre-commit *ARGS:
    watchexec pre-commit run -a

# Watch for file changes and run molecule converge
watch-converge *ARGS:
    watchexec just extensions/converge {{ARGS}}
