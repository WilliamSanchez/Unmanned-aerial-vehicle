function R = Quaternion2Rotation(quaternion)
    %converts a quaternion attitude to a rotation matrix
    e0 = quaternion(1);
    e1 = quaternion(2);
    e2 = quaternion(3);
    e3 = quaternion(4);

    R =[e(2)^2+e(1)^2-e(3)^2-e(4)^2   2*(e(2)*e(3)-e(4)*e(1))         2*(e(2)*e(4)+e(3)*e(1));...
      	2*(e(2)*e(3)+e(4)*e(1))       e(3)^2+e(1)^2-e(2)^2-e(4)^2     2*(e(3)*e(4)-e(2)*e(1));...
      	2*(e(2)*e(4)-e(3)*e(1))       2*(e(3)*e(4)+e(2)*e(1))         e(4)^2+e(1)^2-e(2)^2-e(3)^2
end
