#!/usr/bin/env bash

unit_run_dir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")
export PROJ_PATH=$(
  cd $unit_run_dir/../../..
  echo $(pwd)
)

test -z ${USER:-} && USER='appusr'

if [[ "$ENV" == "lde" ]]; then

  sudo su - postgres -c "echo ${PGPASSWORD} > ${PGPASSWORD_FILE}"
  sudo su - postgres -c "chmod 600 ${PGPASSWORD_FILE}"

  sudo chmod -R 0750 "/var/lib/postgresql"
  sudo -u postgres createdb -O postgres postgres

  sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
  sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "pgcrypto";'
  sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "dblink";'
  #   /etc/postgresql/11/main/postgresql.conf"

  sudo su - postgres -c "${PGBINDIR}/initdb --pgdata=${PGDATA} --pwfile=${PGPASSWORD_FILE} \
    --username=postgres --encoding=UTF8 --auth=trust" --no-clean --debug -L $IMG_PROJ_PATH/src/sql/psql

  sudo sh /etc/init.d/postgresql restart

  log_file=/tmp/.$$.log
  sudo su postgres <<EOF >>$log_file
   createdb  $PGDB;
   psql -c "CREATE USER $PGUSER WITH PASSWORD '$PGPASSWORD';"
   psql -c "grant all privileges on database $PGDB to $PGUSER;"
   psql -d $PGDB -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
   echo "Postgres User '$PGUSER' and database '$PGDB' created."
EOF

  mkdir -p $PROJ_PATH/src/sql/psql/$PGDB/ddl
  # run the sql scripts in alphabetical order
  while read -r sql_script; do

    relative_sql_script=$(echo $sql_script | perl -ne "s#$IMG_PROJ_PATH##g;print")
    tmp_log_file=/tmp/.$$.$(basename $sql_script).log

    # and clear the screen
    printf "\033[2J"
    printf "\033[0;0H"

    echo "INFO START ::: running $relative_sql_script"
    echo -e '\n\n'
    # run the sql save the result into a tmp log file
    PGPASSWORD="${PGPASSWORD:-}" psql -v -q -t -X -w -U "${PGUSER:-}" \
      -h $PGHOST -p $PGPORT -v ON_ERROR_STOP=0 \
      -f "$sql_script" $PGDB >"$tmp_log_file" 2>&1
    ret=$?
    echo ret: $ret >>"$tmp_log_file"

    # show the user what is happenning
    cat "$tmp_log_file"
    test $ret -ne 0 && sleep 3
    test $ret -ne 0 && export EXIT_CODE=1
    test $ret -ne 0 && doExit "pid: $$ psql ret $ret - failed to run sql_script: $sql_script !!!"
    test $ret -ne 0 && break

    # and save the tmp log file into the script log file
    cat "$tmp_log_file" >>$log_file
    echo -e '\n\n'

    echo "INFO STOP  ::: running $relative_sql_script"
  done < <(find "$PROJ_PATH/src/sql/psql/$PGDB" -type f -name "*.sql" | sort -n | grep -v ad-hoc)

fi

trap : TERM INT
sleep infinity &
wait
