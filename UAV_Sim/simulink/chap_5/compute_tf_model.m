% x_trim is the trimmed state,
% u_trim is the trimmed input

theta_trim  = 4
Va_trim     = 25 

mass        = MAV.mass;
c           = MAV.c;
S           = MAV.S_wing;
b           = MAV.b;
dens	    = MAV.rho;
Sprop       = MAV.S_prop;
Cprop       = MAV.C_prop;

r3 	    = MAV.Gamma3;
r4 	    = MAV.Gamma4;
r8 	    = MAV.Gamma8;

Cdo         = MAV.C_D_0;
Cnp         = MAV.C_n_p;
Cllp        = MAV.C_ell_p;
Cmq         = MAV.C_m_q;
Cma         = MAV.C_m_alpha;
Cybeta      = MAV.C_Y_beta;

Cmdelta_e   = MAV.C_m_delta_e;
Clldelta_a  = MAV.C_ell_delta_a;
Cndelta_a   = MAV.C_n_delta_a;
Cydelta_r   = MAV.C_Y_delta_r;
Cda         = MAV.C_D_alpha;
Cddelta_e   = MAV.C_D_delta_e;

Jy 	    = MAV.Jy;

Cp_p   	    = r3*Cllp + r4*Cnp;	
Cp_delta_a  = r3*Clldelta_a + r4*Cndelta_a;

a_phi1  = -dens*Va_trim^2*S*b*Cp_p*b/(2*Va_trim);
a_phi2  = -dens*Va_trim^2*S*b*Cp_p*Cp_delta_a;

a_beta1     = -dens*Va_trim*S*Cybeta/(2*mass);
a_beta2     = -dens*Va_trim*S*Cydelta_r/(2*mass);

a_theta1    = -dens*Va_trim^2*c*S/(2*Jy)*Cmq*c/(2*Va_trim);   
a_theta2    = -dens*Va_trim^2*c*S/(2*Jy)*Cma;
a_theta3    = -dens*Va_trim^2*c*S/(2*Jy)*Cmdelta_e;

a_V1        = dens*Va_trim*S/mass*(Cdo + Cda* + Cddelta_e*u_trim(1)) + dens*Sprop/mass*Cprop*Va_trim;
a_V2        = dens*Sprop/mass*Cprop*u_trim(4);
a_V3        = 4

% define transfer functions
T_phi_delta_a   = tf([a_phi2],[1,a_phi1,0]);
T_chi_phi       = tf([MAV.gravity/Va_trim],[1,0]);
T_theta_delta_e = tf(a_theta3,[1,a_theta1,a_theta2]);
T_h_theta       = tf([Va_trim],[1,0]);
T_h_Va          = tf([theta_trim],[1,0]);
T_Va_delta_t    = tf([a_V2],[1,a_V1]);
T_Va_theta      = tf([-a_V3],[1,a_V1]);
T_v_delta_r     = tf([a_beta2],[1,a_beta1]);
