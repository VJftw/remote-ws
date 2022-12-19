# This can be used to determine if a web client is connected to
# openvscode-server as it uses websockets. We'll update to :443 with an auth
# proxy. When a user closes their browser tab, this returns no rows.
# netstat -an | grep :3000 | grep ESTABLISHED
