# FileScanner

A file scanner in Elixir

The contents of `test_text.txt`:
```
jason
was
here
```

Usage:

```elixir
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiling 1 file (.ex)
Interactive Elixir (1.5.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> fs = FileScanner.new("test_text.txt")
%FileScanner{chunk_size: 1024, delimiter: "\n", file: #PID<0.130.0>,
 path: "test_text.txt", position: 0}
iex(2)> {:ok, fs, data} = FileScanner.next(fs)
{:ok,
 %FileScanner{chunk_size: 1024, delimiter: "\n", file: #PID<0.130.0>,
  path: "test_text.txt", position: 6}, "jason"}
iex(3)> {:ok, fs, data} = FileScanner.next(fs)
{:ok,
 %FileScanner{chunk_size: 1024, delimiter: "\n", file: #PID<0.130.0>,
  path: "test_text.txt", position: 10}, "was"}
iex(4)> {:ok, fs, data} = FileScanner.next(fs)
{:ok,
 %FileScanner{chunk_size: 1024, delimiter: "\n", file: #PID<0.130.0>,
  path: "test_text.txt", position: 15}, "here"}
iex(5)>
```
