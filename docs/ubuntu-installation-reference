# Ubuntu Installation & Boot Process - Complete Reference Guide

**Author's Installation Journey**: Ubuntu 24.04.3 LTS  
**Date**: February 2026  
**Hardware**: Acer PC with Intel BIOS (2011), UEFI Support

---

## Table of Contents

1. [Hardware & Firmware Layer](#1-hardware--firmware-layer)
2. [BIOS vs UEFI](#2-bios-vs-uefi)
3. [CSM (Compatibility Support Module)](#3-csm-compatibility-support-module)
4. [Disk Partitioning Schemes](#4-disk-partitioning-schemes)
5. [Bootloader Concepts](#5-bootloader-concepts)
6. [Complete Boot Sequence](#6-complete-boot-sequence)
7. [Installation Process](#7-installation-process)
8. [Troubleshooting Common Errors](#8-troubleshooting-common-errors)
9. [Post-Installation Setup](#9-post-installation-setup)
10. [Ubuntu Pro](#10-ubuntu-pro)
11. [System Maintenance](#11-system-maintenance)
12. [Quick Reference Commands](#12-quick-reference-commands)

---

## 1. Hardware & Firmware Layer

### What Happens When You Press the Power Button?

```
Power Button Pressed
        ↓
PSU (Power Supply) → Sends electricity to motherboard
        ↓
Motherboard → Initializes and powers up
        ↓
CPU → Starts executing from special firmware chip
        ↓
BIOS/UEFI Firmware Chip → First software that runs
```

### The Firmware Chip

**Location**: Soldered directly onto the motherboard  
**Type**: ROM (Read-Only Memory) or Flash memory  
**Size**: 
- BIOS: 1-2 MB
- UEFI: 16-32 MB

**What it contains**: Firmware - software permanently stored in hardware

**Why the CPU looks here first**: The CPU doesn't know about operating systems, files, or disks. It only knows to look at a specific memory address where the firmware chip is mapped.

---

## 2. BIOS vs UEFI

### BIOS (Basic Input/Output System)

**Invented**: 1975  
**Technology**: 16-bit code  
**Interface**: Text-only, keyboard navigation  
**Storage**: Small ROM chip (1-2 MB)

#### What BIOS Does:

1. **POST (Power-On Self-Test)**
   - Tests RAM
   - Tests CPU
   - Tests keyboard, video card
   - Beeps if errors detected

2. **Hardware Initialization**
   - Gets video card working (so you can see output)
   - Initializes storage controllers
   - Configures basic hardware

3. **Bootloader Loading**
   - Reads **first 512 bytes** of boot disk (MBR)
   - Executes whatever code is found there
   - Transfers control to bootloader

#### BIOS Limitations:

- ❌ Can only boot from disks **< 2 TB**
- ❌ Uses MBR partitioning (max 4 primary partitions)
- ❌ Only 512 bytes for boot code (very limited!)
- ❌ No security features
- ❌ Slow (16-bit mode)
- ❌ No network booting

### UEFI (Unified Extensible Firmware Interface)

**Invented**: 2005 (by Intel)  
**Technology**: 32-bit or 64-bit code  
**Interface**: Graphical with mouse support  
**Storage**: Flash memory (16-32 MB)

#### What UEFI Does (Everything BIOS Does, Plus):

1. **Better Hardware Initialization**
   - Faster boot
   - More efficient hardware detection
   - Native support for modern hardware

2. **Advanced Features**
   - Graphical interface with mouse
   - Secure Boot (verifies bootloader signatures)
   - Network booting capabilities
   - GPT partition support (disks > 2 TB)
   - Multiple bootloader storage
   - Boot from large disks (no 2 TB limit)

3. **Boot Process**
   - Instead of reading first 512 bytes, looks for **EFI System Partition (ESP)**
   - ESP contains bootloader files (`.efi` files)
   - Boot configuration stored in **NVRAM** (non-volatile RAM on motherboard)

#### UEFI Advantages:

- ✅ Supports disks > 2 TB (up to 9.4 ZB!)
- ✅ Up to 128 partitions (vs 4 in BIOS)
- ✅ Secure Boot prevents rootkits
- ✅ Faster boot times
- ✅ Better hardware compatibility
- ✅ Network boot support
- ✅ Graphical setup interface

---

## 3. CSM (Compatibility Support Module)

### The Bridge Between Old and New

**Problem**: When UEFI was introduced, many operating systems still expected BIOS behavior.

**Solution**: CSM - a module **inside UEFI firmware** that **emulates BIOS**.

### What is CSM?

**CSM = BIOS compatibility mode running inside UEFI**

Think of it as: Modern UEFI pretending to be old BIOS

### CSM Boot Modes:

1. **UEFI Mode** (Pure UEFI)
   - No BIOS emulation
   - Uses GPT partitions
   - Bootloader on ESP partition
   - Recommended for new OS installations

2. **Legacy/CSM Mode** (BIOS Emulation)
   - UEFI pretends to be BIOS
   - Uses MBR partitions
   - Bootloader in first 512 bytes
   - For old operating systems

3. **Dual/Both Mode**
   - Can boot either way
   - Confusing and problematic
   - Not recommended

### Why CSM Matters for Installation:

**Critical Rule**: Boot mode must match partition scheme!

| Boot Mode | Partition Scheme | Bootloader Location |
|-----------|------------------|---------------------|
| UEFI | GPT | ESP partition (/boot/efi) |
| Legacy/CSM | MBR | First 512 bytes of disk |
| Mismatch | ❌ FAILS | Installation errors |

**Common Mistake**: Creating USB with MBR but booting in UEFI mode → Installation fails!

---

## 4. Disk Partitioning Schemes

### What is a Partition?

**Analogy**: A hard disk is like an apartment building. Partitioning divides it into separate apartments (partitions), each serving different purposes.

### MBR (Master Boot Record) - The Old Way

**Created**: 1983  
**Maximum Disk Size**: 2 TB  
**Maximum Partitions**: 4 primary (or 3 primary + 1 extended with many logical)

#### MBR Structure:

```
[First 512 bytes of disk - Sector 0]
├─ Boot code: 446 bytes      ← Bootloader lives here
├─ Partition table: 64 bytes  ← 4 entries × 16 bytes each
└─ Boot signature: 2 bytes    ← 0x55AA (validation)
```

#### MBR Partition Table Example:

```
Disk /dev/sda (500 GB)
├─ Partition 1: 100 GB (Windows C:)
├─ Partition 2: 200 GB (Linux /)
├─ Partition 3: 150 GB (Data)
└─ Partition 4: 50 GB (Extended)
    ├─ Logical 5: 25 GB
    └─ Logical 6: 25 GB
```

#### MBR Limitations:

- ❌ Maximum 4 primary partitions
- ❌ Maximum 2 TB disk size
- ❌ No backup of partition table (corruption = data loss)
- ❌ No partition names (only numbers)
- ❌ No checksums (can't detect corruption)

### GPT (GUID Partition Table) - The Modern Way

**Created**: Late 1990s (part of UEFI specification)  
**Maximum Disk Size**: 9.4 ZB (zettabytes = billion terabytes!)  
**Maximum Partitions**: 128 by default (can be more)

#### GPT Structure:

```
[Beginning of disk]
├─ Protective MBR (512 bytes)     ← Backward compatibility
├─ Primary GPT Header             ← Partition table metadata
├─ Partition Entry Array          ← Up to 128 partition entries
├─ [Your actual partitions]       ← Data
├─ Backup Partition Entry Array   ← Redundancy
└─ Backup GPT Header              ← Redundancy
```

#### GPT Partition Table Example:

```
Disk /dev/sda (1 TB, GPT)
├─ Partition 1: EFI System Partition - 512 MB (FAT32)
├─ Partition 2: Root (/) - 50 GB (ext4)
├─ Partition 3: Swap - 8 GB (swap)
└─ Partition 4: Home (/home) - 941 GB (ext4)
```

#### GPT Advantages:

- ✅ Up to 128 partitions (expandable)
- ✅ Maximum disk size: 9.4 ZB
- ✅ **Redundancy**: Backup copies at end of disk
- ✅ **Partition names**: Human-readable labels
- ✅ **GUIDs**: Unique identifier for each partition
- ✅ **CRC32 checksums**: Detects corruption
- ✅ **Protective MBR**: Prevents old tools from corrupting disk

### Comparison Table:

| Feature | MBR | GPT |
|---------|-----|-----|
| Max Disk Size | 2 TB | 9.4 ZB |
| Max Partitions | 4 primary | 128+ |
| Redundancy | ❌ No | ✅ Yes (backup at end) |
| Corruption Detection | ❌ No | ✅ Yes (CRC checksums) |
| Partition Names | ❌ No | ✅ Yes |
| Boot Mode | BIOS/Legacy | UEFI |
| Year Introduced | 1983 | ~2000 |

---

## 5. Bootloader Concepts

### What is a Bootloader?

**Definition**: Software that runs **after firmware** (BIOS/UEFI) but **before the operating system**.

**Purpose**: 
- Load the operating system kernel into memory
- Provide boot menu (if multiple OSes installed)
- Pass boot parameters to kernel

### Bootloader is NOT:

- ❌ Part of the operating system
- ❌ Part of the firmware/hardware
- ❌ Stored on a separate chip

### Bootloader IS:

- ✅ Software stored on the boot disk
- ✅ Separate from but loaded by firmware
- ✅ Location depends on boot mode (BIOS vs UEFI)

### GRUB (GRand Unified Bootloader)

**GRUB** is the bootloader used by Ubuntu and most Linux distributions.

**Current Version**: GRUB 2 (completely rewritten from GRUB Legacy)

#### Where Does GRUB Live?

**Answer**: It depends on boot mode!

### GRUB in BIOS/Legacy Mode:

```
Physical Disk /dev/sda (MBR)
│
├─ [Sector 0 - MBR - 512 bytes]
│   ├─ Boot code: 446 bytes        ← GRUB Stage 1 (very limited)
│   ├─ Partition table: 64 bytes
│   └─ Signature: 2 bytes
│
├─ [Sectors 1-63 - Post-MBR gap]
│   └─ core.img                    ← GRUB Stage 1.5 (more code)
│
└─ [Partition 1 starts here]
    └─ /boot/grub/                 ← GRUB Stage 2 (full features)
        ├─ grub.cfg               (configuration file)
        ├─ modules/               (filesystem drivers, etc.)
        ├─ fonts/
        └─ themes/
```

#### BIOS/Legacy Boot Process:

1. **BIOS** reads first 512 bytes (MBR)
2. **Stage 1** (446 bytes) loads Stage 1.5 from post-MBR gap
3. **Stage 1.5** understands filesystems, loads Stage 2 from /boot
4. **Stage 2** shows menu, loads kernel

**Limitation**: Only 446 bytes in Stage 1 - must be extremely compact!

### GRUB in UEFI Mode:

```
Physical Disk /dev/sda (GPT)
│
├─ [Partition 1: ESP - 512 MB, FAT32]
│   └─ /EFI/
│       ├─ /Boot/
│       │   └─ bootx64.efi         ← Fallback bootloader
│       ├─ /ubuntu/
│       │   ├─ grubx64.efi         ← GRUB bootloader (UEFI app)
│       │   ├─ shimx64.efi         ← Secure Boot shim
│       │   ├─ grub.cfg            ← Configuration
│       │   └─ modules/
│       └─ /Microsoft/             ← If Windows installed
│           └─ Boot/bootmgfw.efi
│
├─ [Partition 2: Root /]
│   └─ Your Linux files
│
└─ [Partition 3: /home]
```

#### UEFI Boot Process:

1. **UEFI firmware** reads boot variables from NVRAM
2. Boot variables point to `.efi` files (e.g., `/EFI/ubuntu/grubx64.efi`)
3. **UEFI** loads grubx64.efi as a UEFI application
4. **GRUB** (as UEFI app) shows menu, loads kernel

**Advantage**: GRUB is a proper file, not squeezed into 446 bytes!

### Key Differences:

| Aspect | BIOS/Legacy | UEFI |
|--------|-------------|------|
| Bootloader location | First 512 bytes + gap | ESP partition (/boot/efi) |
| Bootloader type | Machine code in MBR | .efi file (UEFI application) |
| Size limit | 446 bytes (Stage 1) | No practical limit |
| Configuration | /boot/grub/grub.cfg | Same, plus ESP |
| Boot entries | Reads MBR | Stored in NVRAM |

---

## 6. Complete Boot Sequence

### BIOS/Legacy Boot Sequence (Detailed)

```
┌─────────────────────────────────────────────────────────┐
│ 1. Power Button Pressed                                  │
│    - PSU sends electricity to motherboard                │
│    - Motherboard powers up                               │
│    - CPU starts at specific memory address               │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 2. BIOS Chip Activated                                   │
│    - Firmware code from ROM chip executes                │
│    - POST (Power-On Self-Test)                           │
│      • Check RAM (memory test)                           │
│      • Check CPU                                         │
│      • Check keyboard                                    │
│      • Initialize video card                             │
│      • Beep codes if errors detected                     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 3. BIOS Looks for Boot Device                            │
│    - Checks boot order (HDD, USB, CD, Network)           │
│    - Reads first sector (512 bytes) of boot device       │
│    - Validates boot signature (0x55AA)                   │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 4. Execute GRUB Stage 1 (446 bytes in MBR)               │
│    - Minimal code, just enough to load Stage 1.5         │
│    - Loads from post-MBR gap (sectors 1-63)              │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 5. GRUB Stage 1.5 Executes                               │
│    - Can read filesystems (ext4, NTFS, FAT32, etc.)      │
│    - Loads /boot/grub/ files from partition              │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 6. GRUB Stage 2 (Main Bootloader)                        │
│    - Reads grub.cfg configuration                        │
│    - Shows boot menu                                     │
│    - User selects operating system                       │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 7. Load Linux Kernel                                     │
│    - Reads /boot/vmlinuz-X.X.X-XX (kernel image)         │
│    - Loads into RAM                                      │
│    - Loads initramfs (initial RAM filesystem)            │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 8. Kernel Takes Control                                  │
│    - Initializes hardware (CPU, RAM, devices)            │
│    - Loads device drivers                                │
│    - Mounts root filesystem (/)                          │
│    - Starts init system (systemd)                        │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 9. Systemd Starts                                        │
│    - First process (PID 1)                               │
│    - Starts system services                              │
│    - Mounts remaining filesystems                        │
│    - Starts network, display manager, etc.               │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 10. Login Screen Appears                                 │
│     - Display manager loaded (GDM, LightDM, etc.)        │
│     - User can log in                                    │
│     - Desktop environment starts after login             │
└─────────────────────────────────────────────────────────┘
```

### UEFI Boot Sequence (Detailed)

```
┌─────────────────────────────────────────────────────────┐
│ 1. Power Button Pressed                                  │
│    - Same as BIOS mode                                   │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 2. UEFI Firmware Activated                               │
│    - More advanced than BIOS                             │
│    - 32/64-bit mode (vs 16-bit BIOS)                     │
│    - Graphical interface possible                        │
│    - Faster hardware initialization                      │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 3. UEFI Reads Boot Configuration                         │
│    - Stored in NVRAM (non-volatile RAM) on motherboard   │
│    - Boot variables:                                     │
│      • Boot0000, Boot0001, etc. (boot entries)           │
│      • BootOrder (priority sequence)                     │
│    - Each entry points to specific .efi file             │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 4. UEFI Looks for ESP (EFI System Partition)             │
│    - Searches for FAT32 partition with ESP flag          │
│    - Typically 100-550 MB in size                        │
│    - Must be formatted as FAT32 (vfat)                   │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 5. Load Bootloader from ESP                              │
│    - Reads /EFI/ubuntu/grubx64.efi (or shimx64.efi)      │
│    - Loads .efi file as UEFI application                 │
│    - Much larger than BIOS bootloader (no size limit)    │
│    - If Secure Boot: verifies digital signature          │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 6. GRUB Shows Boot Menu                                  │
│    - Can show graphical menu                             │
│    - Reads grub.cfg from ESP or /boot                    │
│    - User selects OS                                     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 7-10. Same as BIOS Mode                                  │
│    - Load kernel                                         │
│    - Kernel initializes                                  │
│    - Systemd starts                                      │
│    - Login screen                                        │
└─────────────────────────────────────────────────────────┘
```

### Boot Time Comparison:

| Stage | BIOS Time | UEFI Time |
|-------|-----------|-----------|
| Firmware initialization | 5-10 sec | 2-5 sec |
| Bootloader loading | 2-3 sec | 1-2 sec |
| Kernel loading | 10-15 sec | 10-15 sec |
| System services | 15-20 sec | 15-20 sec |
| **Total** | **32-48 sec** | **28-42 sec** |

---

## 7. Installation Process

### Proper Ubuntu 24.04 Installation (UEFI + GPT)

#### Step 1: BIOS Configuration

Enter BIOS/UEFI settings (press F2, Del, or F10 during boot):

```
Required Settings:
├─ Boot Mode: UEFI (NOT Legacy, NOT CSM)
├─ Secure Boot: Disabled (for easier installation)
├─ Fast Boot: Disabled (for compatibility)
└─ Boot Order: USB-HDD first
```

**Save and Exit**: F10

#### Step 2: Create Bootable USB

**On Windows (using Rufus)**:
```
Settings:
├─ Partition scheme: GPT
├─ Target system: UEFI (non CSM)
├─ File system: FAT32
├─ Cluster size: Default
└─ Image: ubuntu-24.04.3-desktop-amd64.iso
```

**On Linux**:
```bash
# Identify USB drive
lsblk

# Unmount if mounted
sudo umount /dev/sdX*

# Write ISO (replace sdX with your USB)
sudo dd if=ubuntu-24.04.3-desktop-amd64.iso \
        of=/dev/sdX \
        bs=4M \
        status=progress \
        conv=fsync

# Wait until complete!
sync
```

#### Step 3: Boot from USB

1. Insert USB drive
2. Restart computer
3. Press F12 or F10 for boot menu
4. Select **"UEFI: Your USB Drive Name"**
   - Must have "UEFI:" prefix
   - NOT the entry without UEFI

#### Step 4: Prepare Disk (Before Installing)

1. Choose **"Try Ubuntu"** (don't install yet)
2. Open **GParted** (search in applications)
3. Select target disk (e.g., /dev/sda)
4. **Device → Create Partition Table → GPT** ⚠️ THIS ERASES EVERYTHING!

#### Step 5: Create Partitions

Create these partitions in GParted:

```
Partition 1: EFI System Partition (ESP)
├─ Size: 512 MiB
├─ File system: fat32
├─ Label: EFI
└─ Flags: boot, esp

Partition 2: Root
├─ Size: 50000 MiB (50 GB minimum)
├─ File system: ext4
└─ Label: root

Partition 3: Swap
├─ Size: 8192 MiB (match your RAM size)
├─ File system: linux-swap
└─ Label: swap

Partition 4: Home
├─ Size: [remaining space]
├─ File system: ext4
└─ Label: home
```

Click **Apply** (green checkmark)

#### Step 6: Install Ubuntu

1. Click **"Install Ubuntu"** icon
2. Select language
3. Select keyboard layout
4. Choose **"Normal installation"**
5. **Installation type**: Select **"Something else"**

#### Step 7: Configure Partitions

```
Device      Type    Mount Point    Format?
/dev/sda1   fat32   /boot/efi      No (already formatted)
/dev/sda2   ext4    /              Yes
/dev/sda3   swap    <swap>         -
/dev/sda4   ext4    /home          Yes
```

**CRITICAL**: Set "Device for boot loader installation" to `/dev/sda` (entire disk, NOT /dev/sda1)

#### Step 8: Complete Installation

1. Select timezone
2. Create user account
3. Wait for installation (20-40 minutes)
4. Click **"Restart Now"**
5. Remove USB when prompted
6. Press ENTER
7. System reboots into Ubuntu

### Recommended Partition Sizes:

| Partition | Minimum | Recommended | Purpose |
|-----------|---------|-------------|---------|
| ESP (/boot/efi) | 300 MB | 512 MB | Bootloader files |
| Root (/) | 25 GB | 50-100 GB | System files |
| Swap | 2 GB | = RAM size | Virtual memory |
| Home (/home) | 10 GB | Remaining space | User files |

---

## 8. Troubleshooting Common Errors

### Error 1: "Cannot set EFI variable Boot0000"

**Full Error**:
```
grub-install: warning: Cannot set EFI variable Boot0000
grub-install: warning: Cannot set EFI variable BootOrder
grub-install: error: failed to register the EFI boot entry
```

**Cause**:
- Installing in UEFI mode but disk uses MBR (not GPT)
- Secure Boot blocking unsigned bootloader
- ESP partition missing or incorrectly configured
- BIOS/firmware preventing NVRAM writes

**Solutions**:

**Solution 1 - Verify GPT**:
```bash
# Check partition table type
sudo parted /dev/sda print

# Should show: "Partition Table: gpt"
# If shows "msdos" → Wrong! Need to recreate as GPT
```

**Solution 2 - Disable Secure Boot**:
1. Enter BIOS/UEFI settings
2. Security → Secure Boot: **Disabled**
3. Save and reboot

**Solution 3 - Manual GRUB Installation**:
```bash
# During installation, if GRUB fails:
# Open terminal (Ctrl+Alt+T)

# Remount EFI variables as writable
sudo mount -o remount,rw /sys/firmware/efi/efivars

# Continue installation or manually install GRUB:
sudo grub-install --target=x86_64-efi \
                  --efi-directory=/boot/efi \
                  --bootloader-id=ubuntu \
                  --recheck

# Update GRUB config
sudo update-grub
```

### Error 2: "wipefs failed to erase swap"

**Full Error**:
```
wipefs: /dev/sda5: failed to erase swap
An error occurred handling 'disk-sda'
```

**Cause**:
- Disk has bad sectors
- Previous filesystems corrupted
- Partition in use by another process

**Solutions**:

**Solution 1 - Force Wipe**:
```bash
# Boot to "Try Ubuntu"
# Open terminal

# Unmount all partitions
sudo umount /dev/sda*

# Force wipe all signatures
sudo wipefs --all --force /dev/sda

# Destroy GPT and MBR
sudo sgdisk --zap-all /dev/sda

# Create fresh GPT table
sudo parted /dev/sda mklabel gpt

# Now retry installation
```

**Solution 2 - Check Disk Health**:
```bash
# Check for bad sectors
sudo badblocks -v /dev/sda

# Check SMART status
sudo smartctl -a /dev/sda
```

### Error 3: "curtin command extract - Exit code: -11"

**Full Error**:
```
cmd-extract: FAIL: acquiring and extracting image
Exit code: -11
```

**Exit Code -11** = Segmentation Fault (memory error)

**Causes**:
- Bad RAM
- Corrupted USB drive
- Corrupted ISO image

**Solutions**:

**Solution 1 - Test RAM**:
```
1. Boot from Ubuntu USB
2. Select "Memory test (memtest86+)" from GRUB menu
3. Let it run for at least one pass
4. If errors found → Bad RAM stick
```

**Solution 2 - Recreate USB**:
```bash
# Download Ubuntu ISO again
# Verify checksum
sha256sum ubuntu-24.04.3-desktop-amd64.iso

# Compare with official checksum from ubuntu.com
# Recreate USB with verified ISO
```

**Solution 3 - Try Different USB Port**:
- Use USB 2.0 port instead of USB 3.0
- Try different USB stick
- Try different USB port on computer

### Error 4: "/efi/boot not found" (Blinking Error)

**Error**: Brief message on boot: `/efi/boot not found`

**Status**: ⚠️ **HARMLESS - IGNORE IT**

**Explanation**:
- UEFI first looks for `/EFI/BOOT/bootx64.efi` (fallback)
- Doesn't find it (or finds old entry)
- Then finds GRUB from Ubuntu boot entry
- GRUB loads successfully
- Everything works fine

**Action**: Continue normally - this is not a problem!

### Error 5: "No bootable device found" After Installation

**Symptoms**:
- Black screen after installation
- "Operating system not found"
- "No bootable device"

**Cause**: GRUB didn't install properly

**Solution - Boot Repair**:

```bash
# Re-insert Ubuntu USB
# Boot from USB
# Choose "Try Ubuntu"

# Install Boot Repair
sudo add-apt-repository ppa:yannubuntu/boot-repair
sudo apt update
sudo apt install -y boot-repair

# Run Boot Repair
boot-repair

# Click "Recommended repair"
# Follow on-screen instructions
# Reboot
```

**Alternative - Manual GRUB Reinstall**:

```bash
# Boot from USB, "Try Ubuntu"
# Open terminal

# Mount installed system
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot/efi

# Bind mount system directories
for i in /dev /dev/pts /proc /sys /run; do 
    sudo mount --bind $i /mnt$i
done

# Chroot into installed system
sudo chroot /mnt

# Reinstall GRUB
grub-install --target=x86_64-efi \
             --efi-directory=/boot/efi \
             --bootloader-id=ubuntu

# Update GRUB config
update-grub

# Exit chroot
exit

# Unmount everything
sudo umount -R /mnt

# Reboot
sudo reboot
```

### Common Installation Mistakes:

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| UEFI mode + MBR disk | GRUB install fails | Use GPT partition table |
| Legacy mode + GPT disk | Boot fails | Switch to UEFI or use MBR |
| No ESP partition | Can't boot in UEFI | Create 512MB FAT32 ESP |
| Bootloader to /dev/sda1 | Won't boot | Install to /dev/sda (whole disk) |
| ESP < 300 MB | May fail later | Use 512 MB minimum |
| ext4 for /boot/efi | UEFI can't read | Must be FAT32 (vfat) |

---

## 9. Post-Installation Setup

### Immediate Priority Tasks (First 30 Minutes)

#### 1. Verify Installation Health

```bash
# Open terminal (Ctrl+Alt+T)

# Confirm UEFI boot
[ -d /sys/firmware/efi ] && echo "✅ UEFI Mode" || echo "⚠️ Legacy BIOS"

# Check partitions
lsblk -f

# Check disk space
df -h

# Verify GRUB bootloader
sudo efibootmgr -v

# System information
uname -a
```

**Expected Output**:
- ✅ UEFI Mode
- All partitions mounted at correct locations
- Plenty of free space
- Ubuntu entry in EFI boot entries

#### 2. Update System (CRITICAL!)

```bash
# Update package lists
sudo apt update

# Upgrade all packages
sudo apt upgrade -y

# Clean up
sudo apt autoremove -y
sudo apt autoclean
```

**Time**: 10-15 minutes  
**Download Size**: 500 MB - 2 GB (on fresh install)

**What this does**:
- 🔒 Installs security patches
- 🐛 Fixes bugs
- 🆕 Updates to latest versions
- 🔧 Updates drivers

#### 3. Install Essential Build Tools

```bash
# Compiler and build tools
sudo apt install -y build-essential

# This installs:
# - gcc, g++ (C/C++ compilers)
# - make (build automation)
# - libc-dev (C library headers)
```

**Verify**:
```bash
gcc --version
make --version
```

#### 4. Install Additional Tools

```bash
# Version control
sudo apt install -y git

# Network tools
sudo apt install -y curl wget net-tools

# Text editors
sudo apt install -y vim nano

# Compression tools
sudo apt install -y unzip zip p7zip-full

# System monitoring
sudo apt install -y htop neofetch

# Python tools
sudo apt install -y python3-pip

# Useful utilities
sudo apt install -y tree screenfetch
```

#### 5. Enable Firewall

```bash
# Enable UFW (Uncomplicated Firewall)
sudo ufw enable

# Check status
sudo ufw status

# View default settings
sudo ufw status verbose
```

**Default Rules** (Ubuntu comes with safe defaults):
- ✅ Allow outgoing connections
- ❌ Deny incoming connections
- ✅ Allow established connections

### Recommended Setup (Next Hour)

#### 6. Install Graphics Drivers

**For NVIDIA Cards**:
```bash
# Check if you have NVIDIA
lspci | grep -i nvidia

# If yes, show available drivers
sudo ubuntu-drivers devices

# Install recommended driver
sudo ubuntu-drivers autoinstall

# Reboot to activate
sudo reboot
```

**For AMD/Intel Cards**:
- Usually work out-of-the-box
- Check "Software & Updates" → "Additional Drivers"

#### 7. Install Common Software

**Web Browsers**:
```bash
# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f -y
rm google-chrome-stable_current_amd64.deb
```

**Development Tools**:
```bash
# VS Code
sudo snap install code --classic

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Media & Communication**:
```bash
# VLC Media Player
sudo apt install -y vlc

# Spotify
sudo snap install spotify

# Discord
sudo snap install discord
```

#### 8. System Optimization

**Enable TRIM for SSD**:
```bash
# Check if you have SSD
lsblk -d -o name,rota
# ROTA=0 means SSD

# Enable TRIM
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
```

**Reduce Swappiness** (better RAM usage):
```bash
# Check current value
cat /proc/sys/vm/swappiness
# Default is usually 60

# Set to 10 (uses RAM more, swap less)
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

**Enable Preload** (faster app loading):
```bash
sudo apt install -y preload
# Runs automatically in background
```

---

## 10. Ubuntu Pro

### What is Ubuntu Pro?

**Ubuntu Pro** = Canonical's expanded security and support service

**Key Features**:
- Extended Security Maintenance (ESM) - 10 years of security updates
- Kernel Livepatch - apply security patches without rebooting
- FIPS & compliance tools
- Free for personal use (up to 5 machines)

### Should You Enable It?

**For Personal Desktop**: ✅ **YES - It's free and beneficial**

**Benefits**:
1. **Extended Security**: 10 years of updates (vs 5 years standard)
2. **Livepatch**: Security patches without rebooting
3. **More Coverage**: 23,000+ packages in Universe repository
4. **No Downsides**: Free tier has no performance impact

### How to Enable Ubuntu Pro

```bash
# 1. Get your token
# Visit: https://ubuntu.com/pro
# Sign in with Ubuntu One account
# Copy your free token

# 2. Check current status
pro status

# 3. Attach your machine
sudo pro attach YOUR-TOKEN-HERE

# 4. Verify services enabled
pro status

# Should show:
# esm-apps      enabled
# esm-infra     enabled
# livepatch     enabled

# 5. Check livepatch is working
sudo canonical-livepatch status
```

### What You Get (Free Tier):

| Feature | Free (Personal) | Paid |
|---------|----------------|------|
| Machines | Up to 5 | Unlimited |
| ESM Security Updates | ✅ | ✅ |
| Livepatch | ✅ | ✅ |
| 24/7 Support | ❌ | ✅ |
| Compliance Tools | Limited | Full |

### Managing Ubuntu Pro

```bash
# Check status
pro status

# Disable a service
sudo pro disable livepatch

# Detach machine
sudo pro detach

# Re-attach
sudo pro attach YOUR-TOKEN
```

---

## 11. System Maintenance

### Regular Maintenance Commands

**Update System**:
```bash
# Full system update
sudo apt update && sudo apt upgrade -y

# Alternative: unattended upgrades
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

**Clean Up**:
```bash
# Remove unused packages
sudo apt autoremove -y

# Clean package cache
sudo apt autoclean

# Remove old kernels (keep last 2)
sudo apt autoremove --purge
```

**Check Disk Space**:
```bash
# Disk usage by partition
df -h

# Directory sizes
du -sh /*

# Find large files
sudo find / -type f -size +100M -exec ls -lh {} \;
```

**Monitor System**:
```bash
# Real-time system monitor
htop

# Memory usage
free -h

# Disk I/O
iotop

# Network connections
netstat -tulanp

# System info
neofetch
```

**Check Logs**:
```bash
# View system logs
sudo journalctl -xe

# Errors only
sudo journalctl -p 3 -xb

# Failed services
systemctl --failed

# Specific service logs
sudo journalctl -u service-name
```

### Backup Strategy

**Option 1: Timeshift (System Snapshots)**:
```bash
# Install Timeshift
sudo apt install -y timeshift

# Launch and configure
sudo timeshift-gtk

# Configuration:
# - Type: RSYNC
# - Location: Separate partition or external drive
# - Schedule: Daily or weekly
# - Include /home
```

**Option 2: Déjà Dup (File Backup)**:
```bash
sudo apt install -y deja-dup

# GUI-based backup tool
# Backup your important files regularly
```

### Security Best Practices

**Firewall Rules**:
```bash
# Check current rules
sudo ufw status verbose

# Allow specific service (example)
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Deny specific port
sudo ufw deny 23/tcp

# Delete rule
sudo ufw delete allow 80/tcp
```

**Update Regularly**:
- Enable automatic security updates
- Check for updates weekly
- Reboot after kernel updates

**User Management**:
```bash
# List users
cat /etc/passwd

# Add user
sudo adduser username

# Add to sudo group
sudo usermod -aG sudo username

# Remove user
sudo deluser username
```

---

## 12. Quick Reference Commands

### System Information

```bash
# Operating system info
lsb_release -a

# Kernel version
uname -r

# Hardware info
lscpu              # CPU
lsmem              # Memory
lspci              # PCI devices
lsusb              # USB devices
lsblk              # Block devices (disks)

# System info (pretty)
neofetch
screenfetch
```

### Package Management

```bash
# Update package lists
sudo apt update

# Upgrade packages
sudo apt upgrade

# Install package
sudo apt install package-name

# Remove package
sudo apt remove package-name

# Search for package
apt search keyword

# Show package info
apt show package-name

# List installed packages
apt list --installed

# Clean up
sudo apt autoremove
sudo apt autoclean
```

### Disk & Filesystem

```bash
# Disk usage
df -h

# Directory size
du -sh /path/to/directory

# List block devices
lsblk
lsblk -f    # with filesystems

# Partition info
sudo fdisk -l
sudo parted -l

# Mount partition
sudo mount /dev/sda1 /mnt

# Unmount
sudo umount /mnt

# Check filesystem
sudo fsck /dev/sda1

# Disk SMART status
sudo smartctl -a /dev/sda
```

### Process Management

```bash
# List processes
ps aux
ps aux | grep process-name

# Interactive process viewer
htop
top

# Kill process
kill PID
killall process-name
sudo pkill process-name

# Process tree
pstree

# Find process using port
sudo lsof -i :80
sudo netstat -tulpn | grep :80
```

### Network

```bash
# Network interfaces
ip addr
ifconfig

# Network connections
netstat -tulanp
ss -tulanp

# Test connectivity
ping google.com

# DNS lookup
nslookup google.com
dig google.com

# Download file
wget URL
curl -O URL

# Check open ports
sudo netstat -tulpn
sudo ss -tulpn
```

### File Operations

```bash
# Copy
cp source destination
cp -r folder/ destination/    # recursive

# Move/rename
mv source destination

# Remove
rm file
rm -r folder/    # recursive
rm -rf folder/   # force

# Create directory
mkdir dirname
mkdir -p path/to/nested/dir

# Change permissions
chmod 755 file
chmod -R 755 directory/

# Change owner
sudo chown user:group file
sudo chown -R user:group directory/

# Find files
find /path -name "filename"
find /path -type f -name "*.txt"
locate filename

# Search in files
grep "pattern" file
grep -r "pattern" directory/
```

### User Management

```bash
# Current user
whoami

# Switch user
su username
sudo -u username command

# Add user
sudo adduser username

# Delete user
sudo deluser username

# User groups
groups username
id username

# Add to group
sudo usermod -aG groupname username

# Change password
passwd
sudo passwd username
```

### Service Management (systemd)

```bash
# Start service
sudo systemctl start service-name

# Stop service
sudo systemctl stop service-name

# Restart service
sudo systemctl restart service-name

# Enable at boot
sudo systemctl enable service-name

# Disable at boot
sudo systemctl disable service-name

# Check status
sudo systemctl status service-name

# List all services
systemctl list-units --type=service

# View logs
sudo journalctl -u service-name
```

### Boot & GRUB

```bash
# Update GRUB config
sudo update-grub

# Reinstall GRUB
sudo grub-install /dev/sda

# Edit GRUB config
sudo nano /etc/default/grub
# Then: sudo update-grub

# View boot entries (UEFI)
efibootmgr -v

# Add boot entry
sudo efibootmgr -c -d /dev/sda -p 1 -L "Ubuntu" \
  -l "\EFI\ubuntu\grubx64.efi"

# Change boot order
sudo efibootmgr -o 0000,0001,0002
```

### Useful Aliases

Add these to `~/.bashrc`:

```bash
# Edit bashrc
nano ~/.bashrc

# Add at the end:
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'
alias ll='ls -alFh'
alias ..='cd ..'
alias ...='cd ../..'
alias ports='netstat -tulanp'
alias meminfo='free -h'
alias diskinfo='df -h'
alias please='sudo'

# Save and reload
source ~/.bashrc
```

---

## Glossary

**BIOS**: Basic Input/Output System - firmware from 1975, limited features  
**UEFI**: Unified Extensible Firmware Interface - modern firmware replacement  
**CSM**: Compatibility Support Module - BIOS emulation in UEFI  
**Firmware**: Software stored in hardware chips on motherboard  
**MBR**: Master Boot Record - old partitioning scheme (max 2 TB)  
**GPT**: GUID Partition Table - modern partitioning (max 9.4 ZB)  
**ESP**: EFI System Partition - FAT32 partition storing bootloaders  
**Bootloader**: Software that loads OS (GRUB for Linux)  
**GRUB**: GRand Unified Bootloader - Linux bootloader  
**Partition**: Division of hard disk into separate sections  
**Mount Point**: Directory where partition is accessed (/boot/efi, /)  
**Root (/)**: Main partition containing OS files  
**Swap**: Virtual memory partition  
**FAT32/vfat**: Filesystem required for ESP (UEFI can only read FAT32)  
**ext4**: Linux filesystem for root and home partitions  
**Kernel**: Core of operating system (Linux kernel)  
**initramfs**: Initial RAM filesystem loaded during boot  
**systemd**: Init system - first process started by kernel  
**NVRAM**: Non-volatile RAM - stores UEFI boot configuration  

---

## Troubleshooting Decision Tree

```
Installation Failed?
├─ GRUB installation error?
│  ├─ "Cannot set EFI variable"
│  │  ├─ Check: Boot mode = UEFI?
│  │  ├─ Check: Disk = GPT?
│  │  ├─ Check: ESP partition exists?
│  │  └─ Try: Disable Secure Boot
│  │
│  └─ "failed to register EFI boot entry"
│     └─ Try: Manual GRUB install (see section 8)
│
├─ Disk/partition error?
│  ├─ "wipefs failed"
│  │  └─ Try: Force wipe (wipefs --all --force)
│  │
│  └─ "Cannot create filesystem"
│     └─ Check: Disk health (badblocks, smartctl)
│
├─ Extraction error?
│  ├─ "Exit code: -11" (segfault)
│  │  ├─ Try: Test RAM (memtest86+)
│  │  ├─ Try: Different USB port
│  │  └─ Try: Recreate USB
│  │
│  └─ "curtin extract failed"
│     └─ Try: Verify ISO checksum
│
└─ Won't boot after install?
   ├─ "No bootable device"
   │  └─ Solution: Boot Repair
   │
   ├─ Boots to USB again
   │  └─ Solution: Remove USB, check boot order
   │
   └─ GRUB command line
      └─ Solution: Manual boot (see section 8)
```

---

## Resources & Documentation

### Official Documentation

- Ubuntu Official Docs: https://help.ubuntu.com/
- Ubuntu Wiki: https://wiki.ubuntu.com/
- UEFI Specification: https://uefi.org/specifications
- GRUB Manual: https://www.gnu.org/software/grub/manual/

### Useful Commands Reference

- `man` pages: `man <command>` (e.g., `man fdisk`)
- Ubuntu Manpage Repository: http://manpages.ubuntu.com/
- TLDR pages: `tldr <command>` (simplified man pages)

### Community Support

- Ubuntu Forums: https://ubuntuforums.org/
- Ask Ubuntu: https://askubuntu.com/
- Reddit: r/Ubuntu, r/linux4noobs
- Ubuntu IRC: #ubuntu on Libera.Chat

---

## Author's Installation Summary

**System Specs**:
- Computer: Acer PC
- BIOS: Intel Corp. BLH6710H.86A.0146.2011.1222.1415 (2011)
- BIOS Features: UEFI supported, dated firmware

**Issues Encountered**:
1. ❌ Initial installation with MBR → GRUB errors
2. ❌ "Cannot set EFI variable Boot0000"
3. ❌ "wipefs failed" errors
4. ❌ "curtin extract" segmentation fault

**Solution Applied**:
1. ✅ Recreated USB with GPT partition scheme
2. ✅ Booted in UEFI mode (not Legacy)
3. ✅ Disabled Secure Boot in BIOS
4. ✅ Created proper GPT partition table
5. ✅ Manual partition setup:
   - /dev/sda1: 512 MB, vfat, /boot/efi
   - /dev/sda2: 50 GB, ext4, /
   - /dev/sda3: 8 GB, swap
   - /dev/sda4: remaining, ext4, /home
6. ✅ Set bootloader to /dev/sda (whole disk)

**Result**: ✅ **Successful Installation & Boot**

**Key Lesson**: UEFI mode requires GPT partitioning and proper ESP partition. Mismatch between boot mode and partition scheme causes installation failure.

---

## Revision History

**Version 1.0** - February 11, 2026
- Initial comprehensive documentation
- Covered: Hardware layer through post-installation
- Based on real installation experience
- Ubuntu 24.04.3 LTS on UEFI system

---

*This document is maintained as a personal reference. Feel free to update with your own experiences and solutions.*

**Last Updated**: February 11, 2026
