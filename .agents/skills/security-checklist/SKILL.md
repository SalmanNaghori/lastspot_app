---
name: security-checklist
description: Immediately use when a user supplies actual or suspected raw credentials, API keys, secrets, passwords, tokens, session cookies, or private keys; pause execution and guide safe recovery. Also use before finishing changes involving authentication, authorization, payments, user data, file uploads, or external services.
---

# Security checklist

## Credential exposure gate

Apply this gate as soon as a credential appears in user-supplied text, snippets,
logs, screenshots, or attachments, including a follow-up during an active task.
It applies to all requests, including prompt rewriting and non-coding work.

1. Stop task execution and task tool calls immediately. Do not continue with
   unrelated inspection, planning, implementation, or delegation while paused.
2. Do not repeat, partially quote, encode, hash, test, or use the value. Keep it
   out of tool arguments, files, logs, memory, briefs, handoffs, and commits.
   Never contact a service to check whether the credential works.
3. Tell the user the request appears to contain a credential, without quoting
   it. Ask them to revoke or rotate it through the provider, or invalidate the
   affected session, and resend the request with the value removed. Redacting
   or deleting the message alone does not invalidate the exposed credential.
4. Have the user configure any replacement themselves through the project's
   secret manager or local environment. Ask only for a variable name or secret
   reference, never the replacement value. Do not claim to erase chat history.
5. Resume only after receiving a sanitized request and confirmation that the
   credential was revoked, rotated, or already invalid. If the value was
   ambiguous, confirmation that it was a dummy example or non-secret identifier
   plus a sanitized request also clears the gate. Permission to use the exposed
   value, even temporarily, does not clear it.

Credentials include API keys and API secrets, passwords, access and refresh
tokens, session cookies, private keys, and connection strings containing
credentials. Sandbox or test credentials that grant access still trigger the
gate. Clearly redacted values, placeholders such as `<API_KEY>` or
`[REDACTED]`, environment-variable references, and known public identifiers do
not. If uncertain, keep the task paused and ask whether the value is a dummy
or public identifier without asking the user to paste it again.

Example response, with no credential copied:

> I’m pausing because your request appears to contain a credential. Please
> revoke or rotate it with the provider, configure the replacement securely,
> and resend the request using a placeholder or secret reference. Confirm the
> exposed credential is no longer valid before we continue; do not paste the
> replacement here.

## Review security-sensitive changes

Run through this before opening the PR, not after a reviewer asks. Studies
of AI-assisted code have consistently found roughly a third of generated
snippets carry at least one real security issue, mostly in the categories
below, so treat this as a normal part of finishing the task, not an extra
step.

## Input handling

- Every value that comes from a user, a request, a file, or an external
  API is untrusted until validated. Validate type, length, and range, not
  just presence.
- Database queries are parameterized. If you find yourself building a query
  by concatenating a string, stop and use the query builder or an ORM
  method instead.
- Anything rendered back into HTML is escaped by the templating layer, not
  manually string-built.
- File uploads: check the actual content type, not just the extension, and
  never use a user-supplied filename as a filesystem path without
  sanitizing it.

## Auth and access control

- Every new endpoint or route checks who's allowed to call it. "We'll add
  auth later" is how internal admin tools end up publicly reachable.
- Authorization is checked on the resource being accessed, not just that
  the caller is logged in. A logged-in user shouldn't be able to fetch
  another user's data by changing an ID in the URL.
- Sessions and tokens have an expiry. Nothing is a permanent credential
  unless there's a specific, reviewed reason for it.

## Secrets and configuration

- No credentials, API keys, or tokens in code, comments, commit messages,
  or test fixtures, including ones you plan to rotate later. Use the
  project's secrets manager or environment variables.
- No secrets in client-side code (this includes Flutter builds and any
  JavaScript shipped to a browser). Anything bundled into a client is
  public.

## External calls

- Timeouts are set on every outbound HTTP call. An unbounded call to a
  flaky third party will eventually take your service down with it.
- Responses from external services are validated before being trusted,
  the same way user input is.

## Dependencies

- New dependencies come from the project's normal package registry, not a
  URL pasted from a search result or an agent's suggestion without
  checking it first.
- If a skill or MCP tool came from outside the company's shared library,
  someone reviewed it before it was adopted.

## If you're not sure

Flag it in the PR description under "Risk" rather than guessing. A
reviewer would rather see "I wasn't sure if this needs rate limiting" than
find out after it ships.
