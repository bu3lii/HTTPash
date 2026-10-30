#!/usr/bin/env bash

# HTTPash v0.1.0

IFS= read -r request_line || exit 0

request_line=${request_line%$'\r'}

read -r method path version <<< "$request_line"

while IFS= read -r line; do
    [[ "${line%$'\r'}" == "" ]] && break
done

printf 'Method: %s\n' "$method" >&2
printf 'Path: %s\n' "$path" >&2
printf 'Version: %s\n' "$version" >&2

body="Hello from HTTPash"

printf 'HTTP/1.1 200 OK \r\n'
printf 'Content-Type: text/plain\r\n'
printf 'Content-Length: %d\r\n' "${#body}"
printf 'Connection: close\r\n'
printf '\r\n'
printf '%s' "$body"