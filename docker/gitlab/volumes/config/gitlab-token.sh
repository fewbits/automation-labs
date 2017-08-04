#!/bin/bash

/opt/gitlab/embedded/bin/psql -h /var/opt/gitlab/postgresql -d gitlabhq_production -t -c "SELECT authentication_token FROM users WHERE username='root';" | head -n1 | tr -d ' ' > /tmp/token.txt
