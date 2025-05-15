# Решение для мониторинга процесса `test` в Linux


## Описание
Скрипт и systemd-юнит для мониторинга процесса `test` с выполнением требований:
- Запуск при старте системы
- Проверка каждую минуту
- Отправка HTTPS-запроса, если процесс активен
- Логирование перезапусков и недоступности сервера мониторинга


## Компоненты
1. **Скрипт мониторинга**: `/usr/local/bin/monitor_test.sh`
2. **Systemd-юниты**:
   - Сервис: `/etc/systemd/system/monitor-test.service`
   - Таймер: `/etc/systemd/system/monitor-test.timer`
3. **Лог-файл**: `/var/log/monitoring.log`


## Установка
```bash
# Разместите скрипт и юниты в указанных путях
sudo chmod +x /usr/local/bin/monitor_test.sh
sudo systemctl daemon-reload
sudo systemctl enable --now monitor-test.timer