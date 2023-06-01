: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Closed-loop model of neural control for respiration.

NEURON {
	SUFFIX nap
	RANGE C ,Ek,El,Ena,Esyn,gk,gl,gna,gnap ,h_inf ,Ik ,Il ,Ina ,Inap ,Itonic ,m_inf ,mp_inf ,n_inf ,sigma_h ,sigma_m ,sigma_mp ,sigma_n ,tau_h ,tau_n ,taulb ,taumax_h ,taumax_n ,theta_h ,theta_m ,theta_mp ,theta_n
	USEION na WRITE ina
}

PARAMETER {
	: maximal conductances
	gnap=2.8  gna=28  gk=11.2  gl=2.8

	: reversal potentials
	Ena=50   Ek=-85   El=-65   Esyn=0

	: persistent sodium
	theta_mp = -40    sigma_mp = -6
	theta_h = -48   sigma_h = 6   taumax_h = 10000

	: transient sodium
	theta_m = -34   sigma_m = -5

	: potassium
	theta_n = -29   sigma_n = -4   taumax_n = 10
}

ASSIGNED {i gtonic 	h_inf 	ik  ina	Il 	Ina 	Inap 	Itonic 	m_inf 	mp_inf 	n_inf 	tau_h 	tau_n 	taulb  v}

STATE { h }

BREAKPOINT {
	SOLVE states METHOD derivimplicit
	: persistent sodium
	mp_inf = 1/(1+exp((v-theta_mp)/sigma_mp))
	ina = gnap*mp_inf*h*(v-Ena)
}

INITIAL {
	h = 0.7454
}

DERIVATIVE states {
	h' = calc_h(v, h)
}

FUNCTION calc_h(vm, h) {
	: persistent sodium
	h_inf = 1/(1+exp((vm-theta_h)/sigma_h))
	tau_h = taumax_h/cosh((vm-theta_h)/(2*sigma_h))
	calc_h = (h_inf-h)/tau_h
}
