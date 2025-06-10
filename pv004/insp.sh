xrocek@aisa:~/pv004lab$ cat inspiration.sh 
#!/bin/bash

# Výchozí adresáře
DATADIR="/home/xrocek/pv004lab/studis_data"
BACKUPDIR="/home/xrocek/pv004lab/studis_backup"
FORCE=0

# Zpracování voleb
while getopts ":d:b:f" opt; do
  case "$opt" in
    d) DATADIR="$OPTARG" ;;
    b) BACKUPDIR="$OPTARG" ;;
    f) FORCE=1 ;;
    *) echo "Neznámá volba: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# Kontrola, že je zadána operace
if [ $# -lt 1 ]; then
  echo "Nebyla zadána operace." >&2
  exit 1
fi

OPERATION="$1"
shift

# Kontrola a vytvoření adresářů
if ! mkdir -p "$DATADIR" 2>/dev/null || [ ! -w "$DATADIR" ]; then
  echo "Nelze vytvořit nebo zapisovat do datového adresáře: $DATADIR" >&2
  exit 1
fi

if ! mkdir -p "$BACKUPDIR" 2>/dev/null || [ ! -w "$BACKUPDIR" ]; then
  echo "Nelze vytvořit nebo zapisovat do zálohovacího adresáře: $BACKUPDIR" >&2
  exit 1
fi

# Logování
NOW=$(date '+%Y-%m-%d %H:%M.%S')
PID=$$
LOGIN="${LOGNAME:-x}"
CMD="$0 $*"
echo "$NOW $PID $LOGIN $CMD" >> "$DATADIR/log"

case "$OPERATION" in
  pomoc)
    echo "Nápověda ke skriptu STUDIS"
    echo "Dostupné operace: pomoc, cesta-adresář, smaž-adresář, log-výběr, log-poslední"
    exit 0
    ;;

  cesta-adresář|cesta-adresar)
    echo "$DATADIR"
    exit 0
    ;;

  smaž-adresář|smaz-adresar)
    if [ "$FORCE" -ne 1 ]; then
      echo "Chybí volba -f pro potvrzení mazání." >&2
      exit 1
    fi
    rm -rf "$DATADIR"
    exit 0
    ;;

  log-výběr|log-vyber)
    if [ ! -s "$DATADIR/log" ]; then
      echo "Log neexistuje nebo je prázdný." >&2
      exit 1
    fi
    PATTERN="$1"
    if grep -E "$PATTERN" "$DATADIR/log"; then
      exit 0
    else
      exit 1
    fi
    ;;

  log-poslední|log-posledni)
    if [ ! -s "$DATADIR/log" ]; then
      echo "Log neexistuje nebo je prázdný." >&2
      exit 1
    fi
    if [ $# -eq 0 ]; then
      tac "$DATADIR/log" | head -n 10 | nl -w1 -s" " 
    else
      if [[ "$1" =~ ^[0-9]+$ ]]; then
        tail -n "$1" "$DATADIR/log"
      else
        echo "Neplatný počet řádků: $1" >&2
        exit 1
      fi
    fi
    exit 0
    ;;

  *)
    echo "Neznámá operace: $OPERATION" >&2
    exit 1
    ;;
esac