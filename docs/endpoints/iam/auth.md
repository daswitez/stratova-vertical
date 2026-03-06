# IAM Service Authentication Endpoints

These endpoints are used for registering new users and logging in to the system to get a JWT token. They can be imported into Postman or run via command line.

**Base URL**: `http://localhost:8080/api/v1/auth`

## 1. Register User

Creates a new user account with multi-tenant support.
- `userCategory` can be: `STUDENT`, `FOUNDER`, `EXECUTIVE` (or any string depending on your Domain Model implementation).
- `tenantId` is optional. If not provided, a default `system-[timestamp]` tenant will be generated.

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@solveria.com",
    "password": "SecurePass123",
    "userCategory": "STUDENT",
    "tenantId": "uni-gt-001"
  }'
```

---

## 2. Login

Authenticates returning a JWT token that you can pass as a `Bearer` token in the `Authorization` header in subsequent requests to protected API endpoints.

### cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@solveria.com",
    "password": "SecurePass123"
  }'
```
