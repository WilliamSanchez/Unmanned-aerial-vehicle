addpath('../chap_5/')
load transfer_function_coef
addpath('../../parameters/')
simulation_parameters

% AP stands for autopilot
AP.gravity = 1
AP.sigma = 30*pi/180
AP.Va0 = MAV.v0;
AP.Ts = SIM.ts_simulation;

%----------roll loop-------------
AP.roll_kp = 45*pi/180/15*pi/180*sign(a_phi2)
AP.roll_kd = (2*9*sqrt(abs(a_phi2)*45*pi/180/15*pi/180)-a_phi1)/a_phi2

%----------course loop-------------
AP.course_kp = 
AP.course_ki = 

%----------sideslip loop-------------
AP.sideslip_ki = 
AP.sideslip_kp = 

%----------yaw damper-------------
AP.yaw_damper_tau_r = 
AP.yaw_damper_kp = 

%----------pitch loop-------------
AP.pitch_kp = 
AP.pitch_kd = 
K_theta_DC = 

%----------altitude loop-------------
AP.altitude_kp = 
AP.altitude_ki = 
AP.altitude_zone = 

%---------airspeed hold using throttle---------------
AP.airspeed_throttle_kp = 
AP.airspeed_throttle_ki = 
