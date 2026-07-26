#!/usr/bin/env bash

set -euo pipefail

SUBMODULE_NAME="microsoft-office-template"

error() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

report() {
    local status="$1"
    local path="$2"

    printf '%-10s %s\n' "${status}" "${path}"
}

copy_managed_file() {
    local source="$1"
    local destination="$2"
    local relative_destination="${destination#"${BASE}/"}"

    [[ -f "${source}" ]] || error "Required source file is missing: ${source}"

    mkdir -p "$(dirname "${destination}")"

    if [[ ! -e "${destination}" ]]; then
        cp -- "${source}" "${destination}"
        report "CREATED" "${relative_destination}"
    elif cmp -s -- "${source}" "${destination}"; then
        report "CURRENT" "${relative_destination}"
    else
        cp -- "${source}" "${destination}"
        report "REFRESHED" "${relative_destination}"
    fi
}

copy_if_missing() {
    local source="$1"
    local destination="$2"
    local relative_destination="${destination#"${BASE}/"}"

    [[ -f "${source}" ]] || error "Required source file is missing: ${source}"

    if [[ -e "${destination}" ]]; then
        report "PRESERVED" "${relative_destination}"
        return
    fi

    mkdir -p "$(dirname "${destination}")"
    cp -- "${source}" "${destination}"
    report "CREATED" "${relative_destination}"
}

command -v git >/dev/null 2>&1 ||
    error "Git is not available on PATH."

BASE="$(git rev-parse --show-toplevel 2>/dev/null)" ||
    error "Run this script from within your own Git repository."

cd "${BASE}"

PUBLIC_ROOT="${BASE}/${SUBMODULE_NAME}"
GITMODULES="${BASE}/.gitmodules"

[[ -f "${GITMODULES}" ]] ||
    error "No .gitmodules file was found in ${BASE}."

[[ -d "${PUBLIC_ROOT}" ]] ||
    error "The ${SUBMODULE_NAME} submodule directory was not found."

if ! git config \
    --file "${GITMODULES}" \
    --get-regexp '^submodule\..*\.path$' |
    awk '{print $2}' |
    grep -Fxq "${SUBMODULE_NAME}"; then
    error "${SUBMODULE_NAME} is not registered as a Git submodule."
fi

[[ -f "${PUBLIC_ROOT}/src/Style-Specimen.docx" ]] ||
    error "The submodule is incomplete. Run: git submodule update --init"

printf '\nInitializing Microsoft Office template repository\n'
printf 'Repository: %s\n\n' "${BASE}"

mkdir -p \
    "${BASE}/.github/workflows" \
    "${BASE}/src/brands" \
    "${BASE}/releases"

report "ENSURED" ".github/workflows/"
report "ENSURED" "src/brands/"
report "ENSURED" "releases/"

# User-managed configuration files are created only when absent.
copy_if_missing \
    "${PUBLIC_ROOT}/.gitattributes" \
    "${BASE}/.gitattributes"

copy_if_missing \
    "${PUBLIC_ROOT}/.gitignore" \
    "${BASE}/.gitignore"

# Project-managed files are refreshed whenever this script runs.
copy_managed_file \
    "${PUBLIC_ROOT}/src/README.md" \
    "${BASE}/src/README.md"

copy_managed_file \
    "${PUBLIC_ROOT}/src/Style-Specimen.docx" \
    "${BASE}/src/Style-Specimen.docx"

copy_managed_file \
    "${PUBLIC_ROOT}/releases/README.md" \
    "${BASE}/releases/README.md"

copy_managed_file \
    "${PUBLIC_ROOT}/templates/publish-office-templates.yml" \
    "${BASE}/.github/workflows/publish-office-templates.yml"

cat <<'EOF'

Initialization complete.

Managed file notice
-------------------
src/Style-Specimen.docx is maintained by microsoft-office-template and
may be overwritten whenever this script is run.

Before modifying the specimen itself, copy it to another filename, such
as:

    src/My-Style-Specimen.docx

Next steps
----------
1. Copy src/Style-Specimen.docx into a directory under src/brands/.
2. Replace the logo and contact information in each branded copy.
3. Save completed Word templates as .dotx files under releases/.
4. Commit and push the repository.
5. Run "Publish Office Templates" from the GitHub Actions tab.
EOF
