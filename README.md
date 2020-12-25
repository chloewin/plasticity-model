# plasticity-model
model for synaptic facilitation, depression

---

**Background**

Communication in the brain takes place at synapses, tiny gaps between neurons. In these synapses, neurotransmitters are released from _presynaptic_ terminals to _postsynaptic_ structures in _vesicles_ (packets). Neurotransmitters mediate electric responses in the postsynaptic neuron. Synaptic activity often leads to changes in synaptic strength (how successful the presynaptic cell is at causing an electric response in the postsynaptic cell.) This phenomenon is known as synaptic plasticity. Synaptic plasticity can be either longterm or shortterm.

There are several forms of short-term synaptic plasticity. One is synaptic facilitation, the strengthening of a synapse. One proposed mechanism for this is buildup of calcium in the presynaptic cell [1]. Synaptic depression, another form of short-term plasticity, refers to the weakening of a synapse. One proposed mechanism of this is the depletion of vesicles [1].

---

These files describe a model for synaptic facilitation and depression based on the above mechanisms using equations derived from [1]. Euler's method was used for all differentials.
- Calcium buffering: calcium is constantly being removed from the cell following this differential equation: $\tau_{Ca}\frac{dCa}{dt}$

---

**References**
1. Lee, C., Anton, M., Poon, C., & McRae, G. (2008). A kinetic model unifying presynaptic short-term facilitation and depression. Journal Of Computational Neuroscience, 26(3), 459-473. doi: 10.1007/s10827-008-0122-6
