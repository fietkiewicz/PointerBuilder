: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Pedagogical model of a nonsmooth brain/body system.

NEURON {
  SUFFIX body :: Name for mechanism
  NONSPECIFIC_CURRENT b :: Required for equation in BREAKPOINT block
}

PARAMETER {
  b0 = 1.0  :: Scaling parameter
  w = 0.628 :: Frequency parameter
}

STATE { b }

INITIAL {
  b = 1.0  :: Drive mechanism
}

BREAKPOINT {
  b = b0 * cos(w * t) :: Algebraic equation
}
