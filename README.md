# Palworld — Dedicated Server (Docker)

🇬🇧 [English](#english) | 🇫🇷 [Français](#français)

---

## English

Docker container to host a **Palworld** dedicated server (SteamCMD App ID `2394010`, Linux dedicated server build). The server binary and dependencies are downloaded automatically via SteamCMD, running as an unprivileged `jeux` user.

- Docker Hub image: [`ludix0/palworld`](https://hub.docker.com/r/ludix0/palworld)
- Ports used: `8211/udp` (game), `27015/udp` (Steam server query, optional), `8212/udp` (REST API, optional)

### Requirements

- Docker + Docker Compose
- ~10 GB free disk space for the server files (grows over time with world saves)
- Port `8211/udp` forwarded on your router if you want the server reachable from the internet (also `8212/udp` if you need the REST API remotely)

### Method 1 — Quick install from Docker Hub (recommended)

```bash
mkdir -p ~/palworld && cd ~/palworld
```

Create a `docker-compose.yml`:

```yaml
services:
  palworld:
    image: ludix0/palworld:latest
    container_name: palworld
    restart: unless-stopped
    volumes:
      - ./filesServer:/server
      - ./steamcmd:/home/jeux/.steam/steam/steamcmd
      - ./steamcmd-config:/home/jeux/.steam/steam/config
    environment:
      - TZ=Europe/Paris
      - PUID=1000
      - PGID=1000
      - UPDATE_ON_START=true
      - STEAM_USER=
      - STEAM_PASSWORD=
      - Arguments=-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS -NumberOfWorkerThreadsServer=7
      - Difficulty=None
      - DayTimeSpeedRate=1.000000
      - NightTimeSpeedRate=1.000000
      - ExpRate=1.000000
      - PalCaptureRate=1.000000
      - PalSpawnNumRate=1.000000
      - PalDamageRateAttack=1.000000
      - PalDamageRateDefense=1.000000
      - PlayerDamageRateAttack=1.000000
      - PlayerDamageRateDefense=1.000000
      - PlayerStomachDecreaceRate=1.000000
      - PlayerStaminaDecreaceRate=1.000000
      - PlayerAutoHPRegeneRate=1.000000
      - PlayerAutoHpRegeneRateInSleep=1.000000
      - PalStomachDecreaceRate=1.000000
      - PalStaminaDecreaceRate=1.000000
      - PalAutoHPRegeneRate=1.000000
      - PalAutoHpRegeneRateInSleep=1.000000
      - BuildObjectDamageRate=1.000000
      - BuildObjectDeteriorationDamageRate=1.000000
      - CollectionDropRate=1.000000
      - CollectionObjectHpRate=1.000000
      - CollectionObjectRespawnSpeedRate=1.000000
      - EnemyDropItemRate=1.000000
      - DeathPenalty=All
      - bEnablePlayerToPlayerDamage=False
      - bEnableFriendlyFire=False
      - bEnableInvaderEnemy=True
      - bActiveUNKO=False
      - bEnableAimAssistPad=True
      - bEnableAimAssistKeyboard=False
      - DropItemMaxNum=3000
      - DropItemMaxNum_UNKO=100
      - BaseCampMaxNum=128
      - BaseCampWorkerMaxNum=15
      - DropItemAliveMaxHours=1.000000
      - bAutoResetGuildNoOnlinePlayers=False
      - AutoResetGuildTimeNoOnlinePlayers=72.000000
      - GuildPlayerMaxNum=20
      - PalEggDefaultHatchingTime=72.000000
      - WorkSpeedRate=1.000000
      - bIsMultiplay=False
      - bIsPvP=False
      - bCanPickupOtherGuildDeathPenaltyDrop=False
      - bEnableNonLoginPenalty=True
      - bEnableFastTravel=True
      - bIsStartLocationSelectByMap=True
      - bExistPlayerAfterLogout=False
      - bEnableDefenseOtherGuildPlayer=False
      - CoopPlayerMaxNum=4
      - ServerPlayerMaxNum=32
      - ServerName=My Palworld Server
      - ServerDescription=
      - AdminPassword=
      - ServerPassword=
      - PublicIP=
      - RCONEnabled=False
      - Region=
      - bUseAuth=False
      - BanListURL=
      - RESTAPIEnabled=False
      - bShowPlayerList=False
      - CrossplayPlatforms=(Steam)
      - bIsUseBackupSaveData=True
    ports:
      - "8211:8211/udp"
      - "27015:27015/udp"
      - "8212:8212/udp"
```

```bash
docker compose up -d
docker compose logs -f
```

### Method 2 — Build from source (GitHub)

```bash
git clone https://github.com/ludix0/palworld.git
cd palworld
ln -sf /path/to/your/secrets.env .env   # or create a .env with the variables below
docker build -t ludix0/palworld:latest .
docker compose up -d
```

### Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TZ`, `PUID`, `PGID` | No | Timezone and host user/group the container runs as |
| `UPDATE_ON_START` | No | `true`/`false` — update the server via SteamCMD on every container start |
| `STEAM_USER` / `STEAM_PASSWORD` | No | Leave empty for anonymous SteamCMD login (works for Palworld) |
| `Arguments` | No | `PalServer.sh` launch flags — the default enables multi-threaded performance mode |
| `Difficulty` | No | `None` (default, use the custom rates below), `Casual`, `Normal`, or `Hard` |
| `DayTimeSpeedRate` / `NightTimeSpeedRate` | No | Day/night cycle speed multipliers |
| `ExpRate` | No | Experience gain multiplier |
| `PalCaptureRate` / `PalSpawnNumRate` | No | Pal capture success rate and spawn density multipliers |
| `PalDamageRateAttack` / `PalDamageRateDefense` | No | Damage dealt/received by Pals |
| `PlayerDamageRateAttack` / `PlayerDamageRateDefense` | No | Damage dealt/received by players |
| `PlayerStomachDecreaceRate` / `PlayerStaminaDecreaceRate` | No | Player hunger/stamina depletion speed |
| `PlayerAutoHPRegeneRate` / `PlayerAutoHpRegeneRateInSleep` | No | Player HP regen speed, awake / asleep |
| `PalStomachDecreaceRate` / `PalStaminaDecreaceRate` | No | Pal hunger/stamina depletion speed |
| `PalAutoHPRegeneRate` / `PalAutoHpRegeneRateInSleep` | No | Pal HP regen speed, awake / asleep |
| `BuildObjectDamageRate` / `BuildObjectDeteriorationDamageRate` | No | Damage taken and decay speed of built structures |
| `CollectionDropRate` / `CollectionObjectHpRate` / `CollectionObjectRespawnSpeedRate` | No | Resource node drop amount, HP, and respawn speed |
| `EnemyDropItemRate` | No | Item drop rate from defeated enemies |
| `DeathPenalty` | No | What players drop on death: `None`, `Item`, `ItemAndEquipment`, or `All` |
| `bEnablePlayerToPlayerDamage` / `bEnableFriendlyFire` / `bEnableInvaderEnemy` | No | PvP damage, friendly fire, and hostile "invader" Pal raid events |
| `bActiveUNKO` | No | Enable the in-game "UNKO" (droppings) item |
| `bEnableAimAssistPad` / `bEnableAimAssistKeyboard` | No | Aim assist for gamepad / keyboard+mouse |
| `DropItemMaxNum` / `DropItemMaxNum_UNKO` | No | Max items lying on the ground (normal / UNKO items) |
| `BaseCampMaxNum` / `BaseCampWorkerMaxNum` | No | Max number of bases, and max working Pals per base |
| `DropItemAliveMaxHours` | No | Hours before dropped items despawn |
| `bAutoResetGuildNoOnlinePlayers` / `AutoResetGuildTimeNoOnlinePlayers` | No | Auto-disband guilds with no online members after N hours |
| `GuildPlayerMaxNum` | No | Max players per guild |
| `PalEggDefaultHatchingTime` | No | Egg hatching time, in hours |
| `WorkSpeedRate` | No | Pal work speed multiplier |
| `bIsMultiplay` | No | Internal multiplayer flag — leave at default unless you have a specific reason to change it |
| `bIsPvP` | No | Enable server-wide PvP |
| `bCanPickupOtherGuildDeathPenaltyDrop` | No | Allow picking up another guild's death-penalty item drops |
| `bEnableNonLoginPenalty` | No | Apply a penalty to players who stay logged out too long |
| `bEnableFastTravel` | No | Enable the fast-travel feature |
| `bIsStartLocationSelectByMap` | No | Let new players pick their spawn point on the map |
| `bExistPlayerAfterLogout` | No | Keep the player's character in the world after logout instead of despawning it |
| `bEnableDefenseOtherGuildPlayer` | No | Allow base defenses to damage players from other guilds |
| `CoopPlayerMaxNum` | No | Max players per co-op party |
| `ServerPlayerMaxNum` | No | Max total players allowed on the server |
| `ServerName` / `ServerDescription` | No | Name and description shown in the server browser |
| `AdminPassword` | No (recommended) | Admin password for in-game admin commands — set one for a production server |
| `ServerPassword` | No | Join password — leave empty for a public server |
| `PublicIP` | No | Public IP announced by the server — usually leave empty (auto-detected) |
| `RCONEnabled` / `Region` | No | Enable RCON (fixed internal port `25575`, not published by this image) and set a region tag |
| `bUseAuth` | No | Require Steam authentication for players joining |
| `BanListURL` | No | URL to an external community ban list |
| `RESTAPIEnabled` | No | Enable the REST API (port `8212`) |
| `bShowPlayerList` | No | Expose the online player list via the REST API |
| `CrossplayPlatforms` | No | Allowed crossplay platforms, e.g. `(Steam)` |
| `bIsUseBackupSaveData` | No | Enable automatic save-data backups |

### Volumes

| Volume | Content |
|--------|---------|
| `/server` | Full server install: binaries (via SteamCMD) plus world saves and config under `Pal/Saved` |
| `/home/jeux/.steam/steam/steamcmd` | Shared SteamCMD installation, avoids re-downloading on rebuild |
| `/home/jeux/.steam/steam/config` | SteamCMD login/config cache |

### Ports

| Port | Protocol | Usage |
|------|----------|-------|
| 8211 | UDP | Game traffic — must be reachable by players |
| 27015 | UDP | Steam server list query — optional, exposed by the image but not required for a private server |
| 8212 | UDP | REST API — only needed if `RESTAPIEnabled=True` |

---

## Français

Conteneur Docker pour héberger un serveur dédié **Palworld** (App ID SteamCMD `2394010`, build serveur dédié Linux). Le binaire du serveur et ses dépendances sont téléchargés automatiquement via SteamCMD, en exécutant le serveur avec un utilisateur `jeux` non privilégié.

- Image Docker Hub : [`ludix0/palworld`](https://hub.docker.com/r/ludix0/palworld)
- Ports utilisés : `8211/udp` (jeu), `27015/udp` (requête liste de serveurs Steam, optionnel), `8212/udp` (API REST, optionnel)

### Prérequis

- Docker + Docker Compose
- ~10 Go d'espace disque libre pour les fichiers du serveur (augmente avec le temps grâce aux sauvegardes du monde)
- Port `8211/udp` redirigé sur votre routeur si le serveur doit être accessible depuis internet (aussi `8212/udp` si vous utilisez l'API REST à distance)

### Méthode 1 — Installation rapide depuis Docker Hub (recommandé)

```bash
mkdir -p ~/palworld && cd ~/palworld
```

Créer un `docker-compose.yml` :

```yaml
services:
  palworld:
    image: ludix0/palworld:latest
    container_name: palworld
    restart: unless-stopped
    volumes:
      - ./filesServer:/server
      - ./steamcmd:/home/jeux/.steam/steam/steamcmd
      - ./steamcmd-config:/home/jeux/.steam/steam/config
    environment:
      - TZ=Europe/Paris
      - PUID=1000
      - PGID=1000
      - UPDATE_ON_START=true
      - STEAM_USER=
      - STEAM_PASSWORD=
      - Arguments=-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS -NumberOfWorkerThreadsServer=7
      - Difficulty=None
      - DayTimeSpeedRate=1.000000
      - NightTimeSpeedRate=1.000000
      - ExpRate=1.000000
      - PalCaptureRate=1.000000
      - PalSpawnNumRate=1.000000
      - PalDamageRateAttack=1.000000
      - PalDamageRateDefense=1.000000
      - PlayerDamageRateAttack=1.000000
      - PlayerDamageRateDefense=1.000000
      - PlayerStomachDecreaceRate=1.000000
      - PlayerStaminaDecreaceRate=1.000000
      - PlayerAutoHPRegeneRate=1.000000
      - PlayerAutoHpRegeneRateInSleep=1.000000
      - PalStomachDecreaceRate=1.000000
      - PalStaminaDecreaceRate=1.000000
      - PalAutoHPRegeneRate=1.000000
      - PalAutoHpRegeneRateInSleep=1.000000
      - BuildObjectDamageRate=1.000000
      - BuildObjectDeteriorationDamageRate=1.000000
      - CollectionDropRate=1.000000
      - CollectionObjectHpRate=1.000000
      - CollectionObjectRespawnSpeedRate=1.000000
      - EnemyDropItemRate=1.000000
      - DeathPenalty=All
      - bEnablePlayerToPlayerDamage=False
      - bEnableFriendlyFire=False
      - bEnableInvaderEnemy=True
      - bActiveUNKO=False
      - bEnableAimAssistPad=True
      - bEnableAimAssistKeyboard=False
      - DropItemMaxNum=3000
      - DropItemMaxNum_UNKO=100
      - BaseCampMaxNum=128
      - BaseCampWorkerMaxNum=15
      - DropItemAliveMaxHours=1.000000
      - bAutoResetGuildNoOnlinePlayers=False
      - AutoResetGuildTimeNoOnlinePlayers=72.000000
      - GuildPlayerMaxNum=20
      - PalEggDefaultHatchingTime=72.000000
      - WorkSpeedRate=1.000000
      - bIsMultiplay=False
      - bIsPvP=False
      - bCanPickupOtherGuildDeathPenaltyDrop=False
      - bEnableNonLoginPenalty=True
      - bEnableFastTravel=True
      - bIsStartLocationSelectByMap=True
      - bExistPlayerAfterLogout=False
      - bEnableDefenseOtherGuildPlayer=False
      - CoopPlayerMaxNum=4
      - ServerPlayerMaxNum=32
      - ServerName=Mon Serveur Palworld
      - ServerDescription=
      - AdminPassword=
      - ServerPassword=
      - PublicIP=
      - RCONEnabled=False
      - Region=
      - bUseAuth=False
      - BanListURL=
      - RESTAPIEnabled=False
      - bShowPlayerList=False
      - CrossplayPlatforms=(Steam)
      - bIsUseBackupSaveData=True
    ports:
      - "8211:8211/udp"
      - "27015:27015/udp"
      - "8212:8212/udp"
```

```bash
docker compose up -d
docker compose logs -f
```

### Méthode 2 — Build depuis les sources (GitHub)

```bash
git clone https://github.com/ludix0/palworld.git
cd palworld
ln -sf /chemin/vers/votre/secrets.env .env   # ou créer un .env avec les variables ci-dessous
docker build -t ludix0/palworld:latest .
docker compose up -d
```

### Variables d'environnement

| Variable | Obligatoire | Description |
|----------|-------------|--------------|
| `TZ`, `PUID`, `PGID` | Non | Fuseau horaire et utilisateur/groupe hôte pour le conteneur |
| `UPDATE_ON_START` | Non | `true`/`false` — met à jour le serveur via SteamCMD à chaque démarrage du conteneur |
| `STEAM_USER` / `STEAM_PASSWORD` | Non | Laisser vide pour une connexion SteamCMD anonyme (fonctionne pour Palworld) |
| `Arguments` | Non | Options de lancement de `PalServer.sh` — la valeur par défaut active le mode multi-thread performant |
| `Difficulty` | Non | `None` (par défaut, utilise les taux personnalisés ci-dessous), `Casual`, `Normal`, ou `Hard` |
| `DayTimeSpeedRate` / `NightTimeSpeedRate` | Non | Multiplicateurs de vitesse du cycle jour/nuit |
| `ExpRate` | Non | Multiplicateur de gain d'expérience |
| `PalCaptureRate` / `PalSpawnNumRate` | Non | Taux de réussite de capture des Pals et densité d'apparition |
| `PalDamageRateAttack` / `PalDamageRateDefense` | Non | Dégâts infligés/reçus par les Pals |
| `PlayerDamageRateAttack` / `PlayerDamageRateDefense` | Non | Dégâts infligés/reçus par les joueurs |
| `PlayerStomachDecreaceRate` / `PlayerStaminaDecreaceRate` | Non | Vitesse de baisse de la faim/endurance du joueur |
| `PlayerAutoHPRegeneRate` / `PlayerAutoHpRegeneRateInSleep` | Non | Vitesse de régénération des PV du joueur, éveillé / endormi |
| `PalStomachDecreaceRate` / `PalStaminaDecreaceRate` | Non | Vitesse de baisse de la faim/endurance des Pals |
| `PalAutoHPRegeneRate` / `PalAutoHpRegeneRateInSleep` | Non | Vitesse de régénération des PV des Pals, éveillé / endormi |
| `BuildObjectDamageRate` / `BuildObjectDeteriorationDamageRate` | Non | Dégâts subis et vitesse de dégradation des constructions |
| `CollectionDropRate` / `CollectionObjectHpRate` / `CollectionObjectRespawnSpeedRate` | Non | Quantité de ressources récoltées, PV et vitesse de réapparition des nœuds de collecte |
| `EnemyDropItemRate` | Non | Taux de drop d'objets des ennemis vaincus |
| `DeathPenalty` | Non | Ce que le joueur perd à sa mort : `None`, `Item`, `ItemAndEquipment`, ou `All` |
| `bEnablePlayerToPlayerDamage` / `bEnableFriendlyFire` / `bEnableInvaderEnemy` | Non | Dégâts entre joueurs, tir ami, et événements d'invasion hostile de Pals |
| `bActiveUNKO` | Non | Active l'objet "UNKO" (crottes) du jeu |
| `bEnableAimAssistPad` / `bEnableAimAssistKeyboard` | Non | Assistance à la visée pour manette / clavier+souris |
| `DropItemMaxNum` / `DropItemMaxNum_UNKO` | Non | Nombre max d'objets au sol (normaux / UNKO) |
| `BaseCampMaxNum` / `BaseCampWorkerMaxNum` | Non | Nombre max de bases, et nombre max de Pals ouvriers par base |
| `DropItemAliveMaxHours` | Non | Nombre d'heures avant disparition des objets au sol |
| `bAutoResetGuildNoOnlinePlayers` / `AutoResetGuildTimeNoOnlinePlayers` | Non | Dissolution automatique des guildes sans membre en ligne après N heures |
| `GuildPlayerMaxNum` | Non | Nombre max de joueurs par guilde |
| `PalEggDefaultHatchingTime` | Non | Temps d'éclosion des œufs, en heures |
| `WorkSpeedRate` | Non | Multiplicateur de vitesse de travail des Pals |
| `bIsMultiplay` | Non | Drapeau interne lié au multijoueur — laisser la valeur par défaut sauf besoin spécifique |
| `bIsPvP` | Non | Active le PvP sur tout le serveur |
| `bCanPickupOtherGuildDeathPenaltyDrop` | Non | Autorise à ramasser les objets perdus à la mort par une autre guilde |
| `bEnableNonLoginPenalty` | Non | Applique une pénalité aux joueurs restant déconnectés trop longtemps |
| `bEnableFastTravel` | Non | Active le voyage rapide |
| `bIsStartLocationSelectByMap` | Non | Permet aux nouveaux joueurs de choisir leur point d'apparition sur la carte |
| `bExistPlayerAfterLogout` | Non | Garde le personnage du joueur dans le monde après déconnexion au lieu de le faire disparaître |
| `bEnableDefenseOtherGuildPlayer` | Non | Autorise les défenses de base à blesser les joueurs d'autres guildes |
| `CoopPlayerMaxNum` | Non | Nombre max de joueurs par groupe coopératif |
| `ServerPlayerMaxNum` | Non | Nombre max total de joueurs sur le serveur |
| `ServerName` / `ServerDescription` | Non | Nom et description affichés dans la liste des serveurs |
| `AdminPassword` | Non (recommandé) | Mot de passe admin pour les commandes admin en jeu — à définir pour un serveur en production |
| `ServerPassword` | Non | Mot de passe de connexion — laisser vide pour un serveur public |
| `PublicIP` | Non | IP publique annoncée par le serveur — généralement laisser vide (détection automatique) |
| `RCONEnabled` / `Region` | Non | Active le RCON (port interne fixe `25575`, non publié par cette image) et définit une zone géographique |
| `bUseAuth` | Non | Exige l'authentification Steam pour les joueurs qui se connectent |
| `BanListURL` | Non | URL vers une liste de bannissement externe |
| `RESTAPIEnabled` | Non | Active l'API REST (port `8212`) |
| `bShowPlayerList` | Non | Expose la liste des joueurs en ligne via l'API REST |
| `CrossplayPlatforms` | Non | Plateformes crossplay autorisées, ex : `(Steam)` |
| `bIsUseBackupSaveData` | Non | Active les sauvegardes automatiques des données |

### Volumes

| Volume | Contenu |
|--------|---------|
| `/server` | Installation complète du serveur : binaires (via SteamCMD) ainsi que les sauvegardes du monde et la config sous `Pal/Saved` |
| `/home/jeux/.steam/steam/steamcmd` | Installation SteamCMD partagée, évite un nouveau téléchargement à chaque rebuild |
| `/home/jeux/.steam/steam/config` | Cache de connexion/config SteamCMD |

### Ports

| Port | Protocole | Usage |
|------|-----------|-------|
| 8211 | UDP | Trafic de jeu — doit être accessible par les joueurs |
| 27015 | UDP | Requête liste de serveurs Steam — optionnel, exposé par l'image mais pas indispensable pour un serveur privé |
| 8212 | UDP | API REST — nécessaire uniquement si `RESTAPIEnabled=True` |
