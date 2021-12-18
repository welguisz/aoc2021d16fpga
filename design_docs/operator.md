# Operator Module

## Purpose
The purpose of the operator module is take the operator packet code, input, and do the said operation.

## Design Notes

### Size of the Operand Class
* Configurable by Module Instance Variable `NUMBER_OF_BITS`. Default value is `32`.

### Possible Inputs
* clk : clock for the registers
* resetB: reset signal to reset all internal registers to a known good state.
* operandA: Operand A for the operation.
* operandB: Operand B for the operation.
* use_store_value: Use the store value, along with other selected inputs
* user_operandA: use operandA during execution
* user_operandB: use operandB during execution
* execute: Execute the desired operation
* operation: Selected Operation
* 
### Possible Outputs
* value: Value that is currently stored in the Operand Class

