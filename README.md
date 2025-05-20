# Assembly Language

Assembly language is a low-level programming language that is closely related to machine code. It uses mnemonic codes to represent machine instructions, making it easier for humans to read and write programs that can be executed by a computer's CPU. Each assembly instruction corresponds to a specific operation that the CPU can perform.

## Key Features of Assembly Language

1. **Mnemonic Codes**: Assembly language uses mnemonic codes to represent machine instructions.

2. **Register Manipulation**: Assembly language allows direct manipulation of the CPU's registers, which are high-speed memory locations within the CPU. This is crucial for efficient program execution.

3. **Memory Access**: Assembly language provides direct access to memory locations, allowing for efficient memory management and manipulation.

4. **Low-Level Control**: It offers fine-grained control over hardware resources, making it ideal for system programming and performance-critical applications.

5. **Platform-Specific**: Assembly language is specific to the processor architecture it's designed for, meaning code written for one processor may not work on another.

## Dockerfile for Assembly Development

The project includes a Dockerfile that sets up an environment for assembly language development. Here's a brief description of its key components:

- **Base Image**: Uses a 32-bit Ubuntu 20.04 image (`i386/ubuntu:20.04`) to support 32-bit binaries.
- **Tools**: Installs essential tools like NASM (Netwide Assembler), GCC, and libc6-dev.
- **Workspace**: Sets up a working directory at `/usr/src/app`.
- **Code Compilation**: Copies the assembly code into the container, assembles it using NASM, and links it with GCC.
- **Execution**: Sets the entry point to run the compiled assembly program.

This Dockerfile provides a consistent and isolated environment for developing, compiling, and running assembly language programs, ensuring compatibility and ease of use across different systems.

## How to Use

1. Build the Docker image:

```sh
docker build -t x86_assembly .
```

1. Run the container:

```sh
./run.sh <filename.asm>
```
