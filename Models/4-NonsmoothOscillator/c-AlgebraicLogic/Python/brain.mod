: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Pedagogical model of a nonsmooth brain/body system.

NEURON {
  SUFFIX brain
  POINTER bPointer
}

ASSIGNED { bPointer }

STATE { a }

BREAKPOINT {
  SOLVE states METHOD derivimplicit
}

INITIAL {
  a = 1.0 :: Set initial value of state variable.
}

DERIVATIVE states {
  a' = compute()
}

FUNCTION compute() {
  LOCAL da_dt : Derivative
  da_dt = a * (1 - a) - bPointer
  compute = (a > 0) * da_dt + (a <= 0) * (da_dt >= 0) * da_dt
}
