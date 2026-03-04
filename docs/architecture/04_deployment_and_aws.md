# Arquitectura de Despliegue en AWS (Staging / Producción)

El despliegue de **Solveria SSSP** pasa de usar una arquitectura de contenedores Docker en local, a un modelo orquestado y altamente disponible en Amazon Web Services (AWS).

Esta capa asegura que la simulación adversaria y predictiva escale junto con la cantidad de alumnos y corporaciones que utilizan el software.

## 1. Topología de Red (VPC)
Todo el sistema residirá dentro de una única Virtual Private Cloud (VPC) con:
- **Subredes Públicas:** Contienen los Application Load Balancers (ALB) y el API Gateway.
- **Subredes Privadas:** Contienen los clusters de microservicios (Backend Java) y todos los motores de bases de datos. No hay acceso directo desde Internet hacia la lógica ni los datos.
- **NAT Gateway:** Para permitir que el `ai-service` y el `simulation-service` puedan consultar la API de **DeepSeek** o descargar paquetes externos, manteniendo la seguridad de las IPs de origen.

## 2. Orquestación de Microservicios
- Opción Principal: **Amazon EKS (Elastic Kubernetes Service)**
  - Los 3 microservicios (`iam-service`, `ai-service`, `simulation-service`) se desplegarán como Pods administrados.
  - Esto facilita el escalado automático de los *Listeners* asíncronos en caso de picos (ej. final de semestre universitario donde muchas aulas generan simulaciones a la vez).

## 3. Capa de Bases de Datos Administradas
A diferencia de los contenedores locales, en la nube AWS delegamos la gestión operativa a servicios PaaS:

| Motor Local | Servicio Equivalente AWS | Propósito |
|---|---|---|
| PostgreSQL (IAM) | **Amazon RDS para PostgreSQL** | Datos relacionales de tenants, perfiles y suscripciones. Alta disponibilidad multi-AZ. |
| PostgreSQL + PgVector | **Amazon RDS para PostgreSQL** | Amazon RDS soporta nativamente la extensión `vector` desde RDS Postgres 15.2. Escalará la RAG. |
| MongoDB Local | **Amazon DocumentDB** (Compatible) o **MongoDB Atlas sobre AWS** | El Estado Central de Simulación. Se prefiere DocumentDB si buscamos todo nativo en AWS, u Atlas si necesitamos Change Streams más exóticos integrados nativamente. |
| Redis Local | **Amazon ElastiCache para Redis** | Distributed Locks, Cache de sesión y tokens, rate-limiting para controlar el Billing de IA. |

## 4. Pipeline de CI/CD
El flujo será controlado mediante GitHub Actions o AWS CodePipeline:
1. Al hacer Push a la rama `main` en cualquiera de los repositorios verticales, inicia el CI.
2. Contrato Pact: El servicio que sube cambios valida que no rompa el contrato HTTP definido con otros servicios.
3. Se compila el `.jar` con Maven (ejecutando Unit Tests y ArchUnit).
4. Se construye la **Imagen Docker** a partir del `.jar` y se sube a **Amazon ECR (Elastic Container Registry)**.
5. Se actualiza el manifiesto o el Job en **Amazon EKS** provocando un despliegue sin tiempo de inactividad (Rolling Update).

## 5. Gestión de Secretos
- Las API Keys (como el token de DeepSeek) o las contraseñas de las bases de datos NO vivirán en variables de entorno fijas en Kubernetes.
- Se inyectarán en tiempo de ejecución utilizando **AWS Secrets Manager** o **AWS Systems Manager Parameter Store**.
