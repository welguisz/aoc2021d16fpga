#Memory Map

## Start BITS Machine
Addr: 0x00

| 31-9| 8         | 7-1       | 0     |
|-----|-----------|-----------|-------|
|---|RO|---|WO|
| RSVD  | DONE| RSVD| START |

_Note_: By writing a 1 to `START`, it will clear the `DONE` bit and clear `VERSION SUM` and `BITS VALUE`

## Number of bits in BITS Packet
Addr: 0x04

|31-16|15-0|
|-----|----|
|---|RW|
|RSVD|Number of bits in packet|

## Version Sum
Addr: 0x08
|31-16|15-0|
|-----|----|
|----|RO|
|RSVD|Version Sum|

## BITS Value (Most Significant Word)
Addr: 0x10

|31-0|
|----|
|RO|
|Most significant word for BITS value (Bits 63-32)|

## BITS value (Least Significant Word)

Addr: 0x14

| 31-0                                              |
|---------------------------------------------------|
| RO                                                |
| Least significant word for BITS value (Bits 31-0) |
