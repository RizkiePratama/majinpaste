# MAJIN PASTE
> Super Simple Paste and Share app
> Share your snipet code securely by avoiding public Paste Service

## How To Setup
This project can be run natively or using Docker.

### Native Setup
Install All Ruby Gem and Node Dependencies
Make sure you're Running Ruby Version `3.0.0` or higher.

Ruby Gem Dep
`$ bundle install`

Node JS Dep
`$ npm install`

### Docker Setup
1.  **Build the Docker images:**
    Navigate to the project root directory and run:
    ```bash
    docker compose build
    ```
2.  **Configure Database (using .env file):**
    Docker Compose automatically loads environment variables from a file named `.env` in the project root.
    Copy the `.env.example` file to `.env` and uncomment the desired database configuration (PostgreSQL or MariaDB).
    ```bash
    cp .env.example .env
    ```
    Edit the `.env` file to choose your database:
    -   For PostgreSQL, uncomment the PostgreSQL section.
    -   For MariaDB, uncomment the MariaDB section.
    -   If no `DB_ADAPTER` is specified in `.env`, it will default to SQLite3.

# Initial Setup
If this is the first time running the project, make sure to Migrate the Database.

### Native
`$ bundle exec rake db:migrate`

### Docker
For Docker, you need to run migrations within the `app` service.
```bash
docker compose run --rm app bundle exec rake db:migrate
```

## Run and Publish

### Native
To Start the project you can execute the following rackup command
`$ bundle exec rackup -o <ip-bind> -p <port-bind>`

### Docker
To start the Dockerized application (with the database configured in your `.env` file), run:
```bash
docker compose up
```
The application will be accessible at `http://localhost:8080`.

**Live Reloading for Development:**
Thanks to the volume mount in `docker-compose.yml` and Puma's `tmp_restart` plugin configured in `config/puma.rb`, any changes made to your local application files will automatically reflect inside the running container without needing to rebuild the image or restart the `docker compose up` command.

To stop the running services, press `Ctrl+C` in the terminal where `docker compose up` is running, then execute:
```bash
docker compose down
