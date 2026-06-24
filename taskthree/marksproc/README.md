# Task 3: Marks Processor

## Files
- `marks.asm` - computes total, average, highest, lowest, and grade categories.
- `memory_map.md` - describes the data layout in memory.
- `test_cases.md` - sample output and expected values.

## Build and run
From `taskthree/marksproc`:

```bash
nasm -f elf64 marks.asm -o marks.o
ld marks.o -o marks
./marks
```

## Presentation notes
1. Run `./marks` and show the output.
2. Explain the marks array and how the loop computes totals and categories.
3. Mention the addressing mode examples in the comments.
