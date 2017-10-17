% ------------------------------------------------------------------------
% antenas_abertura.m
% ------------------------------------------------------------------------
% A partir de la selección de una antena de abertura que cumple la función
% de alimentador de una antena parabólica, el programa determina sus
% características de radiación a partir de un método numérico basado en la
% óptica geométrica.
% ------------------------------------------------------------------------
% TIPO DE ANTENA DE ABERTURA:
% ------------------------------------------------------------------------
% 1.  Abertura rectangular con plano conductor perfecto de extensión
%     infinita y excitación con campo uniforme.
% 2.  Abertura rectangular con plano conductor perfecto de extensión
%     infinita y excitación con campo sinusoidal en modo dominante.
% 3.  Abertura circular con plano conductor perfecto de extensión infinita
%     y excitación con campo uniforme.
% 4.  Abertura circular con plano conductor perfecto de extensión infinita
%     y excitación con campo sinusoidal en modo dominante.
% 5.  Guía de onda rectangular con extremo abierto.
% 6.  Guía de onda cilíndrica con extremo abierto.
% 7.  Bocina sectorial E.
% 8.  Bocina sectorial H.
% 9.  Bocina piramidal.
% 10. Bocina cónica.
% ------------------------------------------------------------------------
% PARÁMETROS DE ENTRADA:
% ------------------------------------------------------------------------
% Frecuencia de operación (Hz)
% Dimensiones del reflector parabólico (cm)
% Dimensiones de la antena de abertura seleccionada (cm)
% ------------------------------------------------------------------------
% PARÁMETROS DE SALIDA:
% ------------------------------------------------------------------------
% Directividad D0 (dBi)
% Ancho de haz principal a media potencia para el plano E (grados)
% Ancho de haz principal a media potencia para el plano H (grados)
% Ángulo de abertura (grados)
% Ganancia normalizada necesaria en el ángulo de abertura (dB)
% Ganancia normalizada en el ángulo de abertura para el plano E (dB)
% Ganancia normalizada en el ángulo de abertura para el plano H (dB)
% Relación de polarización cruzada para phi = 45° (dB)
% Ángulo tita de maxima polarización cruzada para phi = 45° (grados)
% ------------------------------------------------------------------------
% GRÁFICOS:
%   - Polar (dB)
%     1. Diagrama de radiación, plano E
%     2. Diagrama de radiación, plano H
%     3. Diagrama de radiación normalizado, plano E
%     4. Diagrama de radiación normalizado, plano H
%     5. Diagrama de radiación, ángulo de abertura
%     6. Diagrama de radiación normalizado, ángulo de abertura
%   - Cartesiano (dB)
%     7. Copolarización y polarización cruzada, phi = 45°
%   - 3D (dB)
%     8. Diagrama de radiación
% ------------------------------------------------------------------------

function antenas_abertura

  clear all;
  close all;
  format long;
  global dima_m dimb_m dimah_m dimbe_m dimr_m t_ant k angfprad PRAD UMAX;
  % Introducción de la frecuencia de operación
  frec = input('\nIngrese la frecuencia de operación (Hz) = ');
  c = 3e8;  % Velocidad de propagación en el vacío (m/s)
  lambda = c/frec;  % Longitud de onda (m)
  k = 2*pi/lambda;  % Constante de propagación
  % Introducción de las dimensiones del reflector parabólico
  fprintf('\nIngrese las dimensiones del reflector parabólico\n\t');
  diam = input('Diámetro (cm) = ');
  fprintf('\t');
  prof = input('Profundidad (cm) = ');
  fprintf('\t');
  foco = input('Distancia focal (cm) = ');
  % Distancia entre el foco y el perímetro del reflector (cm)
  dfp = sqrt((diam/2)^2 + (foco - prof)^2);
  % Ángulo de abertura (radianes)
  angfprad = atan(diam/(2*(foco - prof)));
  % Ángulo de  abertura (grados)
  angfpgra = angfprad*180/pi;
  % Ganancia normalizada necesaria en el ángulo de abertura (dB)
  gangabn = -11 - 20*log10(foco/dfp);
  % Selección de la antena de abertura
  fprintf('\nSeleccione el tipo de antena de abertura:\n');
  fprintf('\n1.  Abertura rectangular con plano conductor perfecto de');
  fprintf(' extensión infinita y excitación con campo uniforme');
  fprintf('\n2.  Abertura rectangular con plano conductor perfecto de');
  fprintf(' extensión infinita y excitación con campo sinusoidal en');
  fprintf(' modo dominante');
  fprintf('\n3.  Abertura circular con plano conductor perfecto de');
  fprintf(' extensión infinita y excitación con campo uniforme');
  fprintf('\n4.  Abertura circular con plano conductor perfecto de');
  fprintf(' extensión infinita y excitación con campo sinusoidal en');
  fprintf(' modo dominante');
  fprintf('\n5.  Guía de onda rectangular con extremo abierto');
  fprintf('\n6.  Guía de onda cílindrica con extremo abierto');
  fprintf('\n7.  Bocina sectorial E');
  fprintf('\n8.  Bocina sectorial H');
  fprintf('\n9.  Bocina piramidal');
  fprintf('\n10. Bocina cónica');
  t_ant = input('\n\nAntena de abertura seleccionada: ');
  % Introducción de las dimensiones de la antena 
  dima_cm = 0;
  dimb_cm = 0;
  dimah_cm = 0;
  dimbe_cm = 0;
  dimr_cm = 0;
  switch t_ant
    case 1
      fprintf('\nIngrese las dimensiones de la abertura\n\t');
      dima_cm = input('a (cm) = ');
      fprintf('\t');
      dimb_cm = input('b (cm) = ');
    case 2
      fprintf('\nIngrese las dimensiones de la abertura\n\t');
      dima_cm = input('a (cm) = ');
      fprintf('\t');
      dimb_cm = input('b (cm) = ');
    case 3
      fprintf('\nIngrese el diámetro de la abertura\n\t');
      dima_cm = (input('d (cm) = '))/2;
    case 4
      fprintf('\nIngrese el diámetro de la abertura\n\t');
      dima_cm = (input('d (cm) = '))/2;
    case 5
      fprintf('\nIngrese las dimensiones de la guía de onda\n\t');
      dima_cm = input('a (cm) = ');
      fprintf('\t');
      dimb_cm = input('b (cm) = ');
    case 6
      fprintf('\nIngrese el diámetro de la guía de onda\n\t');
      dima_cm = (input('d (cm) = '))/2;
    case 7
      fprintf('\nIngrese las dimensiones de la guía de onda\n\t');
      dima_cm = input('a (cm) = ');
      fprintf('\t');
      dimb_cm = input('b (cm) = ');
      fprintf('\nIngrese las dimensiones de la abertura\n\t');
      dimbe_cm = input('B (cm) = ');
      fprintf('\nIngrese la distancia entre la guía de onda y la');
      fprintf(' abertura\n\t');
      dimr_cm = input('R (cm) = ');
    case 8
      fprintf('\nIngrese las dimensiones de la guía de onda\n\t');
      dima_cm = input('a (cm) = ');
      fprintf('\t');
      dimb_cm = input('b (cm) = ');
      fprintf('\nIngrese las dimensiones de la abertura\n\t');
      dimah_cm = input('A (cm) = ');
      fprintf('\nIngrese la distancia entre la guía de onda y la');
      fprintf(' abertura\n\t');
      dimr_cm = input('R (cm) = ');
    case 9
      fprintf('\nIngrese las dimensiones de la guía de onda\n\t');
      dima_cm = input('a (cm) = ');
      fprintf('\t');
      dimb_cm = input('b (cm) = ');
      fprintf('\nIngrese las dimensiones de la abertura\n\t');
      dimah_cm = input('A (cm) = ');
      fprintf('\t');
      dimbe_cm = input('B (cm) = ');
      fprintf('\nIngrese la distancia entre la guía de onda y la');
      fprintf(' abertura\n\t');
      dimr_cm = input('R (cm) = ');
    case 10
      fprintf('\nIngrese el diámetro de la guía de onda\n\t');
      dima_cm = (input('d (cm) = '))/2;
      fprintf('\nIngrese el diámetro de la abertura\n\t');
      dimah_cm = (input('D (cm) = '))/2;
      fprintf('\nIngrese la distancia entre la guía de onda y la');
      fprintf(' abertura\n\t');
      dimr_cm = input('R (cm) = ');
    otherwise
      error('Valor ingresado incorrecto.')
  end
  dima_m = dima_cm/100;  % Dimensión de a (m)
  dimb_m = dimb_cm/100;  % Dimensión de b (m)
  dimah_m = dimah_cm/100;  % Dimensión de A (m)
  dimbe_m = dimbe_cm/100;  % Dimensión de B (m)
  dimr_m = dimr_cm/100;  % Dimensión de R (m)
  % Cálculo del ancho de haz principal
  ancho_haz_e = hpbw('e');
  ancho_haz_h = hpbw('h');
  % Cálculo numérico de la directividad mediante Suma de Riemann
  % Definición de constantes e inicialización
  PRAD = 0;
  UMAX = U(0,0);
  UMIN = UMAX;
  % Límites de lectura inferior y superior de tita y phi
  TL = 0;  % Tita inicial
  PL = 0;  % Phi inicial
  PU = 360;  % Phi final
  if any(t_ant == [1 2 3 4])
    TU = 90;  % Tita final con plano de tierra perfecto infinito
  else
    TU = 180;  % Tita final sin plano de tierra perfecto infinito
  end
  % Programa principal
  DELTATHETA = pi/180;
  DELTAPHI = pi/180;
  PLL = PL + 1;
  while PLL <= PU
    XJ = PLL*pi/180;  % Ángulo barrido phi (radianes)
    TLL = TL + 1;
      while TLL <= TU
        XI = TLL*pi/180;  % Ángulo barrido tita (radianes)
        F = U(XI,XJ);
        if F > UMAX
          UMAX = F;
        end
        if F < UMIN
          UMIN = F;
        end
        UA = DELTATHETA*DELTAPHI*F*sin(XI);
        PRAD = PRAD + UA;
        TLL = TLL + 1;
      end
    PLL = PLL + 1;
  end
  DR = 4*pi*UMAX/PRAD;  % Directividad (veces)
  DRDB = 10*log10(DR);  % Directividad (dBi)
  % Para graficar los diagramas de radiación en los planos E y H
  stheta = 0.1;
  rmin = -30;  % Valor en el centro del diagrama de radiación
  rticks = 4;  % Círculos de los diagramas de radiación
  deg = 30;  % Grados en los que se separa el diagrama de radiación
  if any(t_ant == [1 2 3 4])
    sdeg = -90;
    edeg = 90;
  else
    sdeg = -180;
    edeg = 180;
  end
  i = 1;
  for ii = sdeg:stheta:(edeg - sdeg)/2 + sdeg
    dtheta(i) = ii*pi/180;
    ded(i) = U(dtheta(i),pi/2);
    dhd(i) = U(dtheta(i),0);
    i = i + 1;
  end
  j = 1;
  for ii = (edeg - sdeg)/2 + sdeg + stheta:stheta:edeg
    dtheta(i) = ii*pi/180;
    ded(i) = ded(i - 2*j);
    dhd(i) = dhd(i - 2*j);
    j = j + 1;
    i = i + 1;
  end
  ded = abs(ded);
  ded = 4*pi*ded/PRAD;
  den = ded/max(ded);
  dhd = abs(dhd);
  dhd = 4*pi*dhd/PRAD;
  dhn = dhd/max(dhd);
  ded = veces_a_dB(ded,rmin);
  den = veces_a_dB(den,rmin);
  dhd = veces_a_dB(dhd,rmin);
  dhn = veces_a_dB(dhn,rmin);
  op = 'v';
  rmax = DRDB;
  figure(1);
  polar_dB(op,dtheta,ded,rmin,rmax,rticks,deg);
  title('Diagrama de radiación en el plano \itE\rm (dBi)');
  figure(2);
  polar_dB(op,dtheta,dhd,rmin,rmax,rticks,deg);
  title('Diagrama de radiación en el plano \itH\rm (dBi)');
  rmax = 0;
  figure(3);
  polar_dB(op,dtheta,den,rmin,rmax,rticks,deg);
  title('Diagrama de radiación normalizado en el plano \itE\rm (dB)');
  figure(4);
  polar_dB(op,dtheta,dhn,rmin,rmax,rticks,deg);
  title('Diagrama de radiación normalizado en el plano \itH\rm (dB)');
  % Para graficar el diagrama de radiación en el ángulo de abertura
  sphi = 0.1;
  sdeg = 0;
  edeg = 360;
  i = 1;
  for ii = sdeg:sphi:(edeg - sdeg)/4 + sdeg
    dphi(i) = ii*pi/180;
    dangfpd(i) = U(angfprad,dphi(i));
    i = i + 1;
  end
  j = 1;
  for ii = (edeg - sdeg)/4 + sdeg + sphi:sphi:(edeg - sdeg)/2 + sdeg
    dphi(i) = ii*pi/180;
    dangfpd(i) = dangfpd(i - 2*j);
    j = j + 1;
    i = i + 1;
  end
  j = 1;
  for ii = (edeg - sdeg)/2 + sdeg + sphi:sphi:edeg
    dphi(i) = ii*pi/180;
    dangfpd(i) = dangfpd(i - 2*j);
    j = j + 1;
    i = i + 1;
  end
  dangfpd = abs(dangfpd);
  dangfpd = 4*pi*dangfpd/PRAD;
  dangfpn = dangfpd/DR;
  dangfpd = veces_a_dB(dangfpd,rmin);
  dangfpn = veces_a_dB(dangfpn,rmin);
  op = 'h';
  rmax = DRDB;
  figure(5);
  polar_dB(op,dphi,dangfpd,rmin,rmax,rticks,deg);
  title('Diagrama de radiación en el ángulo \theta_0 (dBi)');
  rmax = 0;
  figure(6);
  polar_dB(op,dphi,dangfpn,rmin,rmax,rticks,deg);
  title('Diagrama de radiación normalizado en el ángulo \theta_0 (dB)');
  % Para graficar la copolarización y la polarización cruzada
  if any(t_ant == [1 2 3 4])
    xmin = -90;
    xmax = 90;
  else
    xmin = -180;
    xmax = 180;
  end
  theta = xmin:0.1:xmax;
  a = (length(dtheta) + 1)/2;
  for i = 1:a
    [E_theta_phi_45(i) E_phi_phi_45(i)] = Etp(dtheta(i),pi/4);
  end
  j = 1;
  a = a + 1;
  for i = a:length(dtheta)
    E_theta_phi_45(i) = E_theta_phi_45(i - 2*j);
    E_phi_phi_45(i) = E_phi_phi_45(i - 2*j);
    j = j + 1;
  end
  ymin = -80;
  [E_phi_45_pol_x E_phi_45_pol_y] = cop_pol_cru(E_theta_phi_45,...
  E_phi_phi_45,ymin,dtheta,pi/4);
  ymax = max([max(E_phi_45_pol_x) max(E_phi_45_pol_y)]);
  figure(7);
  grid on;
  hold on;
  g(1) = plot(theta,E_phi_45_pol_y,'Color','r','LineWidth',2);
  g(2) = plot(theta,E_phi_45_pol_x,'Color','b','LineWidth',2);
  legend(g,'Copolarización (y)','Polarización cruzada (x)');
  hold off;
  title('Copolarización y polarización cruzada para \phi = 45° (dB)');
  xlabel('Ángulo \theta (Grados)');
  ylabel('Amplitud (dB)');
  xlim([xmin xmax]);
  ylim([ymin ymax]);
  set(gca,'XTick',[xmin:15:xmax],'FontName','Times','FontSize',16);
  % Para graficar el diagrama de radiación 3D
  inc_phi = 2.4;
  n_phi = pi*(0:inc_phi:360)/180;
  if any(t_ant == [1 2 3 4])
    inc_theta = 0.6;
    n_theta = pi*(0:inc_theta:90)/180;
  else
    inc_theta = 1.2;
    n_theta = pi*(0:inc_theta:180)/180;
  end
  [theta,phi] = meshgrid(n_theta,n_phi);
  for i = 1:length(n_theta)
    for j = 1:length(n_phi)
      D(i,j) = 4*pi*U(theta(i,j),phi(i,j))/PRAD;
    end
  end
  [fil_D,col_D] = size(D);
  for i = 1:fil_D
    D(i,:) = veces_a_dB(D(i,:),rmin);
  end
  figure(8);
  tresd_pattern(2,rmin,D,theta,phi);
  title('Diagrama de radiación 3D (dBi)');
  % Cálculo de la polarización cruzada máxima
  [pol_cru_max,ind_max_pol_cru] = max(E_phi_45_pol_x);
  pol_cru_max = abs(pol_cru_max);
  ang_pol_cru_max = 180*abs(dtheta(ind_max_pol_cru))/pi;
  % Parámetros de salida
  ind = ((length(dphi) - 1)/4) + 1;
  fprintf('\n----------------------------------------------------------');
  fprintf('-----------------\nParámetros de salida:');
  fprintf('\n----------------------------------------------------------');
  fprintf('-----------------\nDirectividad D0 (dBi)');
  fprintf('                                              = %3.2f',DRDB);
  fprintf('\nAncho de haz principal a media potencia para el plano E');
  fprintf(' (grados)   = %3.2f',ancho_haz_e);
  fprintf('\nAncho de haz principal a media potencia para el plano H');
  fprintf(' (grados)   = %3.2f',ancho_haz_h);
  fprintf('\nÁngulo de abertura (grados)');
  fprintf('                                        = %3.2f',angfpgra);
  fprintf('\nGanancia normalizada necesaria en el ángulo de abertura');
  fprintf(' (dB)       = %3.2f',gangabn);
  fprintf('\nGanancia normalizada en el ángulo de abertura para el');
  fprintf(' plano E (dB) = %3.2f',dangfpn(ind));
  fprintf('\nGanancia normalizada en el ángulo de abertura para el');
  fprintf(' plano H (dB) = %3.2f',dangfpn(1));
  fprintf('\nRelacion de polarización cruzada para phi = 45° (dB)');
  fprintf('               = %3.2f',pol_cru_max);
  fprintf('\nÁngulo tita de máxima polarización cruzada para phi = 45°');
  fprintf(' (grados) = %3.2f\n---------------------',ang_pol_cru_max);
  fprintf('------------------------------------------------------\n\n');