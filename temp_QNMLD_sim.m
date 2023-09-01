function [xn, d, z, y] = temp_QNMLD_sim(x, u, params)
% [xn, d, z, y] = temp_QNMLD_sim(x, u, params)
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
if ~all (size(u)==[2 1])
	error('error: input vector has wrong dimension');
end

d = zeros(2, 1);
z = zeros(2, 1);
xn = zeros(2, 1);
y = zeros(2, 1);

if (u(1) < 0) | (u(1) > 10)
	error('variable u1 is out of bounds');
end
if (u(2) < 0) | (u(2) > 10)
	error('variable u2 is out of bounds');
end
if (x(1) < 0) | (x(1) > 100)
	error('variable x1 is out of bounds');
end
if (x(2) < 0) | (x(2) > 100)
	error('variable x2 is out of bounds');
end

% min1 = (x1 - u1) <= 0;
within(((x(1)) - (u(1))) - (0), -10, 100, 33);
if ((x(1)) - (u(1))) - (0) <= 0
	d(1) = 1;
else
	d(1) = 0;
end

% min2 = (x2 - u2) <= 0;
within(((x(2)) - (u(2))) - (0), -10, 100, 34);
if ((x(2)) - (u(2))) - (0) <= 0
	d(2) = 1;
else
	d(2) = 0;
end

% z1 = {IF min1 THEN mu1 * x1 ELSE mu1 * u1};
if d(1)
	within((1) * (x(1)), 0, 100, 36);
	z(1) = (1) * (x(1));
else
	within((1) * (u(1)), 0, 10, 36);
	z(1) = (1) * (u(1));
end

% z2 = {IF min2 THEN mu2 * x2 ELSE mu2 * u2};
if d(2)
	within((1) * (x(2)), 0, 100, 38);
	z(2) = (1) * (x(2));
else
	within((1) * (u(2)), 0, 10, 38);
	z(2) = (1) * (u(2));
end

% x1 = (-z1 + z2) * Ts + x1;
xn(1) = (((-z(1)) + (z(2))) * (0.1)) + (x(1));

% x2 = (z1 - z2) * Ts + x2;
xn(2) = (((z(1)) - (z(2))) * (0.1)) + (x(2));

% y1 = x1;
y(1) = x(1);

% y2 = x2;
y(2) = x(2);

xn=xn(:);
y=y(:);
z=z(:);
d=d(:);


function within(x, lo, hi, line)
 if x<lo | x>hi 
 error(['bounds violated at line ', num2str(line), ' in the hysdel source']); 
 end
