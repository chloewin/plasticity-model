# plasticity-model
model for synaptic facilitation, depression

I created a mechanistic model for synaptic facilitation and synaptic depression based on equations described in [1]. This was inspired by experiments I conducted in Neusci 301 (Introduction to Cellular and Molecular Neuroscience) at the University of Washington. In these experiments, synaptic transmission was studied at the crayfish superficial flexor muscles and associated innervation. In this model, we recorded from presynaptic cells in a nerve and postsynaptic cells in the muscle. We were able to stimulate the nerve at various frequencies, enabling us to study the effects of high frequency stimulation on synaptic strength and hence synaptic plasticity. We observed mixed plasticity (both facilitation and depression occurring simultaneously) for higher frequency stimulation, which inspired me to computationally explore mechanisms behind these phenomena and explore whether mixed plasticity could be modeled. Several of our experimental files are included here.

---

**Background**

Communication in the brain takes place at synapses, tiny gaps between neurons. In these synapses, neurotransmitters are released from _presynaptic_ terminals to _postsynaptic_ structures in _vesicles_ (packets). Neurotransmitters mediate electric responses in the postsynaptic neuron. Synaptic activity often leads to changes in synaptic strength (how successful the presynaptic cell is at causing an electric response in the postsynaptic cell.) This phenomenon is known as synaptic plasticity. Synaptic plasticity can be either longterm or shortterm.

There are several forms of short-term synaptic plasticity. One is synaptic facilitation, the strengthening of a synapse. One proposed mechanism for this is buildup of calcium in the presynaptic cell [1]. Synaptic depression, another form of short-term plasticity, refers to the weakening of a synapse. One proposed mechanism of this is the depletion of vesicles [1]. These phenomena can occur simultaneously and is then referred to as mixed plasticity.

---

**Model SetUp**

These files describe and explore a model for simultaneous synaptic facilitation and depression based on the above mechanisms using equations derived from [1]. The following are the mechanisms that are modeled over time.
- Calcium buffering: calcium (``Ca``) is constantly being removed from the cell following exponential decay with a certain time constant and a starting calcium concentration as well as a constant influx modeled by a rate.
- Vesicle release: vesicle release probability (``prel``) depends on calcium concentration. This was modeled as either a sigmoid function of calcium concentration or using the Hill equation (this was harder to optimize.)
- Releasable vesicles: the ratio of vesicles that are releasable (``rrel``) is modeled as increasing based on a recovery time constant and decreasing based on the exocytosis rate.
- Postsynaptic voltage: the postsynaptic voltage (``psp``) is modeled as a constant exponential decay in addition to an increase when the presynaptic cell spikes. The increase is determined by scaling the baseline voltage by the number of vesicles being released.

---

**Files**
***Code Files***
- ``plasticity_control.m``: This code explores the data collected under control conditions for each stimulation frequency. Variables listed can be changed to explore the model's fit of the collected data. The postsynaptic voltage predicted by the model and collected in the experiments are plotted against each other. Additionally, for the sake of exploration, the probability of release, ratio of readily releasable vesicles, and calcium concentration predicted by the simulation are plotted over time for each stimulation frequency. The documentation for this code walks through the equations used for the simulation. A reading of [1] may also help.
- ``fit_psp_amps.m``: This is my initial attempt at using MATLAB's fmincon function to fit the parameters of the synaptic plasticity model to the experimental data.
- ``generate_pastic_voltage.m``: This function can be used to simulate the postsynaptic voltage produced given synaptic plasticity parameters.
- ``predict_psp_amps.m``: This function can be used to simulate the amplitudes of postsynaptic potentails produced given synaptic plasticity parameters.
- ``calc_psp_amps.m``: This general-purpose function can be used to determine the amplitudes of peaks in voltage (in this case used to determine the amplitude of postsynaptic potentials given the raw postsynaptic voltage trace.)
- ``calc_psp_amp_cost.m``: This function defines a cost function based on the amplitudes of predicted and real postsynaptic potentials.
-  ``calc_cost.m``: This function defines a cost function based on the predicted and real postsynaptic potentials.
- ``calc_prel.m``: This function is used to compute release probability over time.

- ``exploration_steadystate.m``: This code explores the release probability of a cell and the transmission rate as a function of stimulation frequency.
- `` exploration_dynamic_response.m``: This code explores the release probability of a cell over time as the stimulation frequency changes over time.

***Experimental Files***
- ``control_5hz.xlsx``: The first two columns of this file contain the time (first column) and the corresponding postsynaptic voltages (second column) while the presynaptic cell was being stimulated with a background stimulation of 1 Hz and then a high frequency burst of stimulation of 5 Hz that starts immediately and lasts for 603 ms. 
- ``control_10hz.xlsx``: The first two columns of this file contain the time (first column) and the corresponding postsynaptic voltages (second column) while the presynaptic cell was being stimulated with a background stimulation of 1 Hz and a high frequency stimulation of 10 Hz that starts immediately and lasts for 600 ms.
- ``control_20hz.xlsx``: The first two columns of this file contain the time (first column) and the corresponding postsynaptic voltages (second column) while the presynaptic cell was being stimulated with a background stimulation of 1 Hz and a high frequency stimulation of 20 Hz that starts immediately and lasts for 460 ms.
- ``control_40hz.xlsx``: The first two columns of this file contain the time (first column) and the corresponding postsynaptic voltages (second column) while the presynaptic cell was being stimulated with a background stimulation of 1 Hz and a high frequency stimulation of 40 Hz that starts immediately and lasts for 340 ms.

---

**Future Work**
Future work includes exploring other models for synaptic facilitation and depression, exploring mixed plasticity in other data (e.g., data collected by the Allen Brain Institute), and developing a method to fit this model to experimental data.

---

**References**
1. Lee, C., Anton, M., Poon, C., & McRae, G. (2008). A kinetic model unifying presynaptic short-term facilitation and depression. Journal Of Computational Neuroscience, 26(3), 459-473. doi: 10.1007/s10827-008-0122-6
