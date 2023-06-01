: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Closed-loop model of neural control for respiration.

NEURON {
	SUFFIX k
	RANGE C ,Ek,El,Ena,Esyn,gk,gl,gna,gnap ,h_inf ,Ik ,Il ,Ina ,Inap ,Itonic ,m_inf ,mp_inf ,n_inf ,sigma_h ,sigma_m ,sigma_mp ,sigma_n ,tau_h ,tau_n ,taulb ,taumax_h ,taumax_n ,theta_h ,theta_m ,theta_mp ,theta_n
	USEION k WRITE ik
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

STATE { n }

BREAKPOINT {
	SOLVE states METHOD derivimplicit
	: potassium
	ik = gk*(n^4)*(v-Ek)
}

INITIAL {
	n = 9.5344e-04
}

DERIVATIVE states {
	n' = calc_n(v, n)
}

FUNCTION calc_n(vm, n) {
	: potassium
	n_inf = 1/(1+exp((vm-theta_n)/sigma_n))
	tau_n = taumax_n/cosh((vm-theta_n)/(2*sigma_n))
	calc_n = (n_inf-n)/tau_n
}
