# 🔐 Ring Oscillator Physical Unclonable Function (RO-PUF)

A complete LTspice + MATLAB implementation and analysis of a **MUX-based Ring Oscillator Physical Unclonable Function**.  
This project evaluates process-variation-dependent ROs, generates challenge–response pairs, computes PUF metrics, and analyzes frequency behavior across different RO array sizes.

---

## 🚀 Overview

Physical Unclonable Functions (PUFs) use inherent manufacturing variations in CMOS devices to generate **unique, unclonable digital fingerprints**.  
This project focuses on:

- Designing **3-stage Ring Oscillators** using LTspice  
- Implementing **4-RO, 8-RO, 16-RO, and 32-RO** PUF architectures  
- Selecting oscillator pairs using a **dual-MUX design**  
- Extracting frequencies and generating CRPs  
- Evaluating PUF quality metrics:
  - **Uniformity**
  - **Uniqueness (via W/L scaling)**
  - **Reliability** *(optional – will add later)*

The repository supports ongoing research toward publication.

---

## 🧠 Architecture

Basic PUF flow:

Challenge → MUX A → RO_A ----
→ Frequency Comparison → Response Bit
Challenge → MUX B → RO_B ----/


- Variations in transistor parameters (Vth, W/L, mobility, etc.) cause each RO to oscillate at slightly different frequencies.
- The comparator output forms the final **PUF response bit**.

---

## 🛠 Tech Stack

| Purpose | Tools Used |
|--------|------------|
| Circuit design & simulation | **LTspice** |
| Frequency extraction | **MATLAB** |
| PUF metric computation | MATLAB |
| Plotting results | MATLAB |
| Documentation | Markdown / PDF (research paper upcoming) |

---

## 📂 Repository Structure

Ring-Oscillator-PUF/
│
├── LTspice/ # RO circuit files (asc)
│ ├── 4-ro.asc
│ ├── 8-ro.asc
│ ├── 16-ro.asc
│ └── 32-ro.asc
│
├── Matlab/ # MATLAB analysis scripts
│ ├── FRE.m # Frequency extraction
│ ├── Power.m # Power estimation
│ ├── wL.m # W/L variation modelling
│ ├── uniformity1.m # Uniformity metric
│ └── ...
│
├── Results/ # To be filled with CSVs, plots, CRPs
│
└── README.md



---

## 📊 Main Analysis

### **1️⃣ Frequency Extraction**
- Simulate ROs in LTspice
- Export voltage waveform
- Calculate oscillation frequency using `FRE.m`

### **2️⃣ PUF Metric Evaluation**
- **Uniformity**: average fraction of '1's in response  
- **Uniqueness**: compare multiple chip instances by W/L scaling  
- **Power**: dynamic + leakage estimation

Example Expected Trend (from research draft):

| RO Count | Uniformity |
|----------|------------|
| 4        | ~44% |
| 8        | ~49% |
| 16       | ~51% |
| 32       | ~50% |

---

## 📈 Running the Code

### ▶ LTspice
Open any `.asc` file → run transient simulation → export waveform.

### ▶ MATLAB
Run scripts:

FRE.m → extract frequencies
uniformity1.m → compute uniformity
wL.m → simulate multiple chip instances
Power.m → compute power



Place your exported LTspice data files in `Matlab/` or `Results/`.

---

## 📄 Research Paper

The research paper for this project will be added soon:

Docs/Ring_Oscillator_PUF_Final.pdf

yaml
Copy code

---

## 🧩 Future Enhancements

- Add **FPGA implementation**
- Add **environmental variation tests** (temp/voltage)
- Add **noise-resilience analysis**
- Improve MATLAB visualization
- Publish official paper and CRP dataset

---

## 👤 Author

**Kunal Narang**  
Electronics and Communication Engineering (ECE)  
IIIT Bangalore  
📧 Kunal.Narang@iiitb.ac.in  
🔗 GitHub: https://github.com/Redwing47  

---

## 📜 License

This project is licensed under the **MIT License**.
