: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Pedagogical model of a nonsmooth brain/body system.

NEURON {
  SUFFIX body :: Name for mechanism
}

PARAMETER {
  b0 = 1.0  :: Scaling parameter
  w = 0.628 :: Frequency parameter
}

STATE { b }

BREAKPOINT {
  SOLVE states METHOD derivimplicit
}

INITIAL {
  b = 1.0 :: Set initial value of state variable.
}

DERIVATIVE states {
  b' = -b0 * w * sin(w * t)
}
