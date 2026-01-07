# DevOps Monitoring & Web (Docker)

Tento projekt je ukazkovy DevOps stack postaveny pomoci Docker a Docker compose.
Slouzi jako webova aplikace, background worker a monitoring infrastruktury.

# Architektura

Projekt bezi jako samostatne kontejnery navzajem propojene pres network a sdilejici data pres volumes.
Projekt obsahhuje tyto sluzby:

- Web1
  -Nginx
  -PHP-FPM
  -Sdilene volumes pro webovy obsah a logy

- Worker
  -Bash scripty bezici periodicky pomoci cron
  -monitoring / sber dat
  -Zapis dat do JSON / logu

- PostgreSQL
  -Databaze pro ukladani monitorovanych dat

- Prometheus
  -Sber metrik

- Node Exporter
  -Monitoring hosta

- Grafana
  -Vizualizace metrik

- Caddy
  -Reverse proxy + HTTPS

Kontejnery bezi ve spolecne docker siti.

# Pozadavky na spusteni
- Linux
- Docker
- Docker compose

# Spusteni
```bash
docker compose up -d
```
# Poznamka
Tato konfigurace slouzi pro nasazeni na mem serveru hanslab.eu.
Pro lokalni spusteni je treba upravit nginx.conf Caddyfile.
-domenu
-HTTPS
