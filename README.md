Чтобы настроить socat для работы с выводом команды df -h и обеспечить его автоматический запуск после перезагрузки сервера, вы можете создать системный сервис. Ниже приведены шаги для выполнения этой задачи.

▎Шаг 1: Создайте скрипт для socat

Создайте скрипт, который будет запускать socat и обслуживать файл с данными. Например, создайте файл /usr/local/bin/disk_usage_server.sh:

``
sudo nano /usr/local/bin/disk_usage_server.sh
``

Добавьте в него следующий код:

```
#!/bin/bash

# Путь к файлу, в который будет сохраняться результат
OUTPUT_FILE="/home/art/DISKUSE/DFH"

# Используем socat для раздачи файла через TCP с обработкой HTTP
socat -v TCP-LISTEN:5229,fork SYSTEM:"(echo -ne 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n'; cat $OUTPUT_FILE)"

# Бесконечный цикл
while true; do
    # Выполняем команду df -h и сохраняем результат в файл
    df -h > "$OUTPUT_FILE"
    # Ждем 60 секунд
    sleep 60
done


```
Сохраните файл и закройте редактор. Затем сделайте скрипт исполняемым:

``
sudo chmod +x /usr/local/bin/disk_usage_server.sh
``

▎Шаг 2: Создайте systemd-сервис

Теперь создайте файл службы systemd для автоматического запуска вашего скрипта при загрузке. Создайте файл /etc/systemd/system/disk_usage.service:

``
sudo nano /etc/systemd/system/disk_usage.service
``

Добавьте в него следующий код:
```

[Unit]
Description=Disk Usage Server

[Service]
ExecStart=/usr/local/bin/disk_usage_server.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

Сохраните файл и закройте редактор.

▎Шаг 3: Включите и запустите сервис

Теперь вы можете включить и запустить ваш сервис:

```
# Перезагрузите конфигурацию systemd
sudo systemctl daemon-reload

# Включите сервис, чтобы он запускался при загрузке
sudo systemctl enable disk_usage.service

# Запустите сервис
sudo systemctl start disk_usage.service

```
▎Шаг 4: Проверка статуса сервиса

Вы можете проверить статус вашего сервиса, чтобы убедиться, что он работает:

``
sudo systemctl status disk_usage.service
``


``
sudo systemctl daemon-reload
sudo systemctl restart disk_usage.service
``


▎Шаг 5: Доступ к файлу через socat

Теперь вы можете получить доступ к вашему файлу через socat, используя следующий адрес:

``
http://<ваш_сервер>:5229/DFH
``

Замените <ваш_сервер> на IP-адрес или имя вашего сервера.

▎Примечание

• Убедитесь, что у вас установлены необходимые права доступа к файлу и директории.

• Если ваш сервер использует брандмауэр (например, ufw), убедитесь, что порт 5229 открыт:

``
sudo ufw allow 5229
``

Теперь ваш socat будет работать и после перезагрузки сервера. 

1. Проверка занятых портов:
   Вы можете использовать команду netstat или ss, чтобы определить, какой процесс использует порт 5229:
   
```
   sudo netstat -tuln | grep 5229
   sudo ss -tuln | grep 5229

   sudo lsof -i :5229
```
5. Тестирование без службы:
   Чтобы упростить отладку, вы можете временно запустить socat вручную в терминале, чтобы проверить его работу без использования службы:
   
```

   socat -v TCP-LISTEN:5229,fork SYSTEM:"(echo -ne 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n'; cat /home/art/DISKUSE/DFH)"
```

