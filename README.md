## Simulating VHDL Components Using ModelSim

This guide provides step-by-step instructions on how to simulate a collection of VHDL components using ModelSim. The components in this guide represent a CPU system, and we will simulate its behavior for a specified time duration.
Prerequisites

    ModelSim software installed on your computer.
    The VHDL design files for the CPU system.

## Simulation Steps

    ### Create a ModelSim Project:

    Open ModelSim and create a new project.

    ### Add Components to the Project:

    Within the ModelSim project, add the VHDL files as design units

    ### Compile VHDL Files:

    Compile each of the individual VHDL files added to the project. This step ensures that the design units are synthesized and ready for simulation.

    ### Start Simulation:

    Click on the "Simulate" option in the menu bar of ModelSim.

    ### Select the Testbench:

    In the simulation window, locate the "work" library and find the Corcuera_CPUtb.vhd testbench. This testbench will serve as the starting point for our simulation.

    ### Run the Simulation:

    Drag and drop the Corcuera_CPUtb testbench into the waveform window. This action will open up the simulation waveform view.

    ### Configure Simulation Time:

    In the waveform view, locate the time scale. Set the simulation time to 570 ns. This value determines how long the simulation will run.

    ### Run the Simulation:

    Start the simulation by clicking the "Run" button. ModelSim will simulate the behavior of the CPU system based on the provided VHDL components.

    ### Observe the Results:

    As the simulation runs, you'll see waveforms and signal traces in the waveform view. These traces represent the behavior of various signals within the CPU system components.

    ### End Simulation:

    Once the simulation completes (reaches 570 ns), you can analyze the behavior of the CPU system during this time period.

Conclusion

This guide has walked you through the process of simulating a set of VHDL components representing a CPU system using ModelSim.
By following these steps, you can gain insights into the behavior and interactions of the various components within the system. 
This simulation-based approach is invaluable for verifying the correctness and functionality of complex digital designs before physical implementation.
