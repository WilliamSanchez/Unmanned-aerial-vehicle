classdef uav_viewer < handle
    properties 
        body_handle
        Vertices
        Faces
        facecolors
        plot_initialized
    end
    methods
        function self = uav_viewer
            self.body_handle = [];
            [self.Vertices, self.Faces,self.facecolors] = self.define_uav();
            self.plot_initialized = 0;
        end
        function self = update(self,state)
            if self.plot_initialized == 0
                figure(1); clf;
                self=self.drawbody(state.pn, state.pe, -state.h,...
                                    state.phi,state.theta, state.psi);
                title('MUAV');
                xlabel('East');
                ylabel('North');
                zlabel('-Down');
                view(32,47); 
                axis([-30,50,-30,50,-10,50]);
                hold on;
                grid on;
                self.plot_initialized = 1;
            else
                self.drawbody(state.pn, state.pe, -state.h,...
                    state.phi, state.theta, state.psi);
            end
        end
        function self = drawbody(self, pn, pe, pd, phi, tetha, psi)
            Vertices = self.rotate(self.Vertices, phi, tetha, psi);
            Vertices = self.translate(Vertices, pn, pe, pd);
            % transform vertices from NED to ENU
            R = [...
                    0, 1, 0;...
                    1, 0, 0;...
                    0, 0, -1;...
                ];
            Vertices = R*Vertices;
            if isempty(self.body_handle)
                self.body_handle = patch('Vertices', Vertices', 'Faces',self.Faces,...
                    'FaceVertexCData',self.facecolors, 'FaceColor','flat');
            else
                set(self.body_handle, 'Vertices',Vertices', 'Faces',self.Faces);
                drawnow;
            end
        end
        function pts = rotate(self, pts, phi, theta, psi)
            R_roll = [...
                        1, 0, 0; ....
                        0, cos(phi), sin(phi);...
                        0, -sin(phi), cos(phi)];
            R_pitch = [...
                        cos(theta), 0, -sin(theta);...
                        0, 1, 0;...
                        sin(theta), 0, cos(theta)];
            R_yaw = [...
                        cos(psi), sin(psi), 0;...
                        -sin(psi), cos(psi), 0;...
                        0, 0, 1];
            R = R_roll*R_pitch*R_yaw; %inertial to body
            R = R'; % bosy to inertial
            pts = R*pts;
        end
        function pts = translate(self,pts, pn, pe, pd)
            pts = pts + repmat([pn; pe; pd],1,size(pts,2));
        end
        function [V , F, colors] = define_uav(self)
            V = [   2     0     0;...     %point 1
                    1    -0.5   0.5;...     %point 2
                    1    -0.5  -0.5;...     %point 3
                    1     0.5  -0.5;...     %point 4
                    1     0.5   0.5;...     %point 5
                   -6     0     0;...     %point 6 
                   -6     0    -2;...     %point 7
                   -5     0     0;...     %point 8
                   -6     1.5   0;...     %point 9
                   -6    -1.5   0;...     %point 10   
                   -5     1.5   0;...     %point 11
                   -5    -1.5   0;...     %point 12 
                    0    -2.5   0;...     %point 13
                    0     2.5   0;...     %point 14
                   -2    -2.5   0;...     %point 15 
                   -2     2.5   0;...     %point 16 
                 ]';

            F = [...
                    1, 2, 5;...  % front
                    1, 3, 4;...  % back
                    1, 4, 5;...  % right
                    4, 5, 6;...  % left
                    3, 4, 6;...
                    6, 3, 2;...
                    2, 5, 6;...
                    6, 7, 8;...
                    9, 10, 11;...
                    10, 11, 12;...
                    13, 14, 15;...
                    14, 15, 16;...
                    %5, 6, 7, 8;...  % top
                    %9, 10, 11, 12;...   %botom
                ];
            
            myred = [1, 0, 0];
            mygreen = [0, 1, 0];
            myblue = [0, 0, 1];
            myyellow = [1, 1, 0];
            mycyan = [0, 1, 1];

            colors = [...
                        myyellow;...    % front
                        myblue;...      % back
                        myblue;...      % right
                        myred;...       % left
                        mycyan;...      % top
                        mygreen;...     % bottom
                        myblue;...
                        myblue;...
                        myred;...
                        myred;...
                        myred;...
                        myred;...
                     ];          
        end   
    end
end
