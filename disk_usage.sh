#!/bin/bash 

# Путь к файлу, в который будет сохраняться результат
OUTPUT_FILE="/home/art/DISKUSE/DFH"
# Используем socat для раздачи файла через TCP
#socat TCP-LISTEN:5229,fork FILE:"$OUTPUT_FILE"


# Используем socat для раздачи файла через TCP с обработкой HTTP
socat -v TCP-LISTEN:5229,fork SYSTEM:"(echo -ne 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n'; cat $OUTPUT_FILE)" &


# Бесконечный цикл
while true; do
    # Выполняем команду df -h и сохраняем результат в файл
    df -h > "$OUTPUT_FILE"
    # Ждем 60 секунд
    sleep 60
done

