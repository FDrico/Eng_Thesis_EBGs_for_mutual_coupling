% Esta función calcula la intensidad de radiación U en función de los
% ángulos tita y phi

function y = U(theta,phi)

  global dima_m dimb_m dimah_m dimbe_m dimr_m t_ant k;
  chip11 = 1.84118378134065;
  switch t_ant
    case 1
      X = k*dima_m/2*sin(theta)*cos(phi);
      Y = k*dimb_m/2*sin(theta)*sin(phi);
      if X == 0  % Para evitar dividir por cero
        sincX = 1;
      else
        sincX = sin(X)/X;
      end
      if Y == 0  % Para evitar dividir por cero
        sincY = 1;
      else
        sincY = sin(Y)/Y;
      end
      y = (sin(phi)^2 + (cos(theta)*cos(phi))^2)*(sincX*sincY)^2;
    case 2
      X = k*dima_m/2*sin(theta)*cos(phi);
      Y = k*dimb_m/2*sin(theta)*sin(phi);
      if abs(X) == pi/2  % Para evitar dividir por cero
        coscX = - 1/pi;
      else
        coscX = cos(X)/(X^2 - (pi/2)^2);
      end
      if Y == 0  % Para evitar dividir por cero
        sincY = 1;
      else
        sincY = sin(Y)/Y;
      end
      y = (sin(phi)^2 + (cos(theta)*cos(phi))^2)*(coscX*sincY)^2;
    case 3
      Z = k*dima_m*sin(theta);
      if Z == 0  % Para evitar dividir por cero
        bessZ = 0.5;
      else
        bessZ = besselj(1,Z)/Z;
      end
      y = (sin(phi)^2 + (cos(theta)*cos(phi))^2)*(bessZ)^2;
    case 4
      Z = k*dima_m*sin(theta);
      if Z == 0  % Para evitar dividir por cero
        bessZ1 = 0.5;
      else
        bessZ1 = besselj(1,Z)/Z;
      end
      if abs(Z) == chip11  % Para evitar dividir por cero
        bessZ2 = (3*besselj(1,chip11) - besselj(3,chip11))*chip11/8;
      else
        bessZ2 = ((besselj(0,Z) - besselj(2,Z))/2)/(1 - (Z/chip11)^2);
      end
      y = (sin(phi)*bessZ1)^2 + (cos(theta)*cos(phi)*bessZ2)^2;
    case 5
      X = k*dima_m/2*sin(theta)*cos(phi);
      Y = k*dimb_m/2*sin(theta)*sin(phi);
      if abs(X) == pi/2  % Para evitar dividir por cero
        coscX = - 1/pi;
      else
        coscX = cos(X)/(X^2 - (pi/2)^2);
      end
      if Y == 0  % Para evitar dividir por cero
        sincY = 1;
      else
        sincY = sin(Y)/Y;
      end
      y = ((1 + cos(theta))/2*coscX*sincY)^2;
    case 6
      Z = k*dima_m*sin(theta);
      if Z == 0  % Para evitar dividir por cero
        bessZ1 = 0.5;
      else
        bessZ1 = besselj(1,Z)/Z;
      end
      if abs(Z) == chip11  % Para evitar dividir por cero
        bessZ2 = (3*besselj(1,chip11) - besselj(3,chip11))*chip11/8;
      else
        bessZ2 = ((besselj(0,Z) - besselj(2,Z))/2)/(1 - (Z/chip11)^2);
      end
      y = ((1 + cos(theta))/2)^2*...
      ((sin(phi)*bessZ1)^2 + (cos(phi)*bessZ2)^2);
    case 7
      RE = dimr_m*dimbe_m/(dimbe_m - dimb_m);
      X = k*dima_m/2*sin(theta)*cos(phi);
      fint = @(R,th,ph) quad(@(yp) exp(-i*k*(sqrt(R^2 + yp.^2) - R)).*...
      exp(i*k*yp*sin(th)*sin(ph)),-dimbe_m/2,dimbe_m/2);
      if abs(X) == pi/2  % Para evitar dividir por cero
        coscX = - 1/pi;
      else
        coscX = cos(X)/(X^2 - (pi/2)^2);
      end
      F = fint(RE,theta,phi);
      F = abs(F);
      y = ((1 + cos(theta))/2*coscX*F)^2;
    case 8
      RH = dimr_m*dimah_m/(dimah_m - dima_m);
      Y = k*dimb_m/2*sin(theta)*sin(phi);
      fint = @(R,th,ph) quad(@(xp) cos(pi*xp/dimah_m).*...
      exp(-i*k*(sqrt(R^2 + xp.^2) - R)).*exp(i*k*xp*sin(th)*cos(ph)),...
      -dimah_m/2,dimah_m/2);
      if Y == 0  % Para evitar dividir por cero
        sincY = 1;
      else
        sincY = sin(Y)/Y;
      end
      F = fint(RH,theta,phi);
      F = abs(F);
      y = ((1 + cos(theta))/2*sincY*F)^2;
    case 9
      RH = dimr_m*dimah_m/(dimah_m - dima_m);
      RE = dimr_m*dimbe_m/(dimbe_m - dimb_m);
      finte = @(R,th,ph) quad(@(yp) exp(-i*k*(sqrt(R^2 + yp.^2) - R)).*...
      exp(i*k*yp*sin(th)*sin(ph)),-dimbe_m/2,dimbe_m/2);
      finth = @(R,th,ph) quad(@(xp) cos(pi*xp/dimah_m).*...
      exp(-i*k*(sqrt(R^2 + xp.^2) - R)).*exp(i*k*xp*sin(th)*cos(ph)),...
      -dimah_m/2,dimah_m/2);
      FE = finte(RE,theta,phi);
      FH = finth(RH,theta,phi);
      FE = abs(FE);
      FH = abs(FH);
      y = ((1 + cos(theta))/2*FE*FH)^2;
    case 10
      RA = dimr_m*dimah_m/(dimah_m - dima_m);
      fint1 = @(R,th) quad(@(rp) rp.*besselj(0,chip11*rp/dimah_m).*...
      besselj(0,k*rp*sin(th)).*exp(-i*k*(sqrt(R^2 + rp.^2) - R)),0,...
      dimah_m);
      fint2 = @(R,th) quad(@(rp) rp.*besselj(2,chip11*rp/dimah_m).*...
      besselj(2,k*rp*sin(th)).*exp(-i*k*(sqrt(R^2 + rp.^2) - R)),0,...
      dimah_m);
      F1 = fint1(RA,theta);
      F2 = fint2(RA,theta);
      FA = abs(F1 - F2);
      FB = abs(F1 + F2);
      y = ((1 + cos(theta))/2)^2*((sin(phi)*FA)^2 + (cos(phi)*FB)^2);
  end