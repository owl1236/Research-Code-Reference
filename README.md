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
