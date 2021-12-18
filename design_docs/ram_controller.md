# RAM Controller

## Purpose
Belief is that the instruction RAM will have two competing modules: BITS_CORE and RAM_LOADER.  Need to be able
to take both sets of inputs from each module, give priority to one of the modules for their operation.

## Design Notes
### Possible Inputs
* clk
* resetB
* core_enable : Enable bit from the Core
* core_write: Is this a write or read: write(1)/read(0)
* core_addr : Which address is the CPU accessing
* core_wdata: Write data from the core (this might not be needed)
* ram_loader_enable: Enable bit form the RAM loader
* ram_write: Write/Read signal
* ram_addr: Which address is the RAM Loader writing to
* ram_wdata: RAM_Loader Write Data

### Possible Outputs
* rdata: Read data from the read

### Priority
* If BITS_CORE and RAM_LOADER both have their enable and write set to 1 in the same clock, core has precedence.
