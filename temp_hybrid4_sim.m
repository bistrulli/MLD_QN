function [xn, d, z, y] = temp_hybrid4_sim(x, u, params)
% [xn, d, z, y] = temp_hybrid4_sim(x, u, params)
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

d = zeros(4, 1);
z = zeros(2, 1);
xn = zeros(2, 1);
y = zeros(0, 1);

if (u(2) < 0) | (u(2) > 1)
	error('variable u1 is out of bounds');
end
if (u(1) < -2) | (u(1) > 2)
	error('variable u2 is out of bounds');
end
if (x(1) < -10) | (x(1) > 10)
	error('variable x1 is out of bounds');
end
if (x(2) < -10) | (x(2) > 10)
	error('variable x2 is out of bounds');
end

% d1 = x1 <= -0.5;
within((x(1)) - (-0.5), -9.5, 10.5, 19);
if (x(1)) - (-0.5) <= 0
	d(1) = 1;
else
	d(1) = 0;
end

% d2 = x2 >= 0.3;
within((0.3) - (x(2)), -9.7, 10.3, 20);
if (0.3) - (x(2)) <= 0
	d(2) = 1;
else
	d(2) = 0;
end

% z1 = {IF u1 | d1 THEN 0.5 * u2};
d(3) = (u(2)) | (d(1));

% z2 = {IF d2 & ~d1 THEN 0.8 * u2};
d(4) = (d(2)) & (~d(1));

% z1 = {IF u1 | d1 THEN 0.5 * u2};
if d(3)
	within((0.5) * (u(1)), -1, 1, 22);
	z(1) = (0.5) * (u(1));
else
	within(0, 0, 0, 22);
	z(1) = 0;
end

% z2 = {IF d2 & ~d1 THEN 0.8 * u2};
if d(4)
	within((0.8) * (u(1)), -1.6, 1.6, 23);
	z(2) = (0.8) * (u(1));
else
	within(0, 0, 0, 23);
	z(2) = 0;
end

% x1 = -0.8 * x1 + 0.5 * x2 + z1;
xn(1) = (((-0.8) * (x(1))) + ((0.5) * (x(2)))) + (z(1));

% x2 = z2;
xn(2) = z(2);

xn=xn(:);
y=y(:);
z=z(:);
d=d(:);


function within(x, lo, hi, line)
 if x<lo | x>hi 
 error(['bounds violated at line ', num2str(line), ' in the hysdel source']); 
 end
