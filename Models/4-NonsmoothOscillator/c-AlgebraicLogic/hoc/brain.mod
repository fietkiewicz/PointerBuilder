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
  a' = da_dt()
}

FUNCTION da_dt() {
  LOCAL rhs : Right hand side of equation
  rhs = a * (1 - a) - bPointer
  da_dt = (a > 0) * rhs + (a <= 0) * (rhs >= 0) * rhs
}
