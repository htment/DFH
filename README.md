Чтобы настроить socat для работы с выводом команды df -h и обеспечить его автоматический запуск после перезагрузки сервера, вы можете создать системный сервис. Ниже приведены шаги для выполнения этой задачи.

▎Шаг 1: Создайте скрипт для socat

Создайте скрипт, который будет запускать socat и обслуживать файл с данными. Например, создайте файл /usr/local/bin/disk_usage_server.sh:

Bash


sudo nano /usr/local/bin/disk_usage_server.sh


Добавьте в него следующий код:

Bash


#!/bin/bash

# Путь к файлу, в который будет сохраняться результат df -h
OUTPUT_FILE="/home/art/DISKUSE/DFH"

# Запускаем бесконечный цикл для обновления файла
while true; do
    df -h > "$OUTPUT_FILE"
    sleep 60
done &
# Используем socat для раздачи файла через TCP
socat TCP-LISTEN:5229,fork FILE:"$OUTPUT_FILE"


Сохраните файл и закройте редактор. Затем сделайте скрипт исполняемым:

Bash


sudo chmod +x /usr/local/bin/disk_usage_server.sh


▎Шаг 2: Создайте systemd-сервис

Теперь создайте файл службы systemd для автоматического запуска вашего скрипта при загрузке. Создайте файл /etc/systemd/system/disk_usage.service:

Bash


sudo nano /etc/systemd/system/disk_usage.service


Добавьте в него следующий код:

Ini


[Unit]
Description=Disk Usage Server

[Service]
ExecStart=/usr/local/bin/disk_usage_server.sh
Restart=always

[Install]
WantedBy=multi-user.target


Сохраните файл и закройте редактор.

▎Шаг 3: Включите и запустите сервис

Теперь вы можете включить и запустить ваш сервис:

Bash


# Перезагрузите конфигурацию systemd
sudo systemctl daemon-reload

# Включите сервис, чтобы он запускался при загрузке
sudo systemctl enable disk_usage.service

# Запустите сервис
sudo systemctl start disk_usage.service


▎Шаг 4: Проверка статуса сервиса

Вы можете проверить статус вашего сервиса, чтобы убедиться, что он работает:

Bash


sudo systemctl status disk_usage.service


▎Шаг 5: Доступ к файлу через socat

Теперь вы можете получить доступ к вашему файлу через socat, используя следующий адрес:

copy


http://<ваш_сервер>:5229/DFH


Замените <ваш_сервер> на IP-адрес или имя вашего сервера.

▎Примечание

• Убедитесь, что у вас установлены необходимые права доступа к файлу и директории.

• Если ваш сервер использует брандмауэр (например, ufw), убедитесь, что порт 5229 открыт:

Bash


sudo ufw allow 5229


Теперь ваш socat будет работать и после перезагрузки сервера. Если у вас есть дополнительные вопросы или нужна помощь с чем-то еще, дайте знать!
