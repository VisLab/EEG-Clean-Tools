function [W, Gss, Gds, Hds] = ...
     spherical_interpolate(src, dest, lambda, order, type, tol)
% Caclulate an interpolation matrix for spherical interpolation
%
% W = sphericalSplineInterpolate(src, dest, lambda, order, type, tol)
%
% Inputs:
%  src    - [3 x N] old electrode positions
%  dest   - [3 x M] new electrode positions
%  lambda - [float] regularisation parameter for smoothing the estimates (1e-5)
%  order  - [float] order of the polynomial interpolation to use (4)
%  type - [str] one of; ('spline')
%             'spline' - spherical Spline 
%             'slap'   - surface Laplacian (aka. CSD)
%  tol    - [float] tolerance for the legendre poly approx (1e-7)
%
% Outputs:
%  W      - [M x N] linear mapping matrix between old and new co-ords
%
% Based upon the paper: Perrin89

% Copyright 2009-     by Jason D.R. Farquhar (jdrf@zepler.org)
% Permission is granted for anyone to copy, use, or modify this
% software and accompanying documents, provided this copyright
% notice is retained, and note is made of any changes that have been
% made. This software and documents are distributed without any
% warranty, express or implied. 
%
% Modified by Kay Robbins 8/24/2014: Minor cleanup and simplification
% Warning --- still in progress

if ( nargin < 3 || isempty(lambda) ) lambda = 1e-5; end; %#ok<SEPEX>
if ( nargin < 4 || isempty(order) ) order = 4; end; %#ok<SEPEX>
if ( nargin < 5 || isempty(type)) type = 'spline'; end; %#ok<SEPEX>
if ( nargin < 6 || isempty(tol) ) tol = eps; end; %#ok<SEPEX>

% Map the positions onto the sphere (not using repop, by JMH)
src  = src./repmat(sqrt(sum(src.^2)), size(src, 1), 1);  
dest = dest./repmat(sqrt(sum(dest.^2)), size(dest, 1), 1); 

% Calculate the cosine of the angle between the new and old electrodes. If
% the vectors are on top of each other, the result is 1, if they are
% pointing the other way, the result is -1
cosSS = src'*src;  % angles between source positions
cosDS = dest'*src; % angles between destination positions

% Compute the interpolation matrix to tolerance tol
[Gss] = interpMx(cosSS, order, tol);       % [nSrc x nSrc]
[Gds, Hds] = interpMx(cosDS, order, tol);  % [nDest x nSrc]

% Include the regularisation
if lambda > 0 
    Gss = Gss + lambda*eye(size(Gss));
end

% Compute the mapping to the polynomial coefficients space % [nSrc+1 x nSrc+1]
% N.B. this can be numerically unstable so use the PINV to solve..
muGss = 1;  % Used to improve condition number when inverting. Probably unnecessary
C = [Gss  muGss*ones(size(Gss, 1),1); muGss*ones(1, size(Gss,2)) 0];
iC = pinv(C);

% Compute the mapping from source measurements and positions to destination positions
if ( strcmpi(type, 'spline') )
  W = [Gds ones(size(Gds, 1), 1).*muGss]*iC(:, 1:end-1); % [nDest x nSrc]
elseif (strcmpi(type, 'slap'))
  W = Hds*iC(1:end-1, 1:end-1); % [nDest x nSrc]
end
return;
%--------------------------------------------------------------------------
function [G, H]=interpMx(cosEE, order, tol)
% compute the interpolation matrix for this set of point pairs
if ( nargin < 3 || isempty(tol) ) 
    tol = 1e-10; 
end
G = zeros(size(cosEE)); H = zeros(size(cosEE));
for i = 1:numel(cosEE);
   x = cosEE(i);
   n = 1; Pns1 = 1; Pn = x;       % seeds for the legendre ploy recurrence
   tmp  = ( (2*n + 1) * Pn ) / ((n*n + n).^order);
   G(i) = tmp ;         % 1st element in the sum
   H(i) = (n*n + n)*tmp;  % 1st element in the sum
   dG = abs(G(i)); dH = abs(H(i));
   for n = 2:500; % do the sum
      Pns2 = Pns1; Pns1 = Pn; 
      Pn=((2*n - 1)*x*Pns1 - (n - 1)*Pns2)./n; % legendre poly recurrence
      oGi = G(i);  oHi = H(i);
      tmp = ((2*n+1) * Pn) / ((n*n+n).^order);
      G(i) = G(i) + tmp;             % update function estimate, spline interp     
      H(i) = H(i) + (n*n + n)*tmp;   % update function estimate, SLAP
      dG = (abs(oGi - G(i)) + dG)/2; 
      dH = (abs(oHi - H(i)) + dH)/2; % moving ave gradient est for convergence
      if (dG < tol && dH < tol) 
          break; 
      end;           % stop when tol reached
   end
end
G = G./(4*pi);
H = H./(4*pi);
return;

