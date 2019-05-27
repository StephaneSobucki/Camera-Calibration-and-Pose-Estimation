function [T,X] = normalization2d(X)
n = size(X,1);
u_mean = mean(X(:,1));
v_mean = mean(X(:,2));
s = sqrt(2)*n / (sum(sqrt((X(:,1) - u_mean).^2 + (X(:,2) - v_mean).^2)));
T = s * [1 0 -u_mean
         0 1 -v_mean
         0 0 1/s];
X = (T*X')';
end

