# Research-Code-Reference
Analysis of Modern Executable Bloat and Performance Trade-offs in Minimal Programs

# Compilation Commands — All 44 Variants

Every variant is a "Hello, World!" program compiled as ELF32 (i386) from one of the 7 source files in `c/`, `cpp/`, and `Assembly/`. 

## Environment

-   **Host:** WSL2 (Kali GNU/Linux Rolling), x86_64 — all targets built as ELF32 via `-m32` / `elf_i386`, executed through the ia32 compat layer
-   **gcc / g++:** Debian 16.2.0-1 (16.2.0)
-   **GNU ld / as:** Binutils 2.47
-   **NASM:** 3.01
-   **32-bit support:** `libc6-dev-i38` + `gcc-multilib` installed

## Sources Used

| File | Language | I/O Technique |
| :--- | :--- | :--- |
| `cpp/hello_iostream.cpp` | C++ | `std::cout` |
| `cpp/hello_printf.cpp` | C++ | `printf` |
| `cpp/hello_puts.cpp` | C++ | `puts` |
| `cpp/hello_write.cpp` | C++ | raw `write()` |
| `c/hello_printf.c` | C | `printf` |
| `c/hello_puts.c` | C | `puts` |
| `c/hello_write.c` | C | raw `write()` |
| `Assembly/Default_smallest_no_header_override/hello_world.asm` | NASM (elf32) | `int 0x80` write |
| `Assembly/Absolute_smallest_standalone_exec/smallest.asm` | hand-crafted raw ELF32 | `int 0x80` write |

## Flag Sets (Applied to Each Language/Technique)

| Suffix | Flags |
| :--- | :--- |
| `(none)` | default (`-O0`) |
| `_O2` | `-O2` |
| `_Os` | `-Os` |
| `_static` | `-static` |
| `_static_Os` | `-static -Os` |
| `_static_Os_stripped` | `-static -Os -s` |

---

## Phase 1 — C++ Baseline (iostream) — 6 Variants

```bash
g++ cpp/hello_iostream.cpp -m32                          -o hello_cpp_O0
g++ cpp/hello_iostream.cpp -m32 -O2                      -o hello_cpp_O2
g++ cpp/hello_iostream.cpp -m32 -Os                      -o hello_cpp_Os
g++ cpp/hello_iostream.cpp -m32 -static                  -o hello_cpp_static
g++ cpp/hello_iostream.cpp -m32 -static -Os              -o hello_cpp_static_Os
g++ cpp/hello_iostream.cpp -m32 -static -Os -s           -o hello_cpp_static_Os_stripped
```
## Phase 2 — C++ Optimization Techniques (printf / puts / write) — 18 Variants

### printf
```bash
g++ cpp/hello_printf.cpp -m32                            -o hello_cpp_printf_O0
g++ cpp/hello_printf.cpp -m32 -O2                        -o hello_cpp_printf_O2
g++ cpp/hello_printf.cpp -m32 -Os                        -o hello_cpp_printf_Os
g++ cpp/hello_printf.cpp -m32 -static                    -o hello_cpp_printf_static
g++ cpp/hello_printf.cpp -m32 -static -Os                -o hello_cpp_printf_static_Os
g++ cpp/hello_printf.cpp -m32 -static -Os -s             -o hello_cpp_printf_static_Os_stripped
```

### puts
```bash
g++ cpp/hello_puts.cpp -m32                              -o hello_cpp_puts_O0
g++ cpp/hello_puts.cpp -m32 -O2                          -o hello_cpp_puts_O2
g++ cpp/hello_puts.cpp -m32 -Os                          -o hello_cpp_puts_Os
g++ cpp/hello_puts.cpp -m32 -static                      -o hello_cpp_puts_static
g++ cpp/hello_puts.cpp -m32 -static -Os                  -o hello_cpp_puts_static_Os
g++ cpp/hello_puts.cpp -m32 -static -Os -s               -o hello_cpp_puts_static_Os_stripped
```

### write (raw syscall wrapper)
```bash
g++ cpp/hello_write.cpp -m32                             -o hello_cpp_write_O0
g++ cpp/hello_write.cpp -m32 -O2                         -o hello_cpp_write_O2
g++ cpp/hello_write.cpp -m32 -Os                         -o hello_cpp_write_Os
g++ cpp/hello_write.cpp -m32 -static                     -o hello_cpp_write_static
g++ cpp/hello_write.cpp -m32 -static -Os                 -o hello_cpp_write_static_Os
g++ cpp/hello_write.cpp -m32 -static -Os -s              -o hello_cpp_write_static_Os_stripped
```

## Phase 3 — C Baseline (printf) — 6 Variants

```bash
gcc c/hello_printf.c -m32                                -o hello_c_O0
gcc c/hello_printf.c -m32 -O2                            -o hello_c_O2
gcc c/hello_printf.c -m32 -Os                            -o hello_c_Os
gcc c/hello_printf.c -m32 -static                        -o hello_c_static
gcc c/hello_printf.c -m32 -static -Os                    -o hello_c_static_Os
gcc c/hello_printf.c -m32 -static -Os -s                 -o hello_c_static_Os_stripped
```

## Phase 4 — C Optimization Techniques (puts / write) — 12 Variants

### puts
```bash
gcc c/hello_puts.c -m32                                  -o hello_c_puts_O0
gcc c/hello_puts.c -m32 -O2                              -o hello_c_puts_O2
gcc c/hello_puts.c -m32 -Os                              -o hello_c_puts_Os
gcc c/hello_puts.c -m32 -static                          -o hello_c_puts_static
gcc c/hello_puts.c -m32 -static -Os                      -o hello_c_puts_static_Os
gcc c/hello_puts.c -m32 -static -Os -s                   -o hello_c_puts_static_Os_stripped
```

### write (raw syscall wrapper)
```bash
gcc c/hello_write.c -m32                                 -o hello_c_write_O0
gcc c/hello_write.c -m32 -O2                             -o hello_c_write_O2
gcc c/hello_write.c -m32 -Os                             -o hello_c_write_Os
gcc c/hello_write.c -m32 -static                         -o hello_c_write_static
gcc c/hello_write.c -m32 -static -Os                     -o hello_c_write_static_Os
gcc c/hello_write.c -m32 -static -Os -s                  -o hello_c_write_static_Os_stripped
```

## Phase 5 — Assembly — 2 Variants

### hello_asm_default (280 B) — NASM elf32 object + default linker
```bash
nasm -f elf32 Assembly/Default_smallest_no_header_override/hello_world.asm -o /tmp/hw.o
ld   -m elf_i386 -N -s /tmp/hw.o -o hello_asm_default
```

### hello_asm_smallest (62 B) — hand-crafted raw ELF, no loader needed
The file is a complete executable in itself (ELF magic + program header + code hand-encoded in `smallest.asm`). It is assembled as flat binary and copied as-is:

```bash
nasm -f bin Assembly/Absolute_smallest_standalone_exec/smallest.asm -o hello_asm_smallest
# equivalent to the original build, which shipped the pre-assembled file:
cp Assembly/Absolute_smallest_standalone_exec/smallest hello_asm_smallest
```

## Total

6 + 18 + 6 + 12 + 2 = **44 variants**

> **Note:** The default (no-flag) builds are named `*_O0` to match the columns in `results/summary.csv`.

## Measurement Commands (Reference)

```bash
# Per-variant timing: 10 warmup, 50 runs -> results/time/<name>.csv
hyperfine --warmup 10 --runs 50 --export-csv results/time/<name>.csv ./<name>

# Max RSS
/usr/bin/time -v ./<name> | grep "Maximum resident set size"

# Syscall trace
strace -c ./<name>   # (see results/strace/)
```
