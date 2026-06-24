# Flag Analysis

This ALU simulator prints the CPU flags after each operation.

- CF (Carry Flag): set when an unsigned operation overflows.
- ZF (Zero Flag): set when the result is zero.
- SF (Sign Flag): set when the result is negative.
- OF (Overflow Flag): set when a signed operation produces a result outside the allowed range.

Example table:

Operation | Result | CF | ZF | SF | OF
---|---|---|---|---|---
255 + 1 | 256 | 0 | 0 | 0 | 0
-5 + 3 | -2 | 0 | 0 | 0 | 0
127 + 1 | 128 | 0 | 0 | 0 | 0
127 + 127 | 254 | 0 | 0 | 0 | 0
-128 - 1 | -129 | 0 | 0 | 1 | 1

## Overflow Discussion

Real systems can fail when values exceed storage limits. If an 8-bit ALU adds `255 + 1`, the result wraps to `0` and the carry flag is set. This kind of overflow can corrupt bank balances, sensor readings, or packet counters.

The simulator is a simple way to show how arithmetic and bitwise operations affect flags and why overflow must be handled.
