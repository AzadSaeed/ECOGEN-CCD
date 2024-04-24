
# ECOGEN-CCD: A computational framework for economic feasibility of generator and storage systems through CCD

Solve control co-design or capacity and dispatch optimization problems for various generator and storage technologies using a net present value objective function. The resulting dynamic optimization problem is solve in [DTQP software](https://github.com/danielrherber/dt-qp-project) using direct transcription.
  

Three case studies are currently available with hourly price signals:

* A natural gas combined cycle power plant with carbon capture and storage and thermal storage systems
* A wind farm with a battery energy storage systems
* A nuclear power plant with hydrogen production and storage facility   


![readme image](Utility/Readme_Fig.svg "Readme Image")

## Install
* Download and extract the project files
* Run INSTALL_Submission.m in MATLAB and ensure that all tests for inclusion of the required files and packages have passed
* MATLAB version R2023b is only necessary for the creation of donut charts.  

```matlab
INSTALL_Tool
```

A good place to start is to open Main. In this script, you can select the case study of interest, then open ProblemOptions.m and select the time horizon.

To investigate a new generator and storage system, you need to first identify the type of storage (primary, electrical, or tertiary). Then define all the relevant price signals, load functions, and cost/economic parameters and prescribe them using ProblemOptions.m structure. You can simply add new elements to the optimization problem for any specific case using the DTQP_setup_IES function. 


## Citation
Please cite the following articles if you use the toolbox: 

* S Azad, Z Gulumjanli, DR Herber. **A general framework for supporting economic feasibility of generator and storage energy systems through capacity and dispatch optimization**. (submitted to) ASME 2024 International Design Engineering Technical Conferences, DETC2024-142667, Aug. 2024.[[PDF]](https://arxiv.org/pdf/2404.14583.pdf)
 