#!/bin/bash

# AUTOR: Xisco Seguí Belman
# AUTOR: Vicenç Juan Tomàs Montserrat
# LLICENCIA: GPL-3
# VERSIO: 0.1

##### VARIABLES #####

# fitxer passat per paràmetre
FITXER=$1

##### COMPROVACIONS #####

# Comprovam que ens passen com a parametre un únic arxiu de log
# i que efectivament, es de tipus fitxer.
if [ $# -eq 0 -o ! -f "$1" ]; then
    echo "Ús: `basename $0` fitxer_log" >&2
    exit 1
fi

##### FUNCIONS #####

function punt1 {
    echo "Punt 1"
    echo
    awk '{
            total[$7]=$10
        } END {
            for (v in total)
                print "El trafic total del fitxer "v" es: "total[v]
        }' $FITXER
}

function punt2 {
    echo "Punt 2"
    echo
    awk '{
            total[$7]+=$10
        } END {
            for (v in total)
                print "El trafic total del fitxer "v" es: "total[v]
        }' $FITXER
}

function punt3 {
    echo "Punt 3"
    echo
    awk '{
            total[$1]+=$10
        } END {
            for (v in total)
                print "El trafic total de la IP "v" es: "total[v]
        }' $FITXER
}

function punt4 {
    echo "Punt 4"
    echo
}

function punt5 {
    echo "Punt 5"
    echo
}

function punt6 {
    echo "Punt 6"
    echo
}

function punt7 {
    echo "Punt 7"
    echo
    echo "Nombre de 404: `cat $FITXER | awk '{print $9}' | grep 404 | wc -l`" # lent
}

function menu() {
    echo
    echo "Menú d'administració"
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

while (true)
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
        q|Q) exit;;
        *) clear; echo "Opció no vàlida!"
    esac
done
