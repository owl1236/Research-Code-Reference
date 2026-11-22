# Research-Code-Reference
Analysis of Modern Executable Bloat and Performance Trade-offs in Minimal Programs

# Compilation Commands — All 44 Variants

Every variant is a "Hello, World!" program compiled as ELF32 (i386) from one of the 7 source files in `c/`, `cpp/`, and `Assembly/`.

## Environment

-   **Host:** WSL2 (Kali GNU/Linux Rolling), x86_64 — all targets built as ELF32 via `-m32` / `elf_i386`, executed through the ia32 compat layer
-   **gcc / g++:** Debian 16.2.0-1 (16.2.0)
-   **GNU ld / as:** Binutils 2.47
-   **NASM:** 3.01
-   **32-bit support:** `libc6-dev-i386` + `gcc-multilib` installed

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

## Naming Scheme

Every build is named `language-routine-linking-optimization`:

| Part | Values |
| :--- | :--- |
| language | `cpp` (C++), `c` (C) |
| routine | `stream` (`std::cout`, C++ only), `printf`, `puts`, `write` (raw `write()`) |
| linking-optimization | see "Flag Sets" below |

The two assembly builds are named `asm-linked` and `asm-raw`.

## Flag Sets (Applied to Each Language/Technique)

| Linking-optimization | Flags |
| :--- | :--- |
| `dynamic-O0` | default, no optimization flag (`-O0`) |
| `dynamic-O2` | `-O2` |
| `dynamic-Os` | `-Os` |
| `static-O0` | `-static` |
| `static-Os` | `-static -Os` |
| `static-Os-stripped` | `-static -Os -s` |

---

## Phase 1 — C++ Baseline (iostream) — 6 Variants
```bash
g++ cpp/hello_iostream.cpp -m32                 -o cpp-stream-dynamic-O0
g++ cpp/hello_iostream.cpp -m32 -O2             -o cpp-stream-dynamic-O2
g++ cpp/hello_iostream.cpp -m32 -Os             -o cpp-stream-dynamic-Os
g++ cpp/hello_iostream.cpp -m32 -static         -o cpp-stream-static-O0
g++ cpp/hello_iostream.cpp -m32 -static -Os     -o cpp-stream-static-Os
g++ cpp/hello_iostream.cpp -m32 -static -Os -s  -o cpp-stream-static-Os-stripped
```

## Phase 2 — C++ Optimization Techniques (printf / puts / write) — 18 Variants
### printf
```bash
g++ cpp/hello_printf.cpp -m32                 -o cpp-printf-dynamic-O0
g++ cpp/hello_printf.cpp -m32 -O2             -o cpp-printf-dynamic-O2
g++ cpp/hello_printf.cpp -m32 -Os             -o cpp-printf-dynamic-Os
g++ cpp/hello_printf.cpp -m32 -static         -o cpp-printf-static-O0
g++ cpp/hello_printf.cpp -m32 -static -Os     -o cpp-printf-static-Os
g++ cpp/hello_printf.cpp -m32 -static -Os -s  -o cpp-printf-static-Os-stripped
```

### puts
```bash
g++ cpp/hello_puts.cpp -m32                 -o cpp-puts-dynamic-O0
g++ cpp/hello_puts.cpp -m32 -O2             -o cpp-puts-dynamic-O2
g++ cpp/hello_puts.cpp -m32 -Os             -o cpp-puts-dynamic-Os
g++ cpp/hello_puts.cpp -m32 -static         -o cpp-puts-static-O0
g++ cpp/hello_puts.cpp -m32 -static -Os     -o cpp-puts-static-Os
g++ cpp/hello_puts.cpp -m32 -static -Os -s  -o cpp-puts-static-Os-stripped
```

### write (raw syscall wrapper)
```bash
g++ cpp/hello_write.cpp -m32                 -o cpp-write-dynamic-O0
g++ cpp/hello_write.cpp -m32 -O2             -o cpp-write-dynamic-O2
g++ cpp/hello_write.cpp -m32 -Os             -o cpp-write-dynamic-Os
g++ cpp/hello_write.cpp -m32 -static         -o cpp-write-static-O0
g++ cpp/hello_write.cpp -m32 -static -Os     -o cpp-write-static-Os
g++ cpp/hello_write.cpp -m32 -static -Os -s  -o cpp-write-static-Os-stripped
```

## Phase 3 — C Baseline (printf) — 6 Variants
```bash
gcc c/hello_printf.c -m32                 -o c-printf-dynamic-O0
gcc c/hello_printf.c -m32 -O2             -o c-printf-dynamic-O2
gcc c/hello_printf.c -m32 -Os             -o c-printf-dynamic-Os
gcc c/hello_printf.c -m32 -static         -o c-printf-static-O0
gcc c/hello_printf.c -m32 -static -Os     -o c-printf-static-Os
gcc c/hello_printf.c -m32 -static -Os -s  -o c-printf-static-Os-stripped
```

## Phase 4 — C Optimization Techniques (puts / write) — 12 Variants
### puts
```bash
gcc c/hello_puts.c -m32                 -o c-puts-dynamic-O0
gcc c/hello_puts.c -m32 -O2             -o c-puts-dynamic-O2
gcc c/hello_puts.c -m32 -Os             -o c-puts-dynamic-Os
gcc c/hello_puts.c -m32 -static         -o c-puts-static-O0
gcc c/hello_puts.c -m32 -static -Os     -o c-puts-static-Os
gcc c/hello_puts.c -m32 -static -Os -s  -o c-puts-static-Os-stripped
```

### write (raw syscall wrapper)
```bash
gcc c/hello_write.c -m32                 -o c-write-dynamic-O0
gcc c/hello_write.c -m32 -O2             -o c-write-dynamic-O2
gcc c/hello_write.c -m32 -Os             -o c-write-dynamic-Os
gcc c/hello_write.c -m32 -static         -o c-write-static-O0
gcc c/hello_write.c -m32 -static -Os     -o c-write-static-Os
gcc c/hello_write.c -m32 -static -Os -s  -o c-write-static-Os-stripped
```

## Phase 5 — Assembly — 2 Variants

### asm-linked (280 B) — NASM elf32 object + default linker
```bash
nasm -f elf32 Assembly/Default_smallest_no_header_override/hello_world.asm -o /tmp/hw.o
ld   -m elf_i386 -N -s /tmp/hw.o -o asm-linked
```

### asm-raw (62 B) — hand-crafted raw ELF, no loader needed
The file is a complete executable in itself (ELF magic + program header + code hand-encoded in `smallest.asm`). It is assembled as flat binary and copied as-is:

```bash
nasm -f bin Assembly/Absolute_smallest_standalone_exec/smallest.asm -o asm-raw
# equivalent to the original build, which shipped the pre-assembled file:
cp Assembly/Absolute_smallest_standalone_exec/smallest asm-raw
```

## Total

6 + 18 + 6 + 12 + 2 = **44 variants**

## Measurement Commands (Reference)

```bash
# Per-variant timing: 10 warmup, 50 runs
hyperfine --warmup 10 --runs 50 ./<name>

# Max RSS
/usr/bin/time -v ./<name> | grep "Maximum resident set size"

# Syscall trace
strace -c ./<name>
```
