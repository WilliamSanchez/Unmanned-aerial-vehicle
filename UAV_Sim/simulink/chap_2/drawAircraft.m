function drawAircraft(uu)

    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);           
    u        = uu(4);       
    v        = uu(5);       
    w        = uu(6);       
    phi      = uu(7);       % roll angle         
    theta    = uu(8);       % pitch angle     
    psi      = uu(9);       % yaw angle     
    p        = uu(10);       % roll rate
    q        = uu(11);       % pitch rate     
    r        = uu(12);       % yaw rate    
    t        = uu(13);       % time

    % define persistent variables 
    persistent body_handle;
    persistent Vertices
    persistent Faces
    persistent facecolors
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        [Vertices, Faces, facecolors] = define_uav;
        body_handle = drawBody(Vertices,Faces,facecolors,...
                                pn,pe,pd,phi,theta,psi,...
                                [],'normal');
        title('Spacecraft')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        axis([-100,100,-100,100,-500,500]);
        grid on
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawBody(Vertices,Faces,facecolors,...
                           pn,pe,pd,phi,theta,psi,...
                           body_handle);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handle = drawBody(V, F, patchcolors,...
                            pn, pe, pd, phi, tetha, psi,...
                            handle,mode)

            V = rotate(V', phi, tetha, psi);
            V = translate(V, pn, pe, pd);
            % transform vertices from NED to ENU
            R = [...
                    0, 1, 0;...
                    1, 0, 0;...
                    0, 0, -1;...
                ];
            V = R*V;

            if isempty(handle)
                handle = patch('Vertices', V', 'Faces',F,...
                    'FaceVertexCData',patchcolors,...
                    'FaceColor','flat');

                drawnow update               
            else
                %set(handle, 'Vertices',V', 'Faces',F,'FaceVertexCData',patchcolors,'FaceColor','flat');
                handle.Vertices = V';
                handle.Faces = F;
                
            end
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function  XYZ = rotate(XYZ, phi, theta, psi)
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
            XYZ = R*XYZ';
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function XYZ = translate(XYZ, pn, pe, pd)
            XYZ = XYZ + repmat([pn; pe; pd],1,size(XYZ,2));
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V , F, colors] = define_uav()
 
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
