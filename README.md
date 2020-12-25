# plasticity-model
model for synaptic facilitation, depression

---

**Background**

Communication in the brain takes place at synapses, tiny gaps between neurons. In these synapses, neurotransmitters are released from _presynaptic_ terminals to _postsynaptic_ structures in _vesicles_ (packets). Neurotransmitters mediate electric responses in the postsynaptic neuron. Synaptic activity often leads to changes in synaptic strength (how successful the presynaptic cell is at causing an electric response in the postsynaptic cell.) This phenomenon is known as synaptic plasticity. Synaptic plasticity can be either longterm or shortterm.

There are several forms of short-term synaptic plasticity. One is synaptic facilitation, the strengthening of a synapse. One proposed mechanism for this is buildup of calcium in the presynaptic cell [1]. Synaptic depression, another form of short-term plasticity, refers to the weakening of a synapse. One proposed mechanism of this is the depletion of vesicles [1].

---

**Model SetUp**
These files describe a model for synaptic facilitation and depression based on the above mechanisms using equations derived from [1]. Euler's method was used for all differentials. THe following are the mechanisms that are modeled over time.
- Calcium buffering: calcium (``Ca``) is constantly being removed from the cell following exponential decay with a certain time constant and a starting calcium concentration as well as a constant influx modeled by a rate.
- Vesicle release: vesicle release probability (``prel``) depends on calcium concentration. This was modeled as either a sigmoid function of calcium concentration or using the Hill equation (this was harder to optimize.)
- Releasable vesicles: the ratio of vesicles that are releasable (``rrel``) is modeled as an exponential decay.

---

**References**
1. Lee, C., Anton, M., Poon, C., & McRae, G. (2008). A kinetic model unifying presynaptic short-term facilitation and depression. Journal Of Computational Neuroscience, 26(3), 459-473. doi: 10.1007/s10827-008-0122-6
