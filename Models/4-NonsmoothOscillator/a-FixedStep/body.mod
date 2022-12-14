: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Pedagogical model of a nonsmooth brain/body system.

NEURON {
  SUFFIX body :: Custom name for mechanism
}

PARAMETER {   :: Declare and set any parameters required for this mod file here.
  b0 = 1.0  :: Scaling parameter
  w = 0.628 :: Frequency parameter
}

STATE { b } :: State variable

INITIAL {
  b = 1.0  :: Drive mechanism
}

BREAKPOINT {
  b = b0 * cos(w * t) :: Algebraic equation
}
