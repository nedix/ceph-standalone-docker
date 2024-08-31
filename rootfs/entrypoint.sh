#!/usr/bin/env sh

: ${STARTUP_TIMEOUT}

# -------------------------------------------------------------------------------
#    Create executables
# -------------------------------------------------------------------------------
for BIN in /etc/s6-overlay/s6-rc.d/*/bin/*.sh; do
    ENVIRONMENT=$(echo "$BIN" | sed "s|/etc/s6-overlay/s6-rc\.d/\(.*\)/bin/.*\.sh|/run/\1/environment|")
    SCRIPT=$(echo "$BIN" | sed "s|\(/etc/s6-overlay/s6-rc\.d/.*/\)bin/\(.*\)\.sh|\1\2|")
    SERVICE=$(echo "$BIN" | sed "s|/etc/s6-overlay/s6-rc\.d/\(.*\)/bin/.*\.sh|\1|")

    if [ -f "$SCRIPT" ]; then
        continue
    fi

    if [ -d "$ENVIRONMENT" ]; then
cat << EOF > "$SCRIPT"
#!/usr/bin/execlineb -P
exec s6-envdir "$ENVIRONMENT" "$BIN"
EOF
    else
cat << EOF > "$SCRIPT"
#!/usr/bin/execlineb -P
exec "$BIN"
EOF
    fi
done

# -------------------------------------------------------------------------------
#    Let's go!
# -------------------------------------------------------------------------------
exec env -i \
    PATH="/opt/ceph-standalone/bin:${PATH}" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME="$(( "$STARTUP_TIMEOUT" * 1000 ))" \
    /init
