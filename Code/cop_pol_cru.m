% Esta función calcula la copolarización (y) y polarización cruzada (x) en
% función de las componentes tita y phi de los campos

function [ex ey] = cop_pol_cru(et,ep,rmin,tita,ang)

  ex = et.*cos(tita)*cos(ang) - ep*sin(ang);
  ey = et.*cos(tita)*sin(ang) + ep*cos(ang);
  ex = (abs(ex)).^2;
  ey = (abs(ey)).^2;
  maximo = max([max(ex) max(ey)]);
  ex = ex/maximo;
  ey = ey/maximo;
  ex = veces_a_dB(ex,rmin);
  ey = veces_a_dB(ey,rmin);