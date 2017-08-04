#!/bin/bash
gitlabToken="bkLvxe_Kz2kKV66Fu6eQ"
gitlabRepository="ansible-lab"
gitlabHookURL="http://rundeck:4440/api/2/job/6149b69b-c964-42f9-bad9-60dc021627f1/run?authtoken=0jYQFs30GGyIfjYq3Yj2t2HGsxRms9Qu"

curl -H "Content-type: application/json" -X POST -d "{\"name\": \"${gitlabRepository}\"}" http://localhost/api/v3/projects?private_token=${gitlabToken} >/dev/null 2>&1
curl -X GET http://localhost/api/v3/projects/1/hooks/1?private_token=${gitlabToken} 2>/dev/null | grep 'url' >/dev/null 2>&1
hookRC=$?
if [ ${hookRC} -ne 0 ]; then
  curl -H "Content-type: application/json" -X POST -d "{\"id\": 1,\"url\": \"${gitlabHookURL}\",\"push_events\":\"true\",\"enable_ssl_verification\":\"false\"}" http://localhost/api/v3/projects/1/hooks?private_token=${gitlabToken} >/dev/null 2>&1
fi
