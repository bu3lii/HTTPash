#!/usr/bin/env bash

# HTTPash v0.1.1

IFS= read -r request_line || exit 0

request_line=${request_line%$'\r'}

if [[ "$request_line" =~ ^([^[:space:]]+)\ (/[^[:space:]]*)\ (HTTP/[0-9]+\.[0-9]+)$ ]]; then
    method="${BASH_REMATCH[1]}"
    path="${BASH_REMATCH[2]}"
    version="${BASH_REMATCH[3]}"
else
    printf 'HTTP/1.1 400 Bad Request\r\n'
    printf 'Content-Length: 0 \r\n'
    printf 'Connection: close\r\n'
    printf '\r\n'
    exit 0
fi

if [[ "$version" != "HTTP/1.1" ]]; then
    printf 'HTTP/1.1 505 HTTP Version Not Supported\r\n'
    printf 'Content-Length: 0\r\n'
    printf 'Connection: close\r\n'
    printf '\r\n'
    exit 0
fi

while IFS= read -r line; do
    [[ "${line%$'\r'}" == "" ]] && break
done

case "$method" in
    GET|HEAD)
    ;;

    POST|PUT|PATCH|DELETE|OPTIONS)
        printf 'HTTP/1.1 405 Method Not Allowed\r\n'
        printf 'Allow: GET, HEAD\r\n'
        printf 'Content-Length: 0\r\n'
        printf 'Connection: close\r\n'
        printf '\r\n'
        exit 0
    ;;

    *)
        printf 'HTTP/1.1 501 Not Implemented\r\n'
        printf 'Content-Length: 0\r\n'
        printf 'Connection: close\r\n'
        printf '\r\n'
        exit 0
    ;;

esac

printf 'Method: %s\n' "$method" >&2
printf 'Path: %s\n' "$path" >&2
printf 'Version: %s\n' "$version" >&2

body="Hello from HTTPash"

printf 'HTTP/1.1 200 OK \r\n'
printf 'Content-Type: text/plain\r\n'
printf 'Content-Length: %d\r\n' "${#body}"
printf 'Connection: close\r\n'
printf '\r\n'

if [[ "$method" != "HEAD" ]]; then
    printf '%s' "$body"
fi