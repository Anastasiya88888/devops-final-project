# Todo API — Vasileva

## Призначення

REST API для керування списком завдань (todo-список). Підтримує створення, 
перегляд, позначення виконаним і видалення завдань. Дані зберігаються в PostgreSQL.

## Ендпоінти

| Метод | Шлях | Опис |
|---|---|---|
| GET | /todos | Отримати всі завдання |
| POST | /todos | Створити нове завдання (`{"title": "..."}`) |
| PATCH | /todos/:id | Позначити завдання виконаним/невиконаним |
| DELETE | /todos/:id | Видалити завдання |

## Стек

Node.js, Express, PostgreSQL, Docker, Terraform, GitHub Actions.

## Локальний запуск через Docker Compose

\`\`\`bash
docker compose up -d
curl http://localhost:3000/todos
curl -X POST http://localhost:3000/todos -H "Content-Type: application/json" -d '{"title":"Buy milk"}'
\`\`\`

## Деплой через Terraform

\`\`\`bash
cd infra
terraform init
terraform plan
terraform apply
\`\`\`

Знищити інфраструктуру після перевірки:
\`\`\`bash
terraform destroy
\`\`\`

## Змінні середовища

| Змінна | Опис | За замовчуванням |
|---|---|---|
| DB_HOST | Хост бази даних | db |
| DB_USER | Користувач Postgres | postgres |
| DB_PASSWORD | Пароль Postgres | postgres |
| DB_NAME | Назва бази даних | tododb |
| PORT | Порт застосунку | 3000 |

## GitHub Secrets, потрібні для CI/CD

| Секрет | Призначення |
|---|---|
| DOCKER_USERNAME | Логін Docker Hub |
| DOCKER_TOKEN | Access Token Docker Hub |
| EC2_HOST | Адреса сервера деплою |
| EC2_PORT | Порт SSH |
| EC2_USER | Користувач на сервері |
| EC2_SSH_KEY_B64 | Приватний SSH-ключ у base64 |

## Примітка щодо інфраструктури

Через відсутність доступу до верифікації банківської картки AWS, хмарний 
провайдер Terraform замінено на Docker Provider (kreuzwerker/docker). 
Усі принципи IaC (init/plan/apply/destroy, variables, outputs) збережено 
повністю — Terraform автоматично створює мережу та два контейнери 
(застосунок + база даних) на сервері.

## CI/CD пайплайн

При push у main (зміни в students/vasileva/**):
1. Встановлення залежностей
2. Збірка й пуш Docker-образу в Docker Hub із тегом хешу коміту
3. Копіювання Terraform-конфігурації на сервер по SSH
4. Виконання terraform init + apply на сервері з новим тегом образу



