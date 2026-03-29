#!/usr/bin/bash
set -euo pipefail

CSV_FILE=""

print_help() {
    cat <<EOF
NAME
    $(basename "$0") - generate Google job search links in an HTML report

SYNOPSIS
    $(basename "$0") [-f FILE]
    $(basename "$0") [--file FILE]
    $(basename "$0") [-h|--help]

DESCRIPTION
    Builds Google site-search links for:
      - boards.greenhouse.io
      - myworkdayjobs.com

    Without -f/--file, the script prompts for a single role.
    With -f/--file, roles are read from the CSV first column.

OPTIONS
    -f FILE, --file FILE
        Optional CSV file containing roles. The first column is used.
        Blank lines are ignored. A first-row header named "role" is ignored.

    -h, --help
        Show this help message and exit.

EXAMPLES
    $(basename "$0")
    $(basename "$0") -f roles.csv
    $(basename "$0") --file roles.csv

EXIT STATUS
    0 on success, non-zero on invalid arguments, input errors, or write failures.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            print_help
            exit 0
            ;;
        -f|--file)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a value."
                echo "Try '$(basename "$0") --help' for usage."
                exit 1
            fi
            CSV_FILE="$2"
            shift 2
            ;;
        --file=*)
            CSV_FILE="${1#*=}"
            if [[ -z "$CSV_FILE" ]]; then
                echo "Error: --file requires a non-empty value."
                echo "Try '$(basename "$0") --help' for usage."
                exit 1
            fi
            shift
            ;;
        --)
            shift
            break
            ;;
        -* )
            echo "Error: invalid option '$1'"
            echo "Try '$(basename "$0") --help' for usage."
            exit 1
            ;;
        *)
            echo "Error: unexpected argument '$1'"
            echo "Try '$(basename "$0") --help' for usage."
            exit 1
            ;;
    esac
done

if [[ $# -gt 0 ]]; then
    echo "Error: unexpected argument(s): $*"
    echo "Try '$(basename "$0") --help' for usage."
    exit 1
fi

raw_url_encode() {
    local input="$1"
    local encoded=""
    local char

    for (( i=0; i<${#input}; i++ )); do
        char="${input:i:1}"
        case "$char" in
            [a-zA-Z0-9.~_-])
                encoded+="$char"
                ;;
            ' ')
                encoded+="%20"
                ;;
            *)
                printf -v hex '%%%02X' "'$char"
                encoded+="$hex"
                ;;
        esac
    done

    printf '%s' "$encoded"
}

escape_html() {
    printf '%s' "$1" | sed \
        -e 's/&/\&amp;/g' \
        -e 's/</\&lt;/g' \
        -e 's/>/\&gt;/g' \
        -e 's/"/\&quot;/g'
}

trim_whitespace() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

normalize_csv_field() {
    local field
    field="$(trim_whitespace "$1")"
    if [[ "$field" == '"'*'"' ]] && [[ ${#field} -ge 2 ]]; then
        field="${field:1:${#field}-2}"
    fi
    printf '%s' "$(trim_whitespace "$field")"
}

ROLES=()

if [[ -n "$CSV_FILE" ]]; then
    if [[ ! -f "$CSV_FILE" ]]; then
        echo "Error: CSV file not found: $CSV_FILE"
        exit 1
    fi

    if [[ ! -r "$CSV_FILE" ]]; then
        echo "Error: CSV file is not readable: $CSV_FILE"
        exit 1
    fi

    line_num=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))
        line="$(trim_whitespace "$line")"

        if [[ -z "$line" ]]; then
            continue
        fi

        role_field="${line%%,*}"
        role_field="$(normalize_csv_field "$role_field")"

        if [[ -z "$role_field" ]]; then
            continue
        fi

        if [[ $line_num -eq 1 ]] && [[ "${role_field,,}" == "role" ]]; then
            continue
        fi

        ROLES+=("$role_field")
    done < "$CSV_FILE"

    if [[ ${#ROLES[@]} -eq 0 ]]; then
        echo "Error: no roles found in CSV file: $CSV_FILE"
        exit 1
    fi
else
    read -r -p "Enter the role to search for: " ROLE_INPUT
    ROLE_INPUT="$(trim_whitespace "$ROLE_INPUT")"

    if [[ -z "$ROLE_INPUT" ]]; then
        echo "Error: role cannot be empty."
        exit 1
    fi

    ROLES+=("$ROLE_INPUT")
fi

GENERATED_AT="$(date '+%Y-%m-%d %H:%M:%S %Z')"
if [[ -n "$CSV_FILE" ]]; then
    OUTPUT_FILE="jobsearch_links_csv_$(date '+%Y%m%d_%H%M%S').html"
else
    role_slug="$(printf '%s' "${ROLES[0]}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_' | sed 's/^_\+//; s/_\+$//')"
    if [[ -z "$role_slug" ]]; then
        role_slug="role"
    fi
    OUTPUT_FILE="jobsearch_links_${role_slug}_$(date '+%Y%m%d_%H%M%S').html"
fi

cat > "$OUTPUT_FILE" <<EOF
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Job Search Links</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 2rem;
            color: #1a1a1a;
        }
        .card {
            max-width: 900px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 1rem 1.25rem;
        }
        li {
            margin-bottom: 0.75rem;
            line-height: 1.4;
        }
        a {
            color: #005a9c;
            word-break: break-all;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>Google Job Search Links</h1>
        <p><strong>Input Mode:</strong> $(if [[ -n "$CSV_FILE" ]]; then echo "CSV (-f)"; else echo "Interactive"; fi)</p>
        $(if [[ -n "$CSV_FILE" ]]; then printf '<p><strong>CSV File:</strong> %s</p>' "$(escape_html "$CSV_FILE")"; fi)
        <p><strong>Generated:</strong> ${GENERATED_AT}</p>
        <hr>
EOF

for role in "${ROLES[@]}"; do
    query_greenhouse="site:boards.greenhouse.io \"$role\""
    query_workday="site:myworkdayjobs.com \"$role\""
    url_greenhouse="https://www.google.com/search?q=$(raw_url_encode "$query_greenhouse")"
    url_workday="https://www.google.com/search?q=$(raw_url_encode "$query_workday")"

    cat >> "$OUTPUT_FILE" <<EOF
        <h2>$(escape_html "$role")</h2>
        <ul>
            <li>
                <strong>Greenhouse:</strong>
                <a href="$(escape_html "$url_greenhouse")">$(escape_html "$url_greenhouse")</a>
            </li>
            <li>
                <strong>Workday:</strong>
                <a href="$(escape_html "$url_workday")">$(escape_html "$url_workday")</a>
            </li>
        </ul>
EOF
done

cat >> "$OUTPUT_FILE" <<EOF
    </div>
</body>
</html>
EOF

echo "HTML document created: ${OUTPUT_FILE}"
