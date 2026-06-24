# Memory Map

This program stores the marks array and several counters in the data and BSS sections.

- `marks` (10 bytes): the list of student marks.
- `total` (4 bytes): sum of all marks.
- `highest` (4 bytes): highest mark found.
- `lowest` (4 bytes): lowest mark found.
- `failCount` (4 bytes)
- `passCount` (4 bytes)
- `creditCount` (4 bytes)
- `distCount` (4 bytes)

During execution, the code reads each mark with indexed addressing:
- `movzx eax, byte [marks + rbx]`

This is a clear example of direct, indirect, indexed, and based addressing.
