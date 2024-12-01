% wind Simulation - simulates steady state and wind gusts
%
% mavMatSim 
%     - Beard & McLain, PUP, 2012
%     - Update history:  
%         12/27/2018 - RWB
classdef wind_simulation < handle
   %--------------------------------
    properties
        steady_state
        A
        B
        C
        gust_state
        gust_
        Ts
    end
    %--------------------------------
    methods
        %------constructor-----------
        function self = wind_simulation(Ts,WIND)
            self.steady_state = [WIND.wind_n;WIND.wind_e; WIND.wind_d];
            
            a1 = WIND.sigma_u*sqrt(2*WIND.Va0/WIND.L_u);
            a2 = WIND.Va0/WIND.L_u;

            b1 = WIND.sigma_v*sqrt(3*WIND.Va0/WIND.L_v);
            b2 = WIND.Va0/WIND.L_v;
            b3 = WIND.Va0/WIND.L_v;

            c1 = WIND.sigma_w*sqrt(3*WIND.Va0/WIND.L_w);
            c2 = WIND.Va0/(sqrt(3)*WIND.L_w);
            c3 = WIND.Va0/WIND.L_w;

            self.A = [-a2   0   0       0       0;...
                        0   0   1       0       0;...
                        0 -b3^2 -2*b3   0       0;...
                        0   0   0       0       1;...
                        0   0   0       -c3^2   -2*c3];

            self.B = [a1 0 0; 0 0 0; 0 b1 0;0 0 0; 0 0 c1];

            self.C = [1 0 0 0 0; 0 b2 1 0 0; 0 0 0 c2 1];

            self.gust_state = [0; 0; 0; 0; 0;];

            self.gust_ = [0; 0; 0];
            self.Ts = Ts;
        end
        %---------------------------
        function wind=update(self)
            self = self.gust();
            wind = [self.steady_state; self.gust_];
        end
        %----------------------------
        function self = gust(self)
            ur = randn;
            vr = randn;
            wr = randn;
            self.gust_state = self.gust_state + self.Ts*(self.A*self.gust_state + self.B*[ur vr wr]');
            self.gust_ = self.C*self.gust_state;
        end
    end
end
