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

# Fungsi utama
menu() {
    while true; do
        echo -e "\n${GREEN}=== KALKULATOR BMI ===${NC}"
        echo -e "${YELLOW}1${NC}. ${CYAN}Hitung BMI${NC}"
        echo -e "${YELLOW}2${NC}. ${CYAN}Lihat Riwayat${NC}"
        echo -e "${YELLOW}3${NC}. ${CYAN}Hapus Riwayat${NC}"
        echo -e "${YELLOW}4${NC}. ${CYAN}Keluar${NC}"
        read -p "Pilih menu: " pilihan

        case $pilihan in
            1)
                # Input nama setiap perhitungan
                while true; do
                    read -p "Masukkan nama Anda: " nama_input
                    if [[ -n "$nama_input" ]]; then
                        break
                    else
                        echo -e "${RED}Nama tidak boleh kosong.${NC}"
                    fi
                done

                berat=$(validasi_angka "Masukkan berat badan (kg): ")
                tinggi=$(validasi_angka "Masukkan tinggi badan (cm): ")

                bmi=$(hitung_bmi "$berat" "$tinggi")
                kategori=$(kategori_bmi "$bmi")

                echo -e "${CYAN}Hasil BMI: $bmi${NC}"
                echo -e "Kategori: ${YELLOW}$kategori${NC}"

                # Simpan ke array
                riwayatBMI+=("$bmi")
                kategoriBMI+=("$kategori")
                riwayatNama+=("$nama_input")
                ;;
            2)
                tampilkan_riwayat
                ;;
            3)
                riwayatBMI=()
                kategoriBMI=()
                riwayatNama=()
                echo -e "${YELLOW}Riwayat berhasil dihapus.${NC}"
                ;;
            4)
                echo -e "${GREEN}Terima kasih! ${NC}"
                break
                ;;
            *)
                echo -e "${RED}Pilihan tidak valid. Coba lagi.${NC}"
                ;;
        esac
    done
}

# Jalankan program
 menu
