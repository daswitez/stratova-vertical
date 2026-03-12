# IAM Service Authentication Endpoints

These endpoints are used for registering new users and logging in to the system to get a JWT token. They can be imported into Postman or run via command line.

**Base URL**: `http://localhost:8080/api/v1/auth`

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

## 1. Register User

Creates a new user account with multi-tenant support.
- `tenantId` is optional.
- For the academic MVP, the recommended pattern is to register the user against the most specific academic tenant available, for example a `PROGRAM` tenant such as `adm-sis-umsa`.

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

### Alternative: create tenant on first register

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "docente.mkt",
    "email": "docente.mkt@ucb.edu.bo",
    "password": "SecurePass123",
    "userCategory": "PROFESSOR",
    "tenantId": "marketing-ucb",
    "tenantName": "Marketing UCB"
  }'
```

### Expected Response Shape

```json
{
  "token": "<JWT>",
  "user": {
    "id": 1,
    "username": "juan.perez",
    "email": "juan.perez@umsa.bo",
    "primaryTenantId": "11111111-1111-1111-1111-111111111111",
    "userCategory": "STUDENT",
    "roles": ["STUDENT"]
  },
  "context": {
    "activeTenantId": "11111111-1111-1111-1111-111111111111",
    "memberships": [
      {
        "tenantId": "11111111-1111-1111-1111-111111111111",
        "tenantCode": "adm-sis-umsa",
        "tenantName": "Administracion de Sistemas UMSA",
        "tenantType": "PROGRAM",
        "membershipType": "PRIMARY"
      }
    ],
    "teamCompetitions": []
  }
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
    "email": "juan.perez@umsa.bo",
    "password": "SecurePass123"
  }'
```

### Expected Response Shape

If the user already belongs to a team in a competition, `teamCompetitions` is returned as part of the context:

```json
{
  "token": "<JWT>",
  "user": {
    "id": 1,
    "username": "juan.perez",
    "email": "juan.perez@umsa.bo",
    "primaryTenantId": "11111111-1111-1111-1111-111111111111",
    "userCategory": "STUDENT",
    "roles": ["STUDENT"]
  },
  "context": {
    "activeTenantId": "11111111-1111-1111-1111-111111111111",
    "memberships": [
      {
        "tenantId": "11111111-1111-1111-1111-111111111111",
        "tenantCode": "adm-sis-umsa",
        "tenantName": "Administracion de Sistemas UMSA",
        "tenantType": "PROGRAM",
        "membershipType": "PRIMARY"
      }
    ],
    "teamCompetitions": [
      {
        "teamId": "66666666-6666-6666-6666-666666666666",
        "teamCode": "team-andes",
        "teamName": "Team Andes",
        "memberRole": "CAPTAIN",
        "competitionId": "55555555-5555-5555-5555-555555555555",
        "competitionCode": "coresim-2026-s1",
        "competitionName": "CoreSim 2026 Semestre 1",
        "competitionScope": "CROSS_TENANT",
        "academicCycleCode": "2026-S1",
        "originTenantId": "11111111-1111-1111-1111-111111111111"
      }
    ]
  }
}
```

## Notes

- At the moment there are no REST admin endpoints yet for creating tenants, cycles, competitions, or teams.
- To test the full academic context with real data today, seed PostgreSQL directly. See:
  - `iam-service/docs/api/multi-tenant-real-data-testing.md`
