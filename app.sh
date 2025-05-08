#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fungsi menghitung BMI
hitung_bmi() {
    local berat=$1
    local tinggi=$2
    local bmi=$(echo "scale=2; $berat / (($tinggi / 100) * ($tinggi / 100))" | bc)
    echo "$bmi"
}

# Fungsi menentukan kategori berdasarkan BMI
kategori_bmi() {
    local bmi=$1
    if (( $(echo "$bmi < 18.5" | bc -l) )); then
        echo "Kurus"
    elif (( $(echo "$bmi >= 18.5 && $bmi < 25" | bc -l) )); then
        echo "Normal"
    elif (( $(echo "$bmi >= 25 && $bmi < 30" | bc -l) )); then
        echo "Gemuk"
    else
        echo "Obesitas"
    fi
}

# Fungsi validasi input angka
validasi_angka() {
    while true; do
        read -p "$1" angka
        if [[ "$angka" =~ ^[0-9]+([.][0-9]+)?$ && "$angka" != "" && $(echo "$angka > 0" | bc -l) -eq 1 ]]; then
            echo "$angka"
            break
        else
            echo -e "${RED}Input tidak valid. Masukkan angka positif lebih besar dari 0.${NC}"
        fi
    done
}

# Array untuk menyimpan riwayat BMI
declare -a riwayatBMI
declare -a kategoriBMI
declare -a riwayatNama

# Fungsi menampilkan riwayat BMI
tampilkan_riwayat() {
    if [ ${#riwayatBMI[@]} -eq 0 ]; then
        echo -e "${YELLOW}Belum ada riwayat perhitungan.${NC}"
    else
        echo -e "${CYAN}=== Riwayat BMI ===${NC}"
        for i in "${!riwayatBMI[@]}"; do
            echo -e "${YELLOW}${i}. ${NC}Nama: ${CYAN}${riwayatNama[$i]}${NC} | BMI: ${riwayatBMI[$i]} | Kategori: ${kategoriBMI[$i]}"
        done
    fi
}

