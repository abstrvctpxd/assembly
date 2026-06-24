# Task 2: ALU Simulator

## Files
- `alusimul/alu.asm` - menu-driven ALU simulator with arithmetic and bitwise operations.
- `alusimul/flag_analysis.md` - explains CPU flags and overflow behavior.

## Build and run
From `tasktwo`:

```bash
cd alusimul
nasm -f elf64 alu.asm -o alu.o
ld alu.o -o alu
./alu
```

## Presentation notes
1. Run `./alu` and show the menu.
2. Enter option `1` for Add, then values like `8` and `4`.
3. Show output `Result = 12` and the CPU flags line.
4. Try a boundary case like `255` and `1` to discuss overflow behavior.
