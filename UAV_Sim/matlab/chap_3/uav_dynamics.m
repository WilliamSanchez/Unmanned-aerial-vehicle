classdef uav_dynamics < handle
    properties
        ts_simulation
        state
        true_state
    end
    methods
        function self = uav_dynamics(Ts, MAV)
            self.ts_simulation = Ts;
            self.state = [MAV.pn0; MAV.pe0; MAV.pd0; MAV.u0; MAV.v0;... 
                        MAV.w0; MAV.e0; MAV.e1; MAV.e2; MAV.e3; MAV.p0;...
                        MAV.q0; MAV.r0];
            self.true_state = msg_state();
        end
        function self = update_state(self, forces_moments, MAV)
            %
            % Integrate the differential equations defining dynamics
            % forces_moments are the forces and moments on the MAV.
            % 
            % Integrate ODE using Runge-Kutta RK4 algorithm
            k1 = self.derivatives(self.state, forces_moments, MAV);
            k2 = self.derivatives(self.state + self.ts_simulation/2*k1, forces_moments, MAV);
            k3 = self.derivatives(self.state + self.ts_simulation/2*k2, forces_moments, MAV);
            k4 = self.derivatives(self.state + self.ts_simulation*k3, forces_moments, MAV);
            self.state = self.state + self.ts_simulation/6*(k1+2*k2+2*k3+k4);

            %normalize the quaternion
            self.state(7:10) = self.state(7:10)/norm(self.state(7:10));
            self.update_true_state();
        end
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
        function self = update_true_state(self)
            eul = quat2eul(self.state(7:10)');
            self.true_state.pn = self.state(1);
            self.true_state.pe = self.state(2);
            self.true_state.h = self.state(3);
            self.true_state.phi = eul(3);
            self.true_state.theta = eul(2);
            self.true_state.psi = eul(1);
            self.true_state.p = self.state(11);
            self.true_state.q = self.state(12);
            self.true_state.r = self.state(13);
        end    
    end
end