run("../../parameters/simulation_parameters.m")
run("aerosonde_parameters.m")
addpath("../chap_2")

mav_view = uav_viewer();
data_view = data_viewer();

% initialize the video writer
VIDEO = 0;  % 1 means write video, 0 means don't write video
if VIDEO==1, video=video_writer('chap3_video.avi', SIM.ts_video); end

mav = uav_dynamics(SIM.ts_simulation, MAV);

sim_times = SIM.start_time;

while sim_times < SIM.end_time
    fx = 10;
    fy = 10;
    fz = 0;
    Mx = 0;
    My = 0;
    Mz = 0.1;
    forces_moments = [fx; fy; fz; Mx; My; Mz];

        %-------physical system-------------
    mav.update_state(forces_moments, MAV);
    
    %-------update viewer-------------
    mav_view.update(mav.true_state);  % plot body of MAV
    data_view.update(mav.true_state,... % true states
                     mav.true_state,... % estimated states
                     mav.true_state,... % commmanded states
                     SIM.ts_simulation); 
    if VIDEO, video.update(sim_times);  end

    %-------increment time-------------
    sim_times = sim_times + SIM.ts_simulation;

end

if VIDEO, video.close();end