# Task 1: Data Representation Toolkit

## Files
- `hello.asm` - prints "Hello BIT4220" using Linux syscalls.
- `data_repr.asm` - demonstrates byte, word, dword, ASCII, and little-endian storage.
- `MakeFile` - builds both programs.

## What this demonstrates
- `.data` section stores constants and variables.
- `.text` section contains code.
- Linux syscalls `write` and `exit` are used directly.
- `byteVal`, `wordVal`, and `hdwordVal` show numeric sizes and storage.
- `12345678h` is stored in memory as `78 56 34 12` in little-endian format.

## Build and run
From `taskone/datarepr`:

```bash
make
./hello
./data_repr
```

## Running during presentation
1. Open a terminal in `taskone/datarepr`.
2. Run `make` once.
3. Show `./hello` to demonstrate syscall string output.
4. Then run `./data_repr` and explain the data values and little-endian memory order.
