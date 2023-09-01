function [xn, d, z, y] = temp_bm99_sim(x, u, params)
% [xn, d, z, y] = temp_bm99_sim(x, u, params)
% simulates the hybrid system one step ahead.
% Parameters:
%   x: current state
%   u: input
%   params: structure containing values for
%           all symbolic parameters
% Output:
%   xn: state in the next timestep
%   u: output
%   d, z: Boolean and real auxiliary variables
%
% HYSDEL 2.0.5 (Build: 20111112)
% Copyright (C) 1999-2002  Fabio D. Torrisi
% 
% HYSDEL comes with ABSOLUTELY NO WARRANTY;
% HYSDEL is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public
% License as published by the Free Software Foundation; either
% version 2 of the License, or (at your option) any later version.
if ~exist('x', 'var')
	error('error:  current state x not supplied');
end
x=x(:);
if ~all (size(x)==[2 1])
	error('error: state vector has wrong dimension');
end
if ~exist('u', 'var')
	error('error: input u not supplied');
end
u=u(:);
if ~all (size(u)==[1 1])
	error('error: input vector has wrong dimension');
end

d = zeros(1, 1);
z = zeros(2, 1);
xn = zeros(2, 1);
y = zeros(1, 1);

if (u(1) < -1.1) | (u(1) > 1.1)
	error('variable u is out of bounds');
end
if (x(1) < -10) | (x(1) > 10)
	error('variable x1 is out of bounds');
end
if (x(2) < -10) | (x(2) > 10)
	error('variable x2 is out of bounds');
end

% sign = x1 <= 0;
within((x(1)) - (0), -10, 10, 28);
if (x(1)) - (0) <= 0
	d(1) = 1;
else
	d(1) = 0;
end

% z1 = {IF sign THEN 0.8 * (C * x1 + S * x2) ELSE 0.8 * (C * x1 - S * x2)};
if d(1)
	within((0.8) * (((0.499997879272546) * (x(1))) + ((0.866026628183543) * (x(2)))), -10.9281960596487, 10.9281960596487, 30);
	z(1) = (0.8) * (((0.499997879272546) * (x(1))) + ((0.866026628183543) * (x(2))));
else
	within((0.8) * (((0.499997879272546) * (x(1))) - ((0.866026628183543) * (x(2)))), -10.9281960596487, 10.9281960596487, 30);
	z(1) = (0.8) * (((0.499997879272546) * (x(1))) - ((0.866026628183543) * (x(2))));
end

% z2 = {IF sign THEN 0.8 * (-S * x1 + C * x2) ELSE 0.8 * (S * x1 + C * x2)};
if d(1)
	within((0.8) * (((-0.866026628183543) * (x(1))) + ((0.499997879272546) * (x(2)))), -10.9281960596487, 10.9281960596487, 32);
	z(2) = (0.8) * (((-0.866026628183543) * (x(1))) + ((0.499997879272546) * (x(2))));
else
	within((0.8) * (((0.866026628183543) * (x(1))) + ((0.499997879272546) * (x(2)))), -10.9281960596487, 10.9281960596487, 32);
	z(2) = (0.8) * (((0.866026628183543) * (x(1))) + ((0.499997879272546) * (x(2))));
end

% x1 = z1;
xn(1) = z(1);

% x2 = z2 + u;
xn(2) = (z(2)) + (u(1));

% y = x2;
y(1) = x(2);

xn=xn(:);
y=y(:);
z=z(:);
d=d(:);


function within(x, lo, hi, line)
 if x<lo | x>hi 
 error(['bounds violated at line ', num2str(line), ' in the hysdel source']); 
 end
