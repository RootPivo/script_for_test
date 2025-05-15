#!/bin/bash

# Лог-файл
LOG_FILE="/var/log/monitoring.log"

# URL для проверки
MONITORING_URL="https://test.com/monitoring/test/api"

# Имя процесса для мониторинга
PROCESS_NAME="test"

# Функция для записи в лог
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Проверяем, запущен ли процесс
if pgrep -x "$PROCESS_NAME" >/dev/null; then
    # Процесс запущен, проверяем доступность сервера мониторинга
    if curl -s -I "$MONITORING_URL" --max-time 5 | grep -q "HTTP/.* 200"; then
        # Сервер доступен, ничего не делаем
        :
    else
        # Сервер недоступен
        log_message "Monitoring server $MONITORING_URL is not available"
    fi
    
    # Проверяем, был ли процесс перезапущен (сравниваем текущий PID с сохранённым)
    CURRENT_PID=$(pgrep -x "$PROCESS_NAME")
    LAST_PID_FILE="/tmp/last_test_pid"
    
    if [ -f "$LAST_PID_FILE" ]; then
        LAST_PID=$(cat "$LAST_PID_FILE")
        if [ "$CURRENT_PID" != "$LAST_PID" ]; then
            log_message "Process $PROCESS_NAME was restarted (old PID: $LAST_PID, new PID: $CURRENT_PID)"
        fi
    fi
    
    # Сохраняем текущий PID
    echo "$CURRENT_PID" > "$LAST_PID_FILE"
fi