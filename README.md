### Some utils commands

```elixir
spwan(Servy.HttpServer, :start, [4567])
Servy.HttpServer.start(4567)

Servy.FourOhFourCounter.start()
Servy.PledgeServer.start()

:sys.get_status(pid)
:observer.start
Process.info(pid, :messages)
Process.info(pid, :message_queue_len)
pid = Process.whereis(:http_server)
Process.exit(pid, :some_reason)
Process.alive?(pid)
```
