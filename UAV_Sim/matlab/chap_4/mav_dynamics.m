classdef mav_dynamics < handle
   %--------------------------------
    properties
        ts_simulation
        state
        Va
        alpha
        beta
        wind
        true_state
    end
    %--------------------------------
    methods
        %------constructor-----------
        function self = mav_dynamics(Ts, MAV)
            self.ts_simulation = Ts; % time step between function calls
            self.state = [MAV.pn0; MAV.pe0; MAV.pd0; MAV.u0; MAV.v0; MAV.w0;...
                MAV.e0; MAV.e1; MAV.e2; MAV.e3; MAV.p0; MAV.q0; MAV.r0];

            self.Va = 10;
            self.alpha = 2; 
            self.beta = 0.4;
            self.wind = 0.2;
            addpath('../message_types'); self.true_state = msg_state();
        end
        %---------------------------
        function self=update_state(self, delta, wind, MAV)
            %
            % Integrate the differential equations defining dynamics
            % forces_moments are the forces and moments on the MAV.
            % 
            
            % get forces and moments acting on rigid body
            forces_moments = self.forces_moments(delta, MAV);
            
            % Integrate ODE using Runge-Kutta RK4 algorithm
            k1 = self.derivatives(self.state, forces_moments, MAV);
            k2 = self.derivatives(self.state + self.ts_simulation/2*k1, forces_moments, MAV);
            k3 = self.derivatives(self.state + self.ts_simulation/2*k2, forces_moments, MAV);
            k4 = self.derivatives(self.state + self.ts_simulation*k3, forces_moments, MAV);
            self.state = self.state + self.ts_simulation/6 * (k1 + 2*k2 + 2*k3 + k4);
            
            % normalize the quaternion
            self.state(7:10) = self.state(7:10)/norm(self.state(7:10));
            
            % update the airspeed, angle of attack, and side slip angles
            self.update_velocity_data(wind);
            
            % update the message class for the true state
            self.update_true_state();
        end
        %----------------------------
        function xdot = derivatives(self, state, forces_moments, MAV)
            
            mass = MAV.mass;

            r1 = MAV.Gamma1;
            r2 = MAV.Gamma2;
            r3 = MAV.Gamma3;
            r4 = MAV.Gamma4;
            r5 = MAV.Gamma5;
            r6 = MAV.Gamma6;
            r7 = MAV.Gamma7;
            r8 = MAV.Gamma8;

            pn    = state(1);
            pe    = state(2);
            pd    = state(3);
            u     = state(4);
            v     = state(5);
            w     = state(6);
            e0    = state(7);
            e1    = state(8);
            e2    = state(9);
            e3    = state(10);
            p     = state(11);
            q     = state(12);
            r     = state(13);
            fx    = forces_moments(1);
            fy    = forces_moments(2);
            fz    = forces_moments(3);
            ell   = forces_moments(4);
            m     = forces_moments(5);
            n     = forces_moments(6);
            
            % position kinematics
            pndot = (e1^2+e0^2-e2^2-e3^2)*u + 2*(e1*e2-e3*e0)*v + 2*(e1*e3+e2*e0)*w;    
            pedot = 2*(e1*e2+e3*e0)*u + (e2^2+e0^2-e1^2-e3^2)*v + 2*(e2*e3-e1*e0)*w;   
            pddot = -2*(e1*e3-e2*e0)*u - 2*(e2*e3+e1*e0)*v - (e3^2+e0^2-e1^2-e2^2)*w;
            
            % position dynamics
            udot =  r*v - q*w + fx/mass;   
            vdot =  p*w - r*u + fy/mass;   
            wdot =  q*u - p*v + fz/mass;
            
            % rotational kinematics
            e0dot = 0.5*(-p*e1 - q*e2 - r*e3);
            e1dot = 0.5*( p*e0 + r*e2 - q*e3);
            e2dot = 0.5*( q*e0 - r*e1 + p*e3);
            e3dot = 0.5*( r*e0 + q*e1 - p*e2);
            
            % rotational dynamics
            pdot = r1*p*q - r2*q*r + r3*ell + r4*n;    
            qdot = r5*p*r - r6*(p^2 - r^2) + m/MAV.Jy;
            rdot = r7*p*q - r1*q*r + r4*ell + r8*n;
        
            xdot = [pndot; pedot; pddot; udot; vdot; wdot; e0dot; e1dot; e2dot; e3dot; pdot; qdot; rdot];

        end
        %----------------------------
        function self=update_velocity_data(self, wind)
    
            e0    = self.state(7);
            e1    = self.state(8);
            e2    = self.state(9);
            e3    = self.state(10);

            wn = wind(1);
            wd = wind(2);
            we = wind(3);

            uw = (e0^2 + e1^2 - e2^2 - e3^2)*wn + 2*(e1*e2 + e0*e3)*wd + 2*(e1*e3 - e0*e2)*we + wind(4);
            vw = 2*(e1*e2 - e0*e3)*wn + (e0^2 - e1^2 + e2^2 - e3^2)*wd + 2*(e0*e1 + e2*e3)*we + wind(5);
            ww = 2*(e0*e2 + e1*e3)*wn + 2*(e2*e3 - e0*e1)*wd + (e0^2 - e1^2 - e2^2 + e3^2)*we + wind(6);

            ur = self.state(4) - uw;
            vr = self.state(5) - vw;
            wr = self.state(6) - vw;

            self.wind = [uw; vw; ww];	% body frame
            self.Va = sqrt(ur^2 + vr^2 + wr^2);
            self.alpha = atan2(wr,ur);
            self.beta = asin(vr/sqrt(ur^2 + vr^2 + wr^2));
        end
        %----------------------------
        function out=forces_moments(self, delta, MAV)
    
            mass    = MAV.mass;
            
            d_el    = delta(1);
            d_al    = delta(3);
            d_ru    = delta(4);
            d_th    = delta(2);

            g       = MAV.gravity; 
            e0      = self.state(7); 
            e1      = self.state(8);
            e2      = self.state(9);
            e3      = self.state(10);
            p       = self.state(11);
            q       = self.state(12);
            r       = self.state(13);

            V_a      = self.Va;
            aalpha   = self.alpha;
            bbeta    = self.beta;

            Swing   = MAV.S_wing;
            Sprop   = MAV.S_prop;
            Cprop   = MAV.C_prop;
            dens    = MAV.rho;
            km      = MAV.k_motor;
            Kmo     = MAV.k_Omega;
            Ktp     = MAV.k_T_P;
            c       = MAV.c;
            b       = MAV.b;

            %%%   Coeficients forces

            Clo     = MAV.C_L_0;
            Cla     = MAV.C_L_alpha;

            Cdo     = MAV.C_D_0;
            Cda     = MAV.C_D_alpha;
            Cdq     = MAV.C_D_q;
            Clq     = MAV.C_L_q;
            Cddelta_e   = MAV.C_D_delta_e;
            Cldelta_e   = MAV.C_L_delta_e;

            Cyo     = MAV.C_Y_0;
            Cybeta  = MAV.C_Y_beta;
            Cyp     = MAV.C_Y_p;
            Cyr     = MAV.C_Y_r;
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

            gx = -mass*g*(e1*e3 - e2*e0);
            gy = mass*g*(e2*e3 - e1*e0);
            gz = mass*g*(e3^2 + e0^2 - e1^2 - e2^2);

            fx = 0.5*dens*V_a^2*Swing*(Cx + Cxq*c/(2*V_a)*q + Cxde*d_el);
            fy = 0.5*dens*V_a^2*Swing*(Cyo + Cybeta*bbeta + Cyp*b/(2*V_a)*p + Cyr*b/(2*V_a)*r + Cydelta_a*d_al + Cydelta_r*d_ru);
            fz = 0.5*dens*V_a^2*Swing*(Cz + Czq*c/(2*V_a)*q + Czde*d_el);

            px = 0.5*dens*Sprop*Cprop*((km*d_th)^2 - V_a^2);
            py = 0;
            pz = 0;

            Force(1) = gx + fx + px;
            Force(2) = gy + fy + py;
            Force(3) = gz + fz + pz;

            ll = 0.5*dens*V_a^2*Swing*b*(Cllo + Cllbeta*bbeta + Cllp*b/(2*V_a)*p + Cllr*b/(2*V_a)*r + Clldelta_a*d_al + Clldelta_r*d_ru);
            mm = 0.5*dens*V_a^2*Swing*c*(Cmo + Cma*aalpha + Cmq*c/(2*V_a)*q + Cmdelta_e*d_el);
            nn = 0.5*dens*V_a^2*Swing*b*(Cno + Cnbeta*bbeta + Cnp*b/(2*V_a)*p + Cnr*b/(2*V_a)*r + Cndelta_a*d_al + Cndelta_r*d_ru);

            pll = -Ktp*(Kmo*d_th)^2;
            pmm = 0;
            pnn = 0;

            Torque(1) = ll + pll;
            Torque(2) = mm + pmm;
            Torque(3) = nn + pnn;
            % output total force and torque
            out = [Force'; Torque'];
        end
        %----------------------------
        function self=update_true_state(self)
            [phi, theta, psi] = Quaternion2Euler(self.state(7:10));
            self.true_state.pn = self.state(1);  % pn 
            self.true_state.pe = self.state(2);  % pd
            self.true_state.h = -self.state(3);  % h
            self.true_state.phi = phi;
            self.true_state.theta = theta;
            self.true_state.psi = psi;
            self.true_state.p = self.state(11); % p
            self.true_state.q = self.state(12); % q
            self.true_state.r = self.state(13); % r
            self.true_state.Va = self.Va;
            self.true_state.alpha = self.alpha;
            self.true_state.beta = self.beta;
            self.true_state.Vg = sqrt(self.state(4)^2 + self.state(5)^2 + self.state(6)^2);
            self.true_state.chi = 54;
            self.true_state.gamma = 23;
            self.true_state.wn = self.wind(1);
            self.true_state.we = self.wind(2);
        end
    end
end
