# Floppy-Bootloader

This is a simple Bootloader PoC to learn some low level stuff.
This bootloader is loaded from a floppy disk by the BIOS. 

( Floppy disk because dealing with modern file systems of modern midias is complicated :P )

You will need NASM and QEMU to test it. You will also need support to KVM. 

Install QEMU (Ubuntu):

```sudo apt-get install qemu-kvm qemu virt-manager virt-viewer```

Install NASM (Ubuntu):

```apt install nasm```

How to use:

```nasm -f bin boot.asm -o boot.bin && qemu-system-x86_64 -fda boot.bin```
