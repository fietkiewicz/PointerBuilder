: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Pedagogical model of a nonsmooth brain/body system.

NEURON {
  SUFFIX brain :: Custom name for mechanism
  POINTER bPointer :: State variable in separate mod file
}

ASSIGNED { bPointer } :: Declare all pointer variables here.

STATE { a } :: Declare state variables here.

BREAKPOINT {
  SOLVE states METHOD derivimplicit
}

INITIAL {
  a = 1.0 :: Set initial value of state variable.
}

DERIVATIVE states {
  :: Avoid writing logical conditioning in DERIVATIVE block
  a' = da_dt()
}

FUNCTION da_dt() {
  LOCAL rhs : Right hand side of equation
  rhs = a * (1 - a) - bPointer
  if (a > 0 || rhs >= 0) {
    da_dt = rhs
  } else {
    da_dt = 0
  }
}
