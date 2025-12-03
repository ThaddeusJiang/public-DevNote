
_ensure-tiddlywiki:
    #!/usr/bin/env sh
    if ! command -v tiddlywiki >/dev/null 2>&1; then
        mise use -g npm:tiddlywiki
    fi

# start tiddlywiki server
start: _ensure-tiddlywiki
    #!/usr/bin/env sh
    tiddlywiki --listen port=8090 username=TJ &
    SERVER_PID=$!
    sleep 2
    open -a Safari http://localhost:8090
    wait $SERVER_PID

# stop tiddlywiki server
stop:
    #!/usr/bin/env sh
    echo stop tiddlywiki
    PID=$(lsof -ti:8090)
    if [ -n "$PID" ]; then
        kill -9 $PID 2>/dev/null
    fi

# git commit and push
push:
    #!/usr/bin/env sh
    git add .
    git commit -m "$(date +%Y-%m-%d)"
    git push
