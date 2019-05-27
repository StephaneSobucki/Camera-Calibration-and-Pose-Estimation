function R = orthonormalizeR(R)
%ORTHONORMALIZER Summary of this function goes here
%   Detailed explanation goes here
    u = R(:,1);
    v = R(:,2);
    error = dot(u,v);
    u_ort = u-(error/2)*v;
    v_ort = v-(error/2)*u;
    w_ort = cross(u_ort,v_ort);
    R(:,1) = (1/2)*(3-dot(u_ort,u_ort))*u_ort;
    R(:,2) = (1/2)*(3-dot(v_ort,v_ort))*v_ort;
    R(:,3) = (1/2)*(3-dot(w_ort,w_ort))*w_ort;
end

