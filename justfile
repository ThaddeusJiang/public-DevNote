# 启动 TiddlyWiki 服务器
start:
    #!/usr/bin/env sh
    npx tiddlywiki --listen port=8090 username=TJ &
    SERVER_PID=$!
    sleep 2
    open -a Safari http://localhost:8090
    wait $SERVER_PID

# 停止 TiddlyWiki 服务器
stop:
    #!/usr/bin/env sh
    echo stop tiddlywiki
    PID=$(lsof -ti:8090)
    if [ -n "$PID" ]; then
        kill -9 $PID 2>/dev/null
    fi

# Git 提交并推送
push:
    #!/usr/bin/env sh
    git add .
    git commit -m "$(date +%Y-%m-%d)"
    git push
