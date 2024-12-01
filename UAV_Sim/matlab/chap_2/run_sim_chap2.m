run("../parameters/simulation_parameters.m")

state = msg_state();
%mav_viewer = box_viewer();
mav_viewer = uav_viewer();

VIDEO = 0;

if VIDEO == 1, video = video_writer('MAV_video.avl', SIM.ts_video); end

sim_time = SIM.start_time;
disp('Type CTRL-C to exit');
cle
while sim_time < SIM.end_time
    if sim_time < SIM.end_time/6
        state.pn = state.pn + SIM.ts_simulation;
    elseif sim_time < 2*SIM.end_time/6
        state.pe = state.pe + SIM.ts_simulation;
    elseif sim_time < 3*SIM.end_time/6
        state.h = state.h + SIM.ts_simulation;
    elseif sim_time < 4*SIM.end_time/6
        state.phi = state.phi + SIM.ts_simulation;
    elseif sim_time < 5*SIM.end_time/6
        state.theta = state.theta + SIM.ts_simulation;
    end   

    mav_viewer.update(state);

    if VIDEO, video.update(sim_time); end

    sim_time = sim_time + SIM.ts_simulation;

end

if VIDEO, video.close(); end;