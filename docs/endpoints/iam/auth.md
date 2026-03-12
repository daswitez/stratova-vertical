# IAM Service Authentication Endpoints

These endpoints are used for administrative login and session bootstrap. Public self-registration is disabled.

**Base URL**: `http://localhost:8080/api/v1/auth`

## Current Auth Behavior

- `POST /api/v1/auth/register` is disabled for public use and returns `403 FORBIDDEN`.
- Users must be created by an authenticated administrator.
- In local `dev`, the service bootstraps a default platform admin on startup.
- `POST /api/v1/auth/login` remains the active entry point for existing users.

### Default local bootstrap admin

When running with profile `dev`, the service creates this admin automatically if it does not exist:

- `email`: `admin@solveria.local`
- `password`: `Admin12345!`
- role: `PLATFORM_ADMIN`
- `userCategory`: `ACADEMIC_ADMIN`

## Current Multi-Tenant Behavior

The service now uses an academic-first multi-tenant model.

- `tenantId` can be either:
  - an existing tenant UUID, or
  - an existing tenant code such as `adm-sis-umsa`.
- If `tenantId` does not exist yet, the service creates a new top-level tenant using that reference.
- If `tenantId` is omitted, the service creates a new tenant using `tenantName` or `<username> Workspace`.
- The response now includes `context` with:
  - `activeTenantId`
  - `memberships`
  - `teamCompetitions`

### Allowed `userCategory`

- `STUDENT`
- `PROFESSOR`
- `ACADEMIC_ADMIN`
- `FOUNDER`
- `EXECUTIVE`

## 1. Public Register

Public registration is intentionally blocked.

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "juan.perez",
    "email": "juan.perez@umsa.bo",
    "password": "SecurePass123",
    "userCategory": "STUDENT",
    "tenantId": "adm-sis-umsa"
  }'
```

### Expected Response

```json
{
  "errorCode": "FORBIDDEN",
  "message": "Public registration is disabled. An authenticated administrator must create users."
}
```

---

## 2. Login

Authenticates returning a JWT token that you can pass as a `Bearer` token in the `Authorization` header in subsequent requests to protected API endpoints.

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@solveria.local",
    "password": "Admin12345!"
  }'
```

### Expected Response Shape

If the user already belongs to tenants, teams, or platform roles, that context is returned in the response:

```json
{
  "token": "<JWT>",
  "user": {
    "id": 1,
    "username": "platform.admin",
    "email": "admin@solveria.local",
    "primaryTenantId": null,
    "userCategory": "ACADEMIC_ADMIN",
    "roles": ["ACADEMIC_ADMIN", "PLATFORM_ADMIN"]
  },
  "context": {
    "activeTenantId": null,
    "memberships": [],
    "teamCompetitions": []
  }
}
```

## Notes

- At the moment there are no protected REST admin endpoints yet for creating users, tenants, cycles, competitions, or teams.
- The default bootstrap admin exists only to close public registration and provide a controlled operator account while admin CRUDs are being implemented.
- To test the full academic context with real data today, seed PostgreSQL directly. See:
  - `iam-service/docs/api/multi-tenant-real-data-testing.md`
