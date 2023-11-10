# ThermostatHouseSystem

## Overview

This Git repository contains the Verilog code for a digital thermostat system designed for the BASYS3 FPGA board. The system simulates the behavior of a house thermostat with additional features, including multiple areas (main manor and wine cellar) and user-configurable settings.
System Description
Basic Functionality

The thermostat system operates with three temperatures: desired temperature, current room temperature, and exterior temperature. Users can configure the desired temperature using five switches (0-31°C), and the selection is confirmed by pushing the CONF button. External temperature is determined by two switches for season and time, influencing the system as per predefined values (see Table 1 - Exterior Temperature).

The INC and DEC push buttons allow users to adjust the desired temperature during system operation. Another switch indicates if windows are open or closed, affecting the room temperature based on the temperature difference.

The thermostat control system automatically adjusts the air conditioning/heat pump, impacting the room temperature as described in section 4 of the system requirements. LED indicators and a 7-segment display show the system's state and relevant information.

## Advanced Functionality

The system has been extended to include multiple areas: main manor and wine cellar. The owner can configure desired temperatures for each area using an ID switch. The thermostat control system in the main manor is activated by setting the START switch to 1. The system remains non-operative until all areas are properly configured. The INC and DEC buttons, in combination with the ID switch, allow the owner to modify temperatures in different areas.

## Repository Structure

    /code: Contains Verilog source code files for the thermostat system.
    /docs: Includes the project report documenting functional, technical, and demonstration aspects of the system.
    /testbench: Holds testbench files


## How to Use

    Clone the repository to your local machine.
    Navigate to the /code directory.
    Upload the Verilog files to your BASYS3 FPGA board using your preferred synthesis tool.
    Refer to the documentation in the /docs directory for detailed information on system functionality, technical aspects, and demonstration instructions.
