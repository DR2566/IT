#!/bin/bash

DATA_DIR="./data"
BACK_DIR="./backup"

FORCE=0

#------------------ BASE UTILITIES ------------------
error_exit() {
    echo "$1" >&2
    exit 1;
}

log_operation() {
    # Získání aktuálního data a času v požadovaném formátu
    timestamp=$(date +"%Y-%m-%d %H:%M.%S")

    # Získání PID skriptu
    pid=$$

    # Získání přihlašovacího jména
    login="$LOGNAME"
    if [[ $login == "" ]]; then
        login="x"
    fi

    # Zjištění způsobu spuštění skriptu (script name)
    script_name=$(realpath "$0")

    # Získání všech argumentů skriptu včetně voleb
    args="$@"

    ls "$DATA_DIR" 2>/dev/null >/dev/null
    if [[ $? != 0 ]]; then
        mkdir $DATA_DIR
    fi
    echo "$timestamp $pid $login $script_name $args" >> "${DATA_DIR}/log"
}

check_params_count() {
    if [[ $1 > $2 ]]; then
        error_exit "too much parameters"
    fi
}

#------------------ FACULTIES UTILITIES ------------------

fac_check_file() {
    ls "${DATA_DIR}/fak" 2>/dev/null >/dev/null
    if [[ $? != 0 ]]; then
        touch "${DATA_DIR}/fak"
    fi
}

fac_CREATE() {
    id="$1"
    name="$2"
    # check id

    # check name

    # create entity
    echo
}

fac_READ() {
    echo
}

fac_UPDATE() {
    echo

}

fac_DELETE() {
    fac_check_file

    fac_id="$1"
    sed -i "/${fac_id}/d" ${DATA_DIR}/fak
}

while getopts "d:b:f" opt_name; do 
    case $opt_name in
        'd')
            DATA_DIR="$OPTARG"
            ;;
        'b') 
            BACK_DIR="$OPTARG"
            ;;
        'f')
            FORCE=1
            ;;
        *)
            exit 1;
            ;;
    esac
done

args="$@"
log_operation "$args"

shift $((OPTIND - 1))

if [[ $# == 0 ]]; then
    error_exit 'missing parameter'
fi

args_count=$#

case $1 in  
    #------------------ BASE OPERATION ------------------
    'cesta-adresar'|'cesta-adresář')
        check_params_count $args_count 1
        echo $DATA_DIR
        ;;
    'smaž-adresář'|'smaz-adresar')
        check_params_count $args_count 1

        if [[ $FORCE != 1 ]]; then
            error_exit "-f option required"
        else    
            rm -r "$DATA_DIR"
        fi
        ;;
    'pomoc')
        check_params_count $args_count 1
        echo "help text here"
        ;;
    #------------------ LOGGING ------------------
    'log-výběr'|'log-vyber')
        check_params_count $args_count 2
        regex="$2"
        logs="$(cat "${DATA_DIR}/log" | egrep "$regex")"
        if [[ "$logs" == "" ]]; then
            exit 1
        else
            printf "%s\n" "$logs"
        fi
        ;;
    'log-poslední'|'log-posledni')
        check_params_count $args_count 2
        # get args and check corectness
        logs_count="$2"
        [ $2 -eq $2 ] 2>/dev/null
        if [[ $? == 2 ]]; then
            error_exit "row count is not a number"
        fi

        # get rows
        if [[ "$logs_count" == "" ]]; then
            tail -n 10 "${DATA_DIR}/log" | tac | nl -w 1 -s ' ' 
        else
            tail -n "$logs_count" "${DATA_DIR}/log" | tac
        fi

        ;;
    #------------------ FACULTIES ------------------
    'fakulta-nová'|'fakulta-nova')
        check_params_count $args_count 3
        fac_id="$2"
        fac_name="$3"
        fac_CREATE $fac_id $fac_name
        ;;
    'fakulta-výpis'|'fakulta-vypis')
        check_params_count $args_count 2
        fac_id="$2"
        fac_READ "$fac_id"
        ;;
    'fakulta-název'|'fakulta-nazev')
        check_params_count $args_count 3
        fac_id="$2"
        fac_name="$3"
        fac_UPDATE $fac_id $fac_name
        ;;
    'fakulta-smaž'|'fakulta-smaz')
        check_params_count $args_count 2
        fac_id="$2"
        fac_DELETE "$fac_id"
        ;;
    *)
        echo 'bad command' 1>&2
        exit 1
        ;;
esac

exit 0;