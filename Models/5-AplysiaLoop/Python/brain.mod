: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Closed-loop model of feeding behavior in the sea hare Aplysia californica that incorporates biologically-motivated nonsmooth dynamics.

NEURON {
  SUFFIX brain
  POINTER xrPointer
}

PARAMETER {
  tau_a = 0.05  :: time constant for neural activity
  mu = 1e-5  :: original standard value is 1e-5
  gamma = 2.4
  eps0 = 1e-4  :: in the MS all epsilon are equal
  eps1 = 1e-4  :: in the MS all epsilon are equal
  eps2 = 1e-4  :: in the MS all epsilon are equal
  s0 = 0.5  :: this is S0 in the MS
  s1 = 0.5  :: this is S1 in the MS
  s2 = 0.25  :: this is S2 in the MS
  sig0 = -1  :: this is sigma0 in the MS
  sig1 = 1  :: this is sigma1 in the MS
  sig2 = 1  :: this is sigma2 in the MS
}

ASSIGNED { xrPointer }

STATE { a0 a1 a2 }

BREAKPOINT {
  SOLVE states METHOD derivimplicit
}

INITIAL {
  a0 = 0.900321164137428
  a1 = 0.083551935956201
  a2 = 0.000031666995903
}

DERIVATIVE states {
  a0' = compute0()
  a1' = compute1()
  a2' = compute2()
}

FUNCTION compute0() {
  LOCAL aIn0, aIn1, aOut
  aIn0 = maximum(a0, 0)
  aIn1 = maximum(a1, 0)
  aOut = ((aIn0 * (1 - aIn0 - gamma * aIn1) + mu + eps0 * (xrPointer - s0) * sig0)) / tau_a
  aOut = (a0 > 0) * aOut + (a0 <= 0) * maximum(0, aOut)
  compute0 = (a0 < 1) * aOut + (a0 >= 1) * minimum(1, aOut)
}

FUNCTION compute1() {
  LOCAL aIn0, aIn1, aOut
  aIn0 = maximum(a1, 0)
  aIn1 = maximum(a2, 0)
  aOut = ((aIn0 * (1 - aIn0 - gamma * aIn1) + mu + eps1 * (xrPointer - s1) * sig1)) / tau_a
  aOut = (a1 > 0) * aOut + (a1 <= 0) * maximum(0, aOut)
  compute1 = (a1 < 1) * aOut + (a1 >= 1) * minimum(1, aOut)
}

FUNCTION compute2() {
  LOCAL aIn0, aIn1, aOut
  aIn0 = maximum(a2, 0)
  aIn1 = maximum(a0, 0)
  aOut = ((aIn0 * (1 - aIn0 - gamma * aIn1) + mu + eps2 * (xrPointer - s2) * sig2)) / tau_a
  aOut = (a2 > 0) * aOut + (a2 <= 0) * maximum(0, aOut)
  compute2 = (a2 < 1) * aOut + (a2 >= 1) * minimum(1, aOut)
}

FUNCTION maximum(a, b) {
  if (a > b) {
    maximum = a
  } else {
    maximum = b
  }
}

FUNCTION minimum(a, b) {
  if (a < b) {
    minimum = a
  } else {
    minimum = b
  }
}
