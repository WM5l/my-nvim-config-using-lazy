#!/bin/bash

# Obtener la información de la batería usando acpi
BATTERY_INFO=$(acpi -b)

# Comprobar si acpi devuelve una línea válida
if [[ $BATTERY_INFO =~ Battery\ [0-9]+:\ ([A-Za-z]+),\ ([0-9]+)% ]]; then
    BATTERY_STATE="${BASH_REMATCH[1]}"
    BATTERY_PERCENT="${BASH_REMATCH[2]}"

    # Definir los símbolos y colores
    if [[ "$BATTERY_STATE" == "Discharging" ]]; then
        if [[ "$BATTERY_PERCENT" -lt 20 ]]; then
            echo "🔋 %{F#FF0000}$BATTERY_PERCENT%"
        else
            echo "🟩 %{F#00FF00}$BATTERY_PERCENT%"
        fi
    elif [[ "$BATTERY_STATE" == "Charging" ]]; then
        echo "⚡ %{F#FFFF00}$BATTERY_PERCENT% (Charging)"
    else
        echo "⚡ %{F#FFFF00}Unknown"
    fi
else
    # En caso de que acpi no dé la salida esperada
    echo "⚡ %{F#FF0000}Error"
fi

