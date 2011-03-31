#!/bin/bash

# AUTOR: Vicenç Juan Tomàs Montserrat
# LLICENCIA: GPL-3
# VERSIO: 0.1

##### COMPROVACIONS #####

# Comprovam que ens passen com a parametre un únic arxiu de log
# i que efectivament, es de tipus fitxer.
if [ $# -eq 0 -o ! -f "$1" ]; then
    echo "Ús: `basename $0` fitxer_log" >&2
    exit 1
fi

##### VARIABLES #####

# fitxer passat per paràmetre
FITXER=$1

##### FUNCIONS #####

function punt1 {
    echo
    awk '{ total[$7]=$10 } END { for (v in total) print "El tamany total del fitxer " v " és: " total[v], "bytes" }' $FITXER
}

function punt2 {
    echo
    awk '{ total[$7]+=$10 } END { for (v in total) print "El tràfic total del fitxer " v " és: " total[v], "bytes" }' $FITXER
}

function punt3 {
    echo
    awk '{ total[$1]+=$10 } END { for (v in total) print "El tràfic total de la IP " v " és: " total[v], "bytes" }' $FITXER
}

function punt4 {
    echo
    awk '{ total[$4]+=$10 } END { for (v in total) print  v":"total[v] }' $FITXER | awk -F: '{ total[$1]+=$5 } END { for (v in total) print v,total[v] }' | awk 'BEGIN {max=0 } { if($2>max) {dia=$1; max=$2};} END { print "El dia amb més trafic és: "dia" ->",max" bytes " }'
}

function punt5 {
    echo
    awk '{print $4,$10}' $FITXER | awk -F: '{print $2,$4}' | awk '{print $1,$3}' | awk '{ total[$1]+=$2 } END { for (v in total) print v,total[v] }' | awk 'BEGIN {max=0 } { if($2>max) {hora=$1; max=$2};} END { print "La hora amb més trafic és: "hora"h ->", max" bytes " }'
}

function punt6 {
    echo
    #awk -F: '{ total[$1]+=$4 } END { for (v in total) print v }' | awk '{ ip[$1]++; } END { for (var in ip) print var,ip[var] }' | awk 'BEGIN { max=0 } { if($3>max) {ip=$1; accesos=$3}; } END { print "El dia amb més visitants (per IP única) és: "ip "->",accesos " accesos" }' $FITXER

    $9==200 && $10>0 {dia_ips[substr($4,2,11),$1]+= 0}

    for (clave in dia_ips) {
        split(clave, llista_aux, "\034")
        llista[llista_aux[1]] += 1
    }

    for (c in llista) {
        if (max_ips < llista[c]) {
            max_ips = llista[c]
            dia_vis = c
        }
    }
}

function punt7 {
    echo
    awk '{print $9}' $FITXER | awk 'BEGIN {count=0} { if($1==404) {count+=1} } END { print "Nombre de 404: "count }'
    #echo "Nombre de 404: `cat $FITXER | awk '{print $9}' | grep 404 | wc -l`" # alternativa
}

function menu() {
    echo
    echo "Menú interactiu"
    echo
    echo "1) Tamany de cada fitxer"
    echo "2) Tràfic total per cada fitxer"
    echo "3) Tràfic total per a cada direcció IP analitzada"
    echo "4) El día amb més tràfic (en bytes servits)"
    echo "5) L'hora amb més tràfic (en bytes servits)"
    echo "6) El día amb més visitants (IP diferents)"
    echo "7) Fitxers sol·licitats no existents (codi 404)"
    echo "Q) Sortir"
}

##### INICI DEL PROGRAMA  #####

while true
do
    menu;
    echo
    echo -n "Opció: "
    read OP;
    case $OP in
        1) punt1;;
        2) punt2;;
        3) punt3;;
        4) punt4;;
        5) punt5;;
        6) punt6;;
        7) punt7;;
        q|Q) exit 0;;
        *) clear; echo "Opció no vàlida!"
    esac
done
