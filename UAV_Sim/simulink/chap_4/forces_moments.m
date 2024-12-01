% forces_moments.m
%   Computes the forces and moments acting on the airframe. 
%
%   Output is
%       F     - forces
%       M     - moments
%       Va    - airspeed
%       alpha - angle of attack
%       beta  - sideslip angle
%       wind  - wind vector in the inertial frame
%

function out = forces_moments(x, delta, wind, MAV)

    % relabel the inputs
    pn      = x(1);
    pe      = x(2);
    pd      = x(3);
    u       = x(4);
    v       = x(5);
    w       = x(6);
    phi     = x(7);
    theta   = x(8);
    psi     = x(9);
    p       = x(10);
    q       = x(11);
    r       = x(12);
    d_el    = delta(1);
    d_al    = delta(2);
    d_ru    = delta(3);
    d_th    = delta(4);
    w_ns    = wind(1); % steady wind - North
    w_es    = wind(2); % steady wind - East
    w_ds    = wind(3); % steady wind - Down
    u_wg    = wind(4); % gust along body x-axis
    v_wg    = wind(5); % gust along body y-axis    
    w_wg    = wind(6); % gust along body z-axis
    
    e = Euler2Quaternion(phi, theta, psi);
    e0 = e(1);
    e1 = e(2);
    e2 = e(3);
    e3 = e(4);
   
    % compute wind data in NED
    w_n = (e0^2 + e1^2 - e2^2 - e3^2)*w_ns + 2*(e1*e2 + e0*e3)*w_ds + 2*(e1*e3 - e0*e2)*w_es + u_wg;
    w_e = 2*(e1*e2 - e0*e3)*w_ns + (e0^2 - e1^2 + e2^2 - e3^2)*w_ds + 2*(e0*e1 + e2*e3)*w_es + v_wg;
    w_d = 2*(e0*e2 + e1*e3)*w_ns + 2*(e2*e3 - e0*e1)*w_ds + (e0^2 - e1^2 - e2^2 + e3^2)*w_es + w_wg;
    
    % compute air data
    
    ur = u - w_n; 
    vr = v - w_e; 
    wr = w - w_d; 
    
    V_a = sqrt(ur^2 + vr^2 + wr^2);
    aalpha = atan2(wr,ur);
    bbeta = asin(vr/V_a);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mass        = MAV.mass;
    g           = MAV.gravity; 
    
    Swing       = MAV.S_wing;
    Sprop       = MAV.S_prop;
    Cprop       = MAV.C_prop;
    dens        = MAV.rho;
    km          = MAV.k_motor;
    Kmo         = MAV.k_Omega;
    Ktp         = MAV.k_T_P;
    c           = MAV.c;
    b           = MAV.b;

    %%%   Coeficients forces

    Clo         = MAV.C_L_0;
    Cla         = MAV.C_L_alpha;

    Cdo         = MAV.C_D_0;
    Cda         = MAV.C_D_alpha;
    Cdq         = MAV.C_D_q;
    Clq         = MAV.C_L_q;
    Cddelta_e   = MAV.C_D_delta_e;
    Cldelta_e   = MAV.C_L_delta_e;

    Cyo         = MAV.C_Y_0;
    Cybeta      = MAV.C_Y_beta;
    Cyp         = MAV.C_Y_p;
    Cyr         = MAV.C_Y_r;
    Cydelta_a   = MAV.C_Y_delta_a;
    Cydelta_r   = MAV.C_Y_delta_r;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Coefficients moments

     Cllo        = MAV.C_ell_0; 
     Cllbeta     = MAV.C_ell_beta;
     Cllp        = MAV.C_ell_p;
     Cllr        = MAV.C_ell_r;
     Clldelta_a  = MAV.C_ell_delta_a;
     Clldelta_r  = MAV.C_ell_delta_r;

     Cmo         = MAV.C_m_0;
     Cma         = MAV.C_m_alpha;
     Cmq         = MAV.C_m_q;
     Cmdelta_e   = MAV.C_m_delta_e;

     Cno         = MAV.C_n_0;
     Cnbeta      = MAV.C_n_beta;
     Cnp         = MAV.C_n_p;
     Cnr         = MAV.C_n_r;
     Cndelta_a   = MAV.C_n_delta_a;
     Cndelta_r   = MAV.C_n_delta_r;

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     Cx      = -(Cdo + Cda*aalpha)*cos(aalpha) + (Clo + Cla*aalpha)*sin(aalpha);
     Cxq     = -Cdq*cos(aalpha) + Clq*sin(aalpha);
     Cxde    = -Cddelta_e*cos(aalpha) + Cldelta_e*sin(aalpha);

     Cz      = -(Cdo + Cda*aalpha)*sin(aalpha) - (Clo + Cla*aalpha)*cos(aalpha);
     Czq     = -Cdq*sin(aalpha) - Clq*cos(aalpha);
     Czde    = -Cddelta_e*sin(aalpha) - Cldelta_e*cos(aalpha);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    % compute external forces and torques on aircraft
    
    gx = -mass*g*(e1*e3 - e2*e0);
    gy = mass*g*(e2*e3 - e1*e0);
    gz = mass*g*(e3^2 + e0^2 - e1^2 - e2^2);
    
    fx = 0.5*dens*V_a^2*Swing*(Cx + Cxq*c/(2*V_a)*q + Cxde*d_el);
    fy = 0.5*dens*V_a^2*Swing*(Cyo + Cybeta*bbeta + Cyp*b/(2*V_a)*p + Cyr*b/(2*V_a)*r + Cydelta_a*d_al + Cydelta_r*d_ru);
    fz = 0.5*dens*V_a^2*Swing*(Cz + Czq*c/(2*V_a)*q + Czde*d_el);

    px = 0.5*dens*Sprop*Cprop*((km*d_th)^2 - V_a^2);
    py = 0;
    pz = 0;
    
    Force(1) =  gx + fx + px;
    Force(2) =  gy + fy + py;
    Force(3) =  gz + fz + pz;
    
    ll = 0.5*dens*V_a^2*Swing*b*(Cllo + Cllbeta*bbeta + Cllp*b/(2*V_a)*p + Cllr*b/(2*V_a)*r + Clldelta_a*d_al + Clldelta_r*d_ru);
    mm = 0.5*dens*V_a^2*Swing*c*(Cmo + Cma*aalpha + Cmq*c/(2*V_a)*q + Cmdelta_e*d_el);
    nn = 0.5*dens*V_a^2*Swing*b*(Cno + Cnbeta*bbeta + Cnp*b/(2*V_a)*p + Cnr*b/(2*V_a)*r + Cndelta_a*d_al + Cndelta_r*d_ru);

    pll = -Ktp*(Kmo*d_th)^2;
    pmm = 0;
    pnn = 0;
    
    Torque(1) = ll + pll;
    Torque(2) = mm + pmm;  
    Torque(3) = nn + pnn;
   
    out = [Force'; Torque'; V_a; aalpha; bbeta; w_n; w_e; w_d];
end



