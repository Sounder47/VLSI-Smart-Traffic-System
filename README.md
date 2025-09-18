# Smart Traffic Light Controller – VLSI Project

## 📌 Overview
This project implements a **Smart Traffic Light Controller** using **Verilog HDL** on FPGA.  
It uses a **Finite State Machine (FSM)** to control North-South and East-West lanes, supports **pedestrian requests**, and adapts to **traffic density**.

## ⚙️ Features
- FSM-based traffic light sequencing (Green → Yellow → Red).
- Dynamic green extension based on traffic density.
- Safe pedestrian walk signal integration.
- Synthesizable on Xilinx FPGA boards (Basys3 / Nexys A7).
- Fully verified with a Verilog testbench.

## 🗂️ Repository Structure
- `src/` → Verilog source files.
- `tb/` → Testbenches for simulation.
- `docs/` → FSM diagram and documentation.

## ▶️ How to Run
1. Open the project in **Xilinx ISE / Vivado**.
2. Add `traffic_light_controller.v` (source).
3. Add `tb_traffic_light.v` (testbench).
4. Run simulation → Observe waveforms and monitor logs.
5. Synthesize & implement on FPGA board for real-time demo.

## 📊 FSM State Diagram
(Add an image later showing NS Green → NS Yellow → All Red → EW Green → ...)

## 🔧 Tools Used
- Language: **Verilog HDL**
- Simulator: **ModelSim / Vivado Simulator**
- FPGA: **Xilinx Basys3 / Nexys A7**

## 📜 License
This project is open-source under the MIT License.
