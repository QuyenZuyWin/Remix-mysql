#!/bin/bash

COMMANDS=(
"Docker-Up"
"Docker-Down"
"Docker-Rebuild"
"Start-remix"
"Run-dev"
"Init-db"
"Exec-node"
"prisma-generate"
)


echo Please select a command.
select COMMAND in ${COMMANDS[@]}
do
  if [ -z "$COMMAND" ]; then
    continue
  else
    break
  fi
done
echo You selected $REPLY\) $COMMAND


if [ $COMMAND = "Docker-Up" ]; then
  docker-compose up -d
  docker-compose ps
  docker-compose exec node sh -c "npm install"
  docker-compose exec node sh -c "npm install prisma"
fi

if [ $COMMAND = "Docker-Down" ]; then
  docker-compose down
  lsof -i :3308  | tail -n 1 | awk '{print $2}' | xargs kill -9
fi

if [ $COMMAND = "Docker-Rebuild" ]; then
  docker-compose build --no-cache
fi

if [ $COMMAND = "Start-remix" ]; then
  docker-compose exec node sh -c "npm install"
  docker-compose exec node sh -c "npx prisma generate"
  docker-compose exec node sh -c "./start.sh"
fi

if [ $COMMAND = "prisma-generate" ]; then
  docker-compose exec node sh -c "npx prisma generate"
fi

if [ $COMMAND = "Exec-node" ]; then
  docker-compose exec node sh
fi
