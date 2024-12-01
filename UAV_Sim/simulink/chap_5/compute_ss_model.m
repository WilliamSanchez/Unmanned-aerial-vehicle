% x_trim is the trimmed state,
% u_trim is the trimmed input
  
  
[A,B,C,D]=linmod('mavsim_trim',x_trim,u_trim);

A_lat = A([5,7,9:10,12],[5,7,9:10,12])
B_lat = B(:,1:2);

A_lon = A([3:4,6,8,11],[3:4,6,8,11])
B_lon =  B(:,2:4);
  