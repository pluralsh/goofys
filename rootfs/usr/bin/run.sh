#!/bin/bash

[[ "$UID" -ne "0" ]] && MOUNT_ACCESS="allow_other" || MOUNT_ACCESS="nonempty"

goofys -f ${ENDPOINT:+--endpoint $ENDPOINT} ${REGION:+--region $REGION} $EXTRA_OPTS --stat-cache-ttl $STAT_CACHE_TTL --type-cache-ttl $TYPE_CACHE_TTL --dir-mode $DIR_MODE --file-mode $FILE_MODE --uid $UID --gid $GID -o $MOUNT_ACCESS $BUCKET $MOUNT_DIR
