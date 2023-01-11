: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Neuromechanical, closed-loop model of a half-center oscillator coupled to a rudimentary motor system.

NEURON {
   SUFFIX brain
   POINTER L1Pointer, L2Pointer
}

PARAMETER {
   Iapp=0.8
   Vk=-80
   Vl=-50
   Vca=100
   gk=0.02
   gl=0.005
   gca=0.015
   c=1
   E1=0
   E3=0
   E2=15
   E4=15
   Ethresh=30
   Eslope=2
   phi=0.0005
   Esyn=-80
   gsyn=0.008     ::CPG synaptic conductance is 0.008.
   :: Feedback parameters
   x10=0
   Lslope=200
   Efb=-80
   gfb=0.006       ::Feedback synaptic conductance is 0.006.
   t0=0
   tF=4508   ::tF=2*period
}

ASSIGNED {
   L1Pointer L2Pointer
   minf1 minf2 winf1 winf2 tauw1 tauw2
   sinffw1 sinffw2 sinffb1 sinffb2
   Isyn1 Isyn2 Ifb1 Ifb2
}

STATE { V1 V2 N1 N2 }

BREAKPOINT {
   SOLVE states METHOD derivimplicit
}

INITIAL {
   V1 = 21.1262
   V2 = -29.7402
   N1 = 0.5174
   N2 = 0.4456
}

DERIVATIVE states {
   minf1 = 0.5*(1+tanh((V1-E1)/E2))
   minf2 = 0.5*(1+tanh((V2-E1)/E2))
   winf1 = 0.5*(1+tanh((V1-E3)/E4))
   winf2 = 0.5*(1+tanh((V2-E3)/E4))
   tauw1 = 1/cosh((V1-E3)/(2*E4))
   tauw2 = 1/cosh((V2-E3)/(2*E4))

   sinffw1 = 0.5*(1+tanh((V1-Ethresh)/Eslope))
   sinffw2 = 0.5*(1+tanh((V2-Ethresh)/Eslope))

   sinffb1 = 1-0.5*tanh((L1Pointer-x10)/Lslope)  ::1-0.5*tanh((L1Pointer-x10)/Lslope) for contraction; 0.5*(1+tanh(L1Pointer-x10)/Lslope) for stretching
   sinffb2 = 1-0.5*tanh((L2Pointer-x10)/Lslope)  ::1-0.5*tanh((L2Pointer-x10)/Lslope) for contraction; 0.5*(1+tanh(L2Pointer-x10)/Lslope) for stretching

   Isyn1 = gsyn*sinffw2*(V1-Esyn)
   Isyn2 = gsyn*sinffw1*(V2-Esyn)
   Ifb1 = gfb*sinffb2*(V1-Efb)   ::gfb*sinffb1*(V1-Efb) for ipsilateral; gfb*sinffb2*(V1-Efb) for contralateral
   Ifb2 = gfb*sinffb1*(V2-Efb)   ::gfb*sinffb2*(V1-Efb) for ipsilateral; gfb*sinffb1*(V1-Efb) for contralateral
   V1' = (Iapp-gca*minf1*(V1-Vca)-gk*N1*(V1-Vk)-gl*(V1-Vl)-Isyn1-Ifb1)/c
   V2' = (Iapp-gca*minf2*(V2-Vca)-gk*N2*(V2-Vk)-gl*(V2-Vl)-Isyn2-Ifb2)/c
   N1' = phi*(winf1-N1)/tauw1
   N2' = phi*(winf2-N2)/tauw2
}
