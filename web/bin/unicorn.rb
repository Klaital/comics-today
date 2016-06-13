# This was taken pretty much verbatim from the sinatra recipe:
# http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn

@dir = File.dirname(File.absolute_path(__FILE__))
worker_processes 2
working_directory @dir
timeout 30

listen "/home/chris/devel/comics-today/web/shared/sockets/unicorn.sock", :backlog => 2048
#listen "http://127.0.0.1:5000"

pid "/home/chris/devel/comics-today/web/shared/pids/unicorn.pid"

stderr_path "/home/chris/devel/comics-today/web/shared/log/unicorn.stderr.log"
stdout_path "/home/chris/devel/comics-today/web/shared/log/unicorn.stdout.log"

timeout 300
