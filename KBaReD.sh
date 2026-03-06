#!/bin/bash
#@texta84

clear

echo -e "
KKKKKKKKK    KKKKKKKBBBBBBBBBBBBBBBBB                     RRRRRRRRRRRRRRRRR                     DDDDDDDDDDDDD
K:::::::K    K:::::KB::::::::::::::::B                    R::::::::::::::::R                    D::::::::::::DDD
K:::::::K    K:::::KB::::::BBBBBB:::::B                   R::::::RRRRRR:::::R                   D:::::::::::::::DD
K:::::::K   K::::::KBB:::::B     B:::::B                  RR:::::R     R:::::R                  DDD:::::DDDDD:::::D
KK::::::K  K:::::KKK  B::::B     B:::::B  aaaaaaaaaaaaa     R::::R     R:::::R    eeeeeeeeeeee    D:::::D    D:::::D
  K:::::K K:::::K     B::::B     B:::::B  a::::::::::::a    R::::R     R:::::R  ee::::::::::::ee  D:::::D     D:::::D
  K::::::K:::::K      B::::BBBBBB:::::B   aaaaaaaaa:::::a   R::::RRRRRR:::::R  e::::::eeeee:::::eeD:::::D     D:::::D
  K:::::::::::K       B:::::::::::::BB             a::::a   R:::::::::::::RR  e::::::e     e:::::eD:::::D     D:::::D
  K:::::::::::K       B::::BBBBBB:::::B     aaaaaaa:::::a   R::::RRRRRR:::::R e:::::::eeeee::::::eD:::::D     D:::::D
  K::::::K:::::K      B::::B     B:::::B  aa::::::::::::a   R::::R     R:::::Re:::::::::::::::::e D:::::D     D:::::D
  K:::::K K:::::K     B::::B     B:::::B a::::aaaa::::::a   R::::R     R:::::Re::::::eeeeeeeeeee  D:::::D     D:::::D
KK::::::K  K:::::KKK  B::::B     B:::::Ba::::a    a:::::a   R::::R     R:::::Re:::::::e           D:::::D    D:::::D
K:::::::K   K::::::KBB:::::BBBBBB::::::Ba::::a    a:::::a RR:::::R     R:::::Re::::::::e        DDD:::::DDDDD:::::D
K:::::::K    K:::::KB:::::::::::::::::B a:::::aaaa::::::a R::::::R     R:::::R e::::::::eeeeeeeeD:::::::::::::::DD
K:::::::K    K:::::KB::::::::::::::::B   a::::::::::aa:::aR::::::R     R:::::R  ee:::::::::::::eD::::::::::::DDD
KKKKKKKKK    KKKKKKKBBBBBBBBBBBBBBBBB     aaaaaaaaaa  aaaaRRRRRRRR     RRRRRRR    eeeeeeeeeeeeeeDDDDDDDDDDDDD

                                        KDialog Backup Restore Database

"
DB_TITLE="KBaReD - @texta84"
DB_USER=$(kdialog --title "$DB_TITLE" --geometry 250x26 --inputbox "Usuario:");
if [ "$?" = 0 ]; then
    DB_PASSWORD=$(kdialog --title "$DB_TITLE" --password "Password:");
    if [ "$?" = 0 ]; then
        DB_PORT=$(kdialog --title "$DB_TITLE" --geometry 250x26 --inputbox "Puerto:" "3306");
        if [ "$?" = 0 ]; then
            DB_HOST=$(kdialog --title "$DB_TITLE" --geometry 250x26 --inputbox "Servidor:" "127.0.0.1");
            if [ "$?" = 0 ]; then
                DB_PROCESS=$(kdialog --title "$DB_TITLE" --geometry 250x26 --combobox "Elije una opción:" "Exportar" "Importar" "Eliminar" --default "Exportar");
                if [ "$DB_PROCESS" == "Importar" ]
                then
                    DB_ARRAY=$(kdialog --title "$DB_TITLE" --getopenfilename . "*.sql" --multiple);
                    if [ "$?" = 0 ]; then
                        LENGTH_ARRAY=0
                        for database in ${DB_ARRAY[@]}; do
                            ((LENGTH_ARRAY++))
                        done
                        progress=$(kdialog --title "$DB_TITLE" --progressbar "Importando bases de datos. . ." $LENGTH_ARRAY);
                        i=0
                        for sql_file in ${DB_ARRAY[@]}; do
                            if [ -f "$sql_file" ]; then
                                file_name=$(basename "$sql_file")
                                database=${file_name%%.*}
                                sleep 1;
                                qdbus $progress Set "" value $i > /dev/null;
                                qdbus $progress setLabelText "Importando: $database" > /dev/null;
                                if ! qdbus $progress Set "" value $i > /dev/null; then
                                    echo "Process cancelled."
                                    kdialog --error "Proceso cancelado."
                                    qdbus $progress close
                                    exit 1
                                fi
                                echo -e "\nDatabase \"$database\" importing"
                                mysqladmin -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f drop "$database" 2>/dev/null || true
                                mysqladmin -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" create "$database"
                                mysql -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f "$database" < "$sql_file"
                                if [ $? -eq 0 ]; then
                                    echo "Database \"$database\" imported"
                                else
                                    echo "Error importing \"$database\""
                                fi
                            fi
                            ((i++))
                        done
                        sleep 1;
                        qdbus $progress close > /dev/null;
                    fi
                    echo -e "\nThe import process is complete"
                    kdialog --title "$DB_TITLE" --msgbox "\nTerminó el proceso importar";
                elif [ "$DB_PROCESS" == "Exportar" ]
                then
                    DB_PATH=$(kdialog --title "$DB_TITLE" --getexistingdirectory *);
                    if [ "$?" = 0 ]; then
                        DB_ARRAY=($(mysql -u$DB_USER -p$DB_PASSWORD -P$DB_PORT -h$DB_HOST -e "SHOW DATABASES;"))
                        DB_ALL=()
                        for db in "${DB_ARRAY[@]}"; do
                            if [[
                            "$db" != "schema_name"
                            && "$db" != "Database"
                            && "$db" != "information_schema"
                            && "$db" != "mysql"
                            && "$db" != "performance_schema"
                            && "$db" != "sys"
                        ]]; then
                                DB_ALL+=($db $db "off")
                            fi
                        done
                        DB_SELECTED=$(kdialog --title "$DB_TITLE" --separate-output --checklist "Servidor: $DB_HOST" "${DB_ALL[@]}")
                        if [ $? = 0 ]; then
                            LENGTH_ARRAY=0
                            for database in ${DB_SELECTED[@]}; do
                                ((LENGTH_ARRAY++))
                            done
                            progress=$(kdialog --title "$DB_TITLE" --progressbar "Exportando bases de datos. . ." $LENGTH_ARRAY);
                            i=0
                            for database in ${DB_SELECTED[@]}; do
                                sleep 1;
                                qdbus $progress Set "" value $i > /dev/null;
                                qdbus $progress setLabelText "Exportando: $database" > /dev/null;
                                if ! qdbus $progress Set "" value $i > /dev/null; then
                                    echo "Process cancelled."
                                    kdialog --error "Proceso cancelado."
                                    qdbus $progress close
                                    exit 1
                                fi
                                echo -e "\nDatabase \"$database\" exporting"
                                mysqldump -u"$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f "$database" > "$DB_PATH/$database.sql"
                                if [ $? -eq 0 ]; then
                                    echo "Database \"$database\" exported"
                                else
                                    echo "Error exported \"$database\""
                                fi
                                ((i++))
                            done
                            echo -e "\nCompressing. . ."
                            qdbus $progress setLabelText "Comprimiendo. . ." > /dev/null;
                            cd "$DB_PATH" && tar -czvf $(date "+%Y%m%d_%H%M")_"$DB_HOST".tar.gz -C "$DB_PATH" *.sql --remove-files
                            sleep 1;
                            qdbus $progress close > /dev/null;
                        fi
                    else
                        echo "Error selecting a path"
                        kdialog --title "$DB_TITLE" --error "Error al seleccionar una ruta";
                    fi;
                    echo -e "\nThe export process is complete"
                    kdialog --title "$DB_TITLE" --msgbox "\nTerminó el proceso exportar";
                elif [ "$DB_PROCESS" == "Eliminar" ]
                then
                    DB_ARRAY=($(mysql -u$DB_USER -p$DB_PASSWORD -P$DB_PORT -h$DB_HOST -e "SHOW DATABASES;"))
                    DB_ALL=()
                    for db in "${DB_ARRAY[@]}"; do
                        if [[
                            "$db" != "schema_name"
                            && "$db" != "Database"
                            && "$db" != "information_schema"
                            && "$db" != "mysql"
                            && "$db" != "performance_schema"
                            && "$db" != "sys"
                        ]]; then
                            DB_ALL+=($db $db "off")
                        fi
                    done
                    DB_SELECTED=$(kdialog --title "$DB_TITLE" --separate-output --checklist "Servidor: $DB_HOST" "${DB_ALL[@]}")
                    if [ $? = 0 ]; then
                        kdialog --title "$DB_TITLE" --yesno "¿Realmente deseas eliminar las\nbases de datos seleccionadas?";
                        if [ "$?" = 0 ]; then
                            LENGTH_ARRAY=0
                            for database in ${DB_SELECTED[@]}; do
                                ((LENGTH_ARRAY++))
                            done
                            progress=$(kdialog --title "$DB_TITLE" --progressbar "Eliminando bases de datos. . ." $LENGTH_ARRAY);
                            i=0
                            for database in ${DB_SELECTED[@]}; do
                                sleep 1;
                                qdbus $progress Set "" value $i > /dev/null;
                                qdbus $progress setLabelText "Eliminando: $database" > /dev/null;
                                if ! qdbus $progress Set "" value $i > /dev/null; then
                                    echo "Process cancelled."
                                    kdialog --error "Proceso cancelado."
                                    qdbus $progress close
                                    exit 1
                                fi
                                echo -e "\nDatabase \"$database\" deleting"
                                mysqladmin -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f drop "$database" 2>/dev/null || true
                                if [ $? -eq 0 ]; then
                                    echo "Database \"$database\" eliminated"
                                else
                                    echo "Error deleteing \"$database\""
                                fi
                                ((i++))
                            done
                            sleep 1;
                            qdbus $progress close > /dev/null;
                        fi
                    fi
                    echo -e "\nThe deletion process has ended"
                    kdialog --title "$DB_TITLE" --msgbox "\nTerminó el proceso eliminar";
                fi
            fi
        fi
    fi
fi
