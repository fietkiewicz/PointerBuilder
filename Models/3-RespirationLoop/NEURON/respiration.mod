: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Closed-loop model of neural control for respiration.

NEURON {
	SUFFIX respiration
	POINTER Vpointer
	RANGE betaO2 ,c ,CaO2 ,dvolrhs,E1 ,E2 , eta ,gamma ,gtonic ,Hb ,Jbt,Jlb, K, Kp ,M ,m_inf ,NT ,partial ,PO2ext ,r ,R ,SaO2 ,sigma_h ,sigma_m ,sigma_mp ,sigma_n ,taulb ,Temp ,Tmax ,Vol0 ,volblood , VT
}

PARAMETER {
	:: Motor pool
	r = 0.001   Tmax = 1   VT = 2   Kp = 5

	:: Lung volume
	E1 = 0.0025   E2 = 0.4   Vol0 = 2

	:: Lung oxygen
	PO2ext = 149.73    R = 62.364   Temp = 310
	taulb = 500

	:: Blood oxygen
	M = 8e-6
	Hb = 150   volblood = 5   betaO2 = 0.03
	c = 2.5   K = 26
}

ASSIGNED {CaO2 	dvolrhs	eta 	gamma gtonic	Jbt	Jlb	  NT 	partial 	SaO2 	sigma_h 	sigma_m 	sigma_mp 	sigma_n 	Vpointer }

STATE { alpha  vollung PO2lung PO2blood }

BREAKPOINT {
	SOLVE states METHOD derivimplicit
	:: Chemosensory feedback
	gtonic = 0.3*(1-tanh((PO2blood-85)/30))
}

INITIAL {
	alpha = 2.0026e-04
	vollung = 2.0525
	PO2lung = 98.9638
	PO2blood = 97.7927
}

DERIVATIVE states {
	alpha' = calc_alpha(Vpointer, alpha, vollung, PO2lung, PO2blood)
	vollung' = calc_vollung(Vpointer, alpha, vollung, PO2lung, PO2blood)
	PO2lung' = calc_PO2lung(Vpointer, alpha, vollung, PO2lung, PO2blood)
	PO2blood' = calc_PO2blood(Vpointer, alpha, vollung, PO2lung, PO2blood)
}

FUNCTION calc_alpha(Vpointer, alpha, vollung, PO2lung, PO2blood) {
	:: Motor pool

	NT = Tmax/(1+exp(-(Vpointer-VT)/Kp))

	calc_alpha = r*NT*(1-alpha)-r*alpha
}

FUNCTION calc_vollung(Vpointer, alpha, vollung, PO2lung, PO2blood) {
	:: Lung volume

	dvolrhs = -E1*(vollung-Vol0)+E2*alpha
	if (dvolrhs < 0) {
		dvolrhs = 0
	}

	calc_vollung = -E1*(vollung-Vol0)+E2*alpha
}

FUNCTION calc_PO2lung(Vpointer, alpha, vollung, PO2lung, PO2blood) {
	:: Lung oxygen


	calc_PO2lung = (1/vollung)*(PO2ext-PO2lung)*dvolrhs-Jlb*(R*Temp/vollung)
}

FUNCTION calc_PO2blood(Vpointer, alpha, vollung, PO2lung, PO2blood) {
	:: Blood oxygen
	eta = Hb*1.36   gamma = volblood/22400
	SaO2 = pow(PO2blood,c)/(pow(PO2blood,c)+pow(K,c))
	CaO2 = eta*SaO2+betaO2*PO2blood
	partial = (c*pow(PO2blood,(c-1))) * (1/(pow(PO2blood,c)+pow(K,c))-(pow(PO2blood,c))/(pow(pow(PO2blood,c)+pow(K,c),2)))
	Jlb=(1/taulb)*(PO2lung-PO2blood)*(vollung/(R*Temp))
	Jbt=M*CaO2*gamma

	calc_PO2blood = (Jlb-Jbt)/(gamma*(betaO2+eta*partial))
}
