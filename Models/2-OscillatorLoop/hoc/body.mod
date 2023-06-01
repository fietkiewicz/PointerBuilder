: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Neuromechanical, closed-loop model of a half-center oscillator coupled to a rudimentary motor system.

NEURON {
   SUFFIX body
   POINTER V1Pointer, V2Pointer
}

PARAMETER {
   L1 L2
   :: Muscle model parameters
   tau=2.45
   beta=0.703
   a0=0.165
   g=2
   F0=150
   b=4000
}

ASSIGNED {
   V1Pointer V2Pointer
   u1 u2 U1 U2 LT1 LT2
   a1 F1 a2 F2
}

STATE { A1 A2 x }

BREAKPOINT {
   SOLVE states METHOD derivimplicit
}

INITIAL {
   A1 = 0.5881
   A2 = 0
   x = 2.93
}

DERIVATIVE states {
   L1 = 50+0.8*x
   L2 = 50-0.8*x

   u1 = (1/2)*V1Pointer
   u2 = (1/2)*V2Pointer
   U1 = (1.03-4.31*exp(-0.198*u1))*(u1>=8)
   U2 = (1.03-4.31*exp(-0.198*u2))*(u2>=8)
   LT1 = -5.27*10^(-4)*L1^2+0.1054*L1-4.27
   LT2 = -5.27*10^(-4)*L2^2+0.1054*L2-4.27

   a1 = g*(A1-a0)
   F1 = (F0*a1*LT1)*(u1>=8)*(a1>=0)
   a2 = g*(A2-a0)
   F2 = (F0*a2*LT2)*(u2>=8)*(a2>=0)

   A1' = (1/tau)*(U1-(beta+(1-beta)*U1)*A1)
   A2' = (1/tau)*(U2-(beta+(1-beta)*U2)*A2)
   x' = (1/b)*(F2-F1)
}
