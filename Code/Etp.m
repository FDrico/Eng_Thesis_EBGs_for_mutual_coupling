% Esta función calcula las componentes tita y phi de los campos lejanos en
% función de los angulos tita y phi

function [et ep] = Etp(theta,phi)

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
      et = sin(phi)*sincX*sincY;
      ep = cos(theta)*cos(phi)*sincX*sincY;
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
      et = sin(phi)*coscX*sincY;
      ep = cos(theta)*cos(phi)*coscX*sincY;    
    case 3
      Z = k*dima_m*sin(theta);
      if Z == 0  % Para evitar dividir por cero
        bessZ = 0.5;
      else
        bessZ = besselj(1,Z)/Z;
      end
      et = sin(phi)*bessZ;
      ep = cos(theta)*cos(phi)*bessZ;
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
      et = sin(phi)*bessZ1;
      ep = cos(theta)*cos(phi)*bessZ2;
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
      et = (1 + cos(theta))*sin(phi)*coscX*sincY/2;
      ep = (1 + cos(theta))*cos(phi)*coscX*sincY/2;
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
      et = (1 + cos(theta))*sin(phi)*bessZ1/2;
      ep = (1 + cos(theta))*cos(phi)*bessZ2/2;
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
      et = (1 + cos(theta))*sin(phi)*coscX*F/2;
      ep = (1 + cos(theta))*cos(phi)*coscX*F/2; 
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
      et = (1 + cos(theta))*sin(phi)*sincY*F/2;
      ep = (1 + cos(theta))*cos(phi)*sincY*F/2;
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
      et = (1 + cos(theta))*sin(phi)*FE*FH/2;
      ep = (1 + cos(theta))*cos(phi)*FE*FH/2; 
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
      et = (1 + cos(theta))*sin(phi)*(F1 - F2)/2;
      ep = (1 + cos(theta))*cos(phi)*(F1 + F2)/2;
  end