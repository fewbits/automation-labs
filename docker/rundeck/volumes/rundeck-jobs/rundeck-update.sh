#!bin/bash
gitRepository="http://gitlab/root/ansible-lab.git"
gitClonePath="${HOME}/ansible-lab"
jobProject="ansible-lab"
jobFormat="yaml"
jobDuplicate="update"

## This script will 'auto-update' Rundeck's Jobs

if [ -d ${gitClonePath} ]; then
  echo "Git - Repository found - Pulling for changes"
  cd ${gitClonePath} && git pull
else
  echo "Git - Repository not found - Cloning"
  git clone ${gitRepository} ${gitClonePath}
fi

echo "Looking for Rundeck Job files"
find ${gitClonePath} -name "rundeck-*.yml"

echo "Importing Rundeck Jobs"
for jobFile in `find ${gitClonePath} -name "rundeck-*.yml"`
do
  rd jobs load --file ${jobFile} --project ${jobProject} --format ${jobFormat} --duplicate ${jobDuplicate}
done
