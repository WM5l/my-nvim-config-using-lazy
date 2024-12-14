#!/bin/bash

# Obtener el porcentaje de batería
battery_percentage=$(acpi -b | grep -P -o '[0-9]+(?=%)')

# Obtener el estado de la batería (Charging/Discharging/Full)
battery_status=$(acpi -b | grep -o 'Charging\|Discharging\|Full')

# Establecer el color basado en el estado de la batería y el porcentaje
if [ "$battery_status" == "Charging" ]; then
    color="#00FF00" # Verde 
elif [ "$battery_percentage" -le 25 ]; then
    color="#FF0000" # Rojo
elif [ "$battery_status" == "Full" ] || [ "$battery_status" == "Discharging" ]; then
    color="#005EFF" # Azul
fi

# Establecer un icono basado en el porcentaje de batería
if [ "$battery_percentage" -ge 80 ]; then
    icon=""
elif [ "$battery_percentage" -ge 60 ]; then
    icon=""
elif [ "$battery_percentage" -ge 40 ]; then
    icon=""
elif [ "$battery_percentage" -ge 20 ]; then
    icon=""
else
    icon=""
fi

# Mostrar el icono, el porcentaje de batería y el estado con el color especificado
echo "<span color='$color'>$icon $battery_percentage% ($battery_status)</span>"

