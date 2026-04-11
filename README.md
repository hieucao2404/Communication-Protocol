

# Communication Protocols: UART, SPI, and I²C

A comprehensive implementation and guide for standard serial communication protocols used in embedded systems. This repository includes Verilog implementations for UART, SPI, and I²C

---

## 📌 Introduction

Communication protocols define the rules and methods that electronic systems use to exchange data. In digital systems, these protocols ensure that data is transmitted accurately, efficiently, and in a synchronized manner between different components.

These are all **serial communication protocols**, meaning data is transmitted one bit at a time over a limited number of wires.

### 🧠 Basic Concept
A communication protocol typically defines:
* **Data format** → how bits are structured
* **Timing** → when data is transmitted
* **Control signals** → how devices coordinate
* **Transmission method** → synchronous or asynchronous

Protocols allow different hardware modules (e.g., microcontrollers, sensors, memory devices) to communicate in a standardized way.



## 🔌 Protocols Implemented

### 🔹 UART (Universal Asynchronous Receiver/Transmitter)
* **Type:** Asynchronous communication
* **Clock:** No shared clock signal
* **Wires:** 2 (TX, RX)
* **Features:**
    * Data is framed with start and stop bits.
    * Baud rate must be agreed upon beforehand.
    * Simple and widely used for debugging and device communication.
* **Applications:** Serial console communication, GPS modules, Bluetooth modules.

### 🔹 SPI (Serial Peripheral Interface)
* **Type:** Synchronous communication
* **Clock:** Shared clock (SCLK)
* **Wires:** 4 (MOSI, MISO, SCLK, SS)
* **Features:**
    * Full-duplex communication (simultaneous send/receive).
    * High-speed data transfer.
    * Master-slave architecture.
* **Applications:** Flash memory, ADC/DAC, Displays.

### 🔹 I²C (Inter-Integrated Circuit)
* **Type:** Synchronous communication
* **Clock:** Shared clock (SCL)
* **Wires:** 2 (SDA, SCL)
* **Features:**
    * Supports multiple masters and slaves.
    * Uses addressing for device selection.
    * Half-duplex communication.
* **Applications:** Sensors (temperature, accelerometer), EEPROM, Real-time clocks.

---

## ⚖️ Comparison Overview

| Feature | UART | SPI | I²C |
| :--- | :--- | :--- | :--- |
| **Clock** | ❌ No | ✅ Yes | ✅ Yes |
| **Speed** | Low | High | Medium |
| **Complexity** | Simple | Moderate | Moderate |
| **Wires** | 2 | 4 | 2 |
| **Communication**| Full-duplex | Full-duplex | Half-duplex |

---

## 🎯 Applications in System Design

These protocols are commonly used to:
1.  Interface microcontrollers with peripherals.
2.  Enable communication between chips.
3.  Transfer sensor and control data.

*Note: They often work alongside system-level bus architectures (e.g., AMBA) inside a complete System on Chip (SoC).*


## 💡 Summary

UART, SPI, and I²C are fundamental serial communication protocols that enable reliable data exchange between devices. They differ in complexity, speed, and hardware requirements, but all serve as essential building blocks in embedded systems and digital design. Understanding these protocols is a key step toward mastering hardware communication and SoC integration.

---

## 📄 License
Distributed under the MIT License. See `LICENSE` for more information.
```
