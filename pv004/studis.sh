#!/bin/bash

DATA_DIR="./data"
BACKUP_DIR="./backup"

FORCE=0

#------------------ BASE UTILITIES ------------------
error_exit() {
    echo "$1" >&2
    exit 1;
}

check_params_count() {
    if [[ $1 > $2 ]]; then
        error_exit "too much parameters"
    fi
}

#------------------ LOG UTILITIES ------------------

check_data_dir() {
    if [[ ! -d "$DATA_DIR" ]]; then
        mkdir $DATA_DIR
    fi
}

log_operation() {
    timestamp=$(date +"%Y-%m-%d %H:%M.%S")

    pid=$$

    login="$LOGNAME"

    if [[ $login == "" ]]; then
        login="x"
    fi

    script_name=$(realpath "$0")

    args="$@"

    echo "$timestamp $pid $login $script_name $args" >> "${DATA_DIR}/log"
}


#------------------ FACULTIES UTILITIES ------------------

fac_check_file() {
    ls "${DATA_DIR}/fak" 2>/dev/null >/dev/null
    if [[ $? != 0 ]]; then
        $(touch "${DATA_DIR}/fak")
    fi
}

fac_CREATE() {
    fac_check_file

    id="$1"
    name="$2"
    # check id
    if [[ "${#id}" > 8 ]]; then
        error_exit "max id length is 8"
    fi
    # check name
    if [[ "$name" == "" ]]; then
        error_exit "name is NONE"
    fi
    # check id in file
    cat "${DATA_DIR}/fak" | grep "$id" >/dev/null 2>/dev/null

    if [[ $? != 0 ]]; then
        # create entity
        echo "${id}|${name}" >> "${DATA_DIR}/fak"
    else
        error_exit "faculty id already exists"
    fi

}

fac_READ() {
    fac_check_file
    fac_id="$1"
    # Záhlaví
    printf "%-8s | %s\n" "Fakulta" "Název"
    printf -- "--------------------------\n"

    if [[ "$fac_id" == "" ]]; then
        # Výpis, seřazený podle ID
        sort "${DATA_DIR}/fak" | while IFS='|' read -r id name; do
            printf "%-8s | %s\n" "$id" "$name"
        done
    else
        row=$(cat "${DATA_DIR}/fak" | grep "$fac_id")
        IFS='|' read -r id name <<< "$row"
        printf "%-8s | %s\n" "$id" "$name"
    fi
}

fac_UPDATE() {
    fac_check_file
    id="$1"
    name="$2"

    cat "${DATA_DIR}/fak" | grep "$id" >/dev/null 2>/dev/null
    if [[ "$?" == 0 ]]; then
        fac_DELETE "$id"
        fac_CREATE "$id" "$name"
    else
        error_exit "id does not exist"
    fi
}

fac_DELETE() {
    fac_check_file

    id="$1"

    cat "${DATA_DIR}/fak" | grep "$id" >/dev/null 2>/dev/null
    if [[ "$?" == 0 ]]; then
        sed -i "/^${id}|/d" "${DATA_DIR}/fak"
    else
        error_exit "id does not exist"
    fi
}

#------------------ BACKUPS UTILITIES ------------------
check_backup_dir() {
    if [[ ! -d "$BACKUP_DIR" ]]; then 
        mkdir "$BACKUP_DIR"
    fi
}

while getopts "d:b:f" opt_name; do 
    case $opt_name in
        'd')
            DATA_DIR="$OPTARG"
            ;;
        'b') 
            BACKUP_DIR="$OPTARG"
            ;;
        'f')
            FORCE=1
            ;;
        *)
            exit 1;
            ;;
    esac
done

check_data_dir
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
        fac_CREATE "$fac_id" "$fac_name"
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
        fac_UPDATE "$fac_id" "$fac_name"
        ;;
    'fakulta-smaž'|'fakulta-smaz')
        check_params_count $args_count 2
        fac_id="$2"
        if [[ "$fac_id" == "" ]]; then
            error_exit "id not specified"
        fi
        fac_DELETE "$fac_id"
        ;;
    #------------------ BACKUPS ------------------
    'zálohy'|'zalohy')
        check_params_count $args_count 1
        check_backup_dir
        ls -t "${BACKUP_DIR}"
        ;;
    *)
        echo 'bad command' 1>&2
        exit 1
        ;;
esac

exit 0;