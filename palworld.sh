#!/bin/bash
set -e

# --- Ajustement UID/GID de l'utilisateur jeux ---
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

echo "--- Ajustement de l'utilisateur jeux vers UID: $USER_ID et GID: $GROUP_ID ---"
groupmod -g $GROUP_ID jeux
usermod -u $USER_ID -g $GROUP_ID jeux

# --- Correction des permissions du volume ---
echo "--- Ajustement des permissions de /server ---"
chown -R jeux:jeux /server
chown -R jeux:jeux /home/jeux

# --- Mise à jour / installation via SteamCMD ---
if [ "$UPDATE_ON_START" = "true" ] || [ ! -f "/server/PalServer.sh" ]; then
    echo "--- Mise à jour / installation du serveur Palworld (SteamCMD) ---"
    if [ -n "$STEAM_USER" ]; then
        echo "--- Connexion avec le compte Steam: $STEAM_USER ---"
        LOGIN_ARGS=(+login "$STEAM_USER" "$STEAM_PASSWORD")
    else
        LOGIN_ARGS=(+login anonymous)
    fi
    for i in 1 2 3; do
        gosu jeux steamcmd \
            +@sSteamCmdForcePlatformType linux \
            +force_install_dir /server \
            "${LOGIN_ARGS[@]}" \
            +app_update 2394010 validate \
            +quit && break
        echo "--- Tentative $i échouée, nouvel essai dans 10s ---"
        sleep 10
    done
else
    echo "--- Saut de la mise à jour (UPDATE_ON_START=false) ---"
fi

# --- Création des dossiers de configuration ---
echo "--- Création des dossiers de configuration ---"
gosu jeux mkdir -p /server/Pal/Saved/Config/LinuxServer

# --- Écriture du fichier PalWorldSettings.ini ---
echo "--- Écriture du fichier PalWorldSettings.ini ---"
SETTINGS="[/Script/Pal.PalGameWorldSettings]
OptionSettings=(Difficulty=${Difficulty},DayTimeSpeedRate=${DayTimeSpeedRate},NightTimeSpeedRate=${NightTimeSpeedRate},ExpRate=${ExpRate},PalCaptureRate=${PalCaptureRate},PalSpawnNumRate=${PalSpawnNumRate},PalDamageRateAttack=${PalDamageRateAttack},PalDamageRateDefense=${PalDamageRateDefense},PlayerDamageRateAttack=${PlayerDamageRateAttack},PlayerDamageRateDefense=${PlayerDamageRateDefense},PlayerStomachDecreaceRate=${PlayerStomachDecreaceRate},PlayerStaminaDecreaceRate=${PlayerStaminaDecreaceRate},PlayerAutoHPRegeneRate=${PlayerAutoHPRegeneRate},PlayerAutoHpRegeneRateInSleep=${PlayerAutoHpRegeneRateInSleep},PalStomachDecreaceRate=${PalStomachDecreaceRate},PalStaminaDecreaceRate=${PalStaminaDecreaceRate},PalAutoHPRegeneRate=${PalAutoHPRegeneRate},PalAutoHpRegeneRateInSleep=${PalAutoHpRegeneRateInSleep},BuildObjectDamageRate=${BuildObjectDamageRate},BuildObjectDeteriorationDamageRate=${BuildObjectDeteriorationDamageRate},CollectionDropRate=${CollectionDropRate},CollectionObjectHpRate=${CollectionObjectHpRate},CollectionObjectRespawnSpeedRate=${CollectionObjectRespawnSpeedRate},EnemyDropItemRate=${EnemyDropItemRate},DeathPenalty=${DeathPenalty},bEnablePlayerToPlayerDamage=${bEnablePlayerToPlayerDamage},bEnableFriendlyFire=${bEnableFriendlyFire},bEnableInvaderEnemy=${bEnableInvaderEnemy},bActiveUNKO=${bActiveUNKO},bEnableAimAssistPad=${bEnableAimAssistPad},bEnableAimAssistKeyboard=${bEnableAimAssistKeyboard},DropItemMaxNum=${DropItemMaxNum},DropItemMaxNum_UNKO=${DropItemMaxNum_UNKO},BaseCampMaxNum=${BaseCampMaxNum},BaseCampWorkerMaxNum=${BaseCampWorkerMaxNum},DropItemAliveMaxHours=${DropItemAliveMaxHours},bAutoResetGuildNoOnlinePlayers=${bAutoResetGuildNoOnlinePlayers},AutoResetGuildTimeNoOnlinePlayers=${AutoResetGuildTimeNoOnlinePlayers},GuildPlayerMaxNum=${GuildPlayerMaxNum},PalEggDefaultHatchingTime=${PalEggDefaultHatchingTime},WorkSpeedRate=${WorkSpeedRate},bIsMultiplay=${bIsMultiplay},bIsPvP=${bIsPvP},bCanPickupOtherGuildDeathPenaltyDrop=${bCanPickupOtherGuildDeathPenaltyDrop},bEnableNonLoginPenalty=${bEnableNonLoginPenalty},bEnableFastTravel=${bEnableFastTravel},bIsStartLocationSelectByMap=${bIsStartLocationSelectByMap},bExistPlayerAfterLogout=${bExistPlayerAfterLogout},bEnableDefenseOtherGuildPlayer=${bEnableDefenseOtherGuildPlayer},CoopPlayerMaxNum=${CoopPlayerMaxNum},ServerPlayerMaxNum=${ServerPlayerMaxNum},ServerName=${ServerName},ServerDescription=${ServerDescription},AdminPassword=${AdminPassword},ServerPassword=${ServerPassword},PublicPort=8211,PublicIP=${PublicIP},RCONEnabled=${RCONEnabled},RCONPort=25575,Region=${Region},bUseAuth=${bUseAuth},BanListURL=${BanListURL},RESTAPIEnabled=${RESTAPIEnabled},RESTAPIPort=8212,bShowPlayerList=${bShowPlayerList},CrossplayPlatforms=${CrossplayPlatforms},bIsUseBackupSaveData=${bIsUseBackupSaveData},LogFormatType=Text)"

echo "$SETTINGS" | gosu jeux tee /server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini > /dev/null

# --- Démarrage du serveur en tant que jeux ---
echo "--- Démarrage du serveur Palworld ---"
exec gosu jeux /server/PalServer.sh ${Arguments}
