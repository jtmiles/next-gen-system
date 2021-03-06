# Open Instruments Whitepaper Extended version,

__Note:__ Contains interface specification overview and progress report.

## Overview

This whitepaper outlines an instrumentation system for neuroscience (and other
fields) that makes full use of existing technologies and industry standards to
deliver the ver high performance levels and modular design. The system can be
used as a platform for existing and future data sources, reducing development
overhead, while providing increases in system performance performance and
interoperability. This will also result in extendability to future interface
technology generations without the need for device specific re-engineering.

![Example hardware configuration of a Open Instruments system with three
connected breakout boards. In addition to the DIO board that provides the
electrical connections between the FPGA and the breakout boards, a 3rd party
FMC board is shown, connected to the FPGA through the second FMC
connector.](imgs/system_overview.png)

_Example hardware configuration of a Open Instruments system with three
connected breakout boards. In addition to the DIO board that provides the
electrical connections between the FPGA and the breakout boards, a 3rd party
FMC board is shown, connected to the FPGA through the second FMC connector._

We have built a prototype system based on parts of these specifications that
delivers full use of the PCIe bus (12 Gbps throughput currently, up to 100 Gbps
with other FPGA boards). This provides adequate bandwidth for above 10,000
channels sampled at 30 kHz, and low latency of less than 100 μs round trip
between the host PC's main RAM allowing high level languages and libraries to
be used for closed-loop experiments. The same system potentially could also be
used for dynamic clamp applications using a real-time OS, delivering less than
10 μs loop capability.

The __Open Instruments__ standard does not specify or constrain the design of
either the data sources, nor the software used for data acquisition, but
specifies a flexible interconnect between the two. 

To implement a system based on new type of probe, only two or three components
need to be designed: 

  1. A hardware interface that connects directly to FPGA pins trough a
     standardized high-speed digital interconnect via generic 68-pin VHDCI
     connectors and cables that are connected to the FPGA boards via the
     ubiquitous FMC connectors and an intermediate DIO board as mechanical
     interconnect.
  1. A firmware module for the FPGA that drives this hardware, but does not
     need to be able to communicate with the host PC, or be developed with
     drivers in mind.
  1. (Optional) A software that communicates with this hardware through the
     open instruments AI that provides a generic interface to the hardware via
     data transfers and device registers, and can be used with no knowledge of
     the underlying interconnect (PCIe, USB, Ethernet).

By removing and standardizing the intermediate components of hardware-software
interfaces, the development effort required for this is vastly reduced, and
different data sources can be operated together in one system.

## Progress & Proof of Principle

The main design constraints behind this specification are high throughput and
low latency. In terms of throughput, most current interfaces can achieve or
exceed 10 Gbs. [PCIe](https://en.wikipedia.org/wiki/PCI_Express), which is used
as the basic for almost all other existing interfaces can currently achieve
around ~100 Gbs, which far exceeds the bandwidth required for any current or
mid-term electrophysiology applications, but could be useful eventually. By
contrast, latency varies widely across interfaces, and PCIe can achieve far
shorter closed-loop delays than any other mainstream interface for commodity
PCs.

![Overview of latencies across hardware interfaces. Histograms reflect measured
latencies, bar plots reflect estimates.](imgs/latencies_log_scale.png)

_Overview of latencies across hardware interfaces. Histograms reflect measured
latencies, bar plots reflect estimates._

We have designed a prototype system based on a PCIe FPGA evaluation card
(latency measurements are shown above) and used it to verify the feasibility of
low-latency feedback on commodity PC hardware. 

In addition to verifying the feasibility of low-latency feedback via PCIe, we
tested the computational tractability of closed-loop experiments on a commodity
PC. By performing low-latency computations in a separate real-time thread, we
were able to detect spikes and perform significant additional computations on
each of 512 channels while reacting to spikes in less than 100 μs.

## Specification Overview

![Overview of the components and interfaces of the system. Only the
interconnect infrastructure between the data source and the software are
defined by the open instruments
standard.](imgs/hardware_architecture_sketch.png)

_Overview of the components and interfaces of the system. Only the interconnect
infrastructure between the data source and the software are defined by the open
instruments standard._

### Interface for Hardware Modules

This specification does not apply any constraints to the data source other than
the presence of a standardized VHDCI connector. This makes it possible for
almost any hardware to integrate into the system with minimal engineering
effort, and without sacrifices in performance.

Most pins on the cable are connected directly to the FPGA, arranged in the
following manner

  - 21 LVDS pairs that can be used in any way (including as 42 non-LVDS
    signals, depending on the device-specific firmware). 
  - 2 pins are dedicated to an I2C bus to obtain daughter board IO IDs and
    metadata,
  - 4 undefined pins for that can be used in any way
  - 20 Power supply pins (12 ground pins, 4 +5V pins, and 4 +12V pins) ground
    and VCC. 

See google [doc of pin out specification] (https://docs.google.com/spreadsheets/d/18WfmbLGt8bGUUdksKp6AKA_wMX2SJ3Tndin-nnEgUCs/edit#gid=438515320)

VHDCI cables are very widely available in low cost or very high quality
variants, and are very robust and rated for many cycles. Examples of hardware
modules are:

  - A simple Analog/Digital front-end with ADCs DACs and line receivers and
    drivers for digital input/output. This would also be the only piece of
    hardware needed to use the system in a dynamic clamp whole-cell experiment.
  - An interface to Intan headstages.
  - A digital interface connecting to high density CMOS probes.

### Hardware: DIO Card & FPGA Evaluation Card

There are only two hardware components of the system that are defined by this
specification:

  - An off-the shelf FPGA eval board (Kintex 7). This board hosts the FPGA that
    holds the device-specific firmware, as well as a piece of firmware that
    connects to the software, via the open instruments API. Exchanging this
    board for other FPGA carrier boards is relatively simple because we use
    industry standard FMC connectors to connect to the DIO board.
  - A very simple DIO card that directly connects pins on the FPGA to
    connnectors on the back of the host PC (via a FMC connector on the FPGA
    carrier board). The main role of this card is to provide direct electrical
    access to the pins of the FPGA. The FPGA pins on the FMC connector are
    broken out into 4 VHDCI connectors.

### Interfaces for Firmware Module

The open instruments standard does not specify the firmware / IP cores used to
interact with specific data sources. It does however provide a standardized
interface to a piece of firmware / IP core on the FPGA that provides a
flexible, bidirectional interconnect to the software. This minimizes
development efforts for new data sources by eliminating the redundant task of
driver and API development.

Examples of data source specific IP are:

  - An Analog/Digital IO driver that connects to a Analog/Digital front-end,
    handling the ADCs etc.
  - An Intan firmware IP core that replicates the existing Intan Rhythm
    firmware. 
  - A generic SPI interface module that can connect to data sources that
    already include an FPGA that can implement an SPI interconnect. This could
    for instance allow electrophysiology systems to be extended with very low
    latency capability.

### Software Interface

This specification does not impose any limitations on the software used to
operate the hardware modules, but specifies a very flexible interface by which
the software communicates with the hardware. This means that both the IP cores
and the software can be independent of the actual interconnect implementation.

Every communication between the software and the hardware can be cast as either
_(i)_ a read or write from/to a register (of arbitrary size) on the hardware,
for example for configurations, state read-outs etc. or _(ii)_ a read or write
from/to one of possibly many streams, for example for neural data or control
signal streaming.

The API also specifies how devices connected to the FPGA can be discovered and
identified by software, and keeps track of connection status.

## Next steps

Even though we have developed most of the specification and implemented a
working prototype system, there are a number of tasks that we will need to
complete in order to make the system practically functional and usable by other
developers:

  - Design and fabricate the DIO card to interface hardware modules to the
    FPGA.
  - We will also develop two very simple core hardware modules: An Intan
    amplifier chip interface identical to current basic intan systems, and an
    Analog/Digital front-end.
  - Implement the open instruments API around an existing PCIe firmware and
    driver, possibly using the existing xillybus driver as a short-term
    solution, and port some existing software packages (Bonsai, Open Ephys) to
    use the API to acquire neural data.
  - Implement the generic digital interconnect to commercial systems and
    implement some basic data streaming functionality.
  - We will need to move the PCIe interface to a firmware and driver that do not impose licensing restrictions. This is especially important for use of the system as component of commercial systems.
