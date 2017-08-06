#!/bin/bash
gitlabToken=`cat /tmp/token.txt`
gitlabRepository="ansible-lab"

## Creating Repository
echo "GitLab - Creating Repository"
curl -H "Content-type: application/json" -X POST -d "{\"name\":\"${gitlabRepository}\",\"visibility\":\"public\"}" http://localhost/api/v4/projects?private_token=${gitlabToken} >/dev/null 2>&1

## Creating Webhooks
echo "GitLab - Creating Webhooks"

# Webhook #1 - Update Rundeck
# Checking if webhook is already created
curl -X GET http://localhost/api/v3/projects/1/hooks?private_token=${gitlabToken} 2>/dev/null | grep '6a4fb6cc-607d-4e12-9763-1e986a050efd' >/dev/null 2>&1
hookRC=$?
# Creating webhook
if [ ${hookRC} -ne 0 ]; then
  curl -H "Content-type: application/json" -X POST -d "{\"id\": 1,\"url\": \"http://rundeck:4440/api/2/job/6a4fb6cc-607d-4e12-9763-1e986a050efd/run?authtoken=0jYQFs30GGyIfjYq3Yj2t2HGsxRms9Qu\",\"push_events\":\"true\",\"enable_ssl_verification\":\"false\"}" http://localhost/api/v3/projects/1/hooks?private_token=${gitlabToken} >/dev/null 2>&1
fi

# Webhook #2 - Update Ansible
# Checking if webhook is already created
curl -X GET http://localhost/api/v3/projects/1/hooks?private_token=${gitlabToken} 2>/dev/null | grep 'b8d0bc47-899b-4e97-be93-846c84c406d3' >/dev/null 2>&1
hookRC=$?
# Creating webhook
if [ ${hookRC} -ne 0 ]; then
  curl -H "Content-type: application/json" -X POST -d "{\"id\": 2,\"url\": \"http://rundeck:4440/api/2/job/b8d0bc47-899b-4e97-be93-846c84c406d3/run?authtoken=0jYQFs30GGyIfjYq3Yj2t2HGsxRms9Qu\",\"push_events\":\"true\",\"enable_ssl_verification\":\"false\"}" http://localhost/api/v3/projects/1/hooks?private_token=${gitlabToken} >/dev/null 2>&1
fi

## Adding SSH Keys
echo "GitLab - Adding SSH Keys"
# Key - Ansible
curl -H "Content-type: application/json" -X POST -d "{\"title\": \"ansible\",\"key\": \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0LX+7Y3g1NQfg3EfwDQ0CGI9ZmtwWkiWdWl78V2gaigMgraEoFMGFAD+eWEA5M92g/cJkiLBzT7qFVKNZNIH0FcfiBaoeOG0o4IEn42ENsi5X+o6+wc85mMAcnabr2bqmVbPpPQJzqHMDk2GLmFw8ymBruxYTFo1oeiJ97aO3iDbPoyhx8q/tNpXNfijFueIR7RpPDr6GzLGhVm0LwcUjrSALEWYV8xA8M1AuA+576ANL8e/AFiDgHOYDHgB+odXgM0F21MfQ3WlxBK3K2qC3euoK2OPaMzgn1GsOocFwRIBbiJHTnqPIEyQ+kjLIf0HYeKu/gKlDLf3hDH4s06ef root@1239e4a534f8\"}" http://localhost/api/v3/user/keys?private_token=${gitlabToken}# >/dev/null 2>&1
# Key - Rundeck
curl -H "Content-type: application/json" -X POST -d "{\"title\": \"rundeck\",\"key\": \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpD891/NiVePbxNcyRrOJ+aafrlE2MGXROAgtwOpVHVCeiUjMVOXYR1Yq8ibyiMxGakZTR7++vQGAS9VKctxRk+u/OMQzLCpVxJuGe0s9kKbwgMycW/vXXsOwb0WlQCiZ2mg7abeSHYCeduCcPIQdM5YZTSUg8UIHq2xsBivJH3s/YsevLtRZ99NKgoPe7DdD/pCP99Nyi6I4tPmxCQU8FPIhboizUdXAq0pzcHw2wj4W68H3Iml7W86DmM5BsuvwQXDw3uru1wxG0OM3NfEvO6xroVDZ6y4frVt6SUq1c3Df8KiuhDE/hvJlw459uzE78Vac+01ShyTPvARAx6RfApQroni1RcD7YeDMoC/0uvQqmNQW1L7SZ5FqTEaZgcG61sgdBUj/U8X1HwPqQByScPJvUHymx+vsyiHL1wtPMKchYf39fSAMcaOJ58reK14m/NeE/BsR07bSpJjkA7IKgTJHVfk9RbgtB8Sb8CPZMFQzr0pmJS8ssLOkx3O7qYTKOBkfbT4d7tbYjh3hRLCyTfT5GenVqJFhYi1f4nYYHRVM4mKtiW7vnddWAfvpdkjPaXQ7oFR/muN+DgvWQCWiHtZNhktbiejxnPprR6z27FOeQiZOtjNIqaUwMeSRdoPo3MyYSeCJjeRIUBfil/PiItsKBMD6ktHGgKX1WAxXJ2Q== rundeck@rundeck\"}" http://localhost/api/v3/user/keys?private_token=${gitlabToken}# >/dev/null 2>&1
# Key - Workstation
curl -H "Content-type: application/json" -X POST -d "{\"title\": \"workstation\",\"key\": \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa4NGGB4r31/A3cIpvI8cQyND10kHu3dXZjdakVGvRoWMfEvfw1hzH4U7rpgsMQswGWMdDWR6L7SAhbbxx5n/Cl6hqYuKAXsF4wF/pr1bfhybf6d7zYESanj0c6LL4izH1+2PbHmX/a+SZ7szk7pUKU2dsNrSRwTfcZqq0L7TeRyizDCz6cEcqZR7BlgdYvc/UgkHYb0XjSh8gRIndQaGPkAj9UYJ9oUydRsXMOFjyNo37gIdsU3M+5nV2Jp/+VL/8W+111oRx1zyatq3nZY5sU0VifkFWhKUcaR/LGIIbuBDDOXTwU7irHETNXEUmtoCDpyUjqVVbhz37K2Mb+x7P eric@aa42282\"}" http://localhost/api/v3/user/keys?private_token=${gitlabToken}# >/dev/null 2>&1
