% Esta función se utiliza para graficar el diagrama de radiación en los
% planos E y H (diagrama vertical) y en el ángulo de abertura (diagrama
% horizontal)

function diapol = polar_dB(op,thetaphi,gain,rmin,rmax,circs,deg)

  global angfprad
  font_size = 16;
  font_name = 'Times';
  deg_dia = [30 45 90];  % Grados de separación del diagrama de radiación
  if all(deg ~= deg_dia)
    deg = 30;
  end
  if circs > 5
    circs = 5;
  end
  if isequal(op,'v') == 0 && isequal(op,'h') == 0
    op = 'v';
  end
  tc = 'k';  % Color de círculos y radios del diagrama de radiación
  hold on;
  % Define un círculo
  thph = 0:pi/100:2*pi;
  xunit = cos(thph);
  yunit = sin(thph);
  % Dibuja los círculos del diagrama de radiación (incluyendo el círculo
  % externo), indicando el valor en dBi (o en dB para diagramas de
  % radiación normalizados) de dichos círculos
  rinc = (rmax - rmin)/circs;
  cir = 1;
  for i = (rmin + rinc):rinc:rmax
    is = i - rmin;
    if cir < circs
      style = ':';
    else
      style = '-';
    end
    plot(xunit*is,yunit*is,style,'color',tc,'linewidth',1);
    dbi_str = num2str(i,'%2.1f');
    dbi_str(length(dbi_str) - 1) = ',';
    text(0,is + rinc/20,['  ' dbi_str,'verticalalignment','bottom',...
    'FontSize',font_size,'FontName',font_name);
    cir = cir + 1;
  end
  % Indica el valor mínimo de referencia en el centro del diagrama de
  % radiación
  dbi_str = num2str(rmin,'%2.1f');
  dbi_str(length(dbi_str) - 1) = ',';
  text(0,rinc/20,['  ' dbi_str],'verticalalignment','bottom',...
  'FontSize',font_size,'FontName',font_name);
  % Dibuja los radios del diagrama de radiación
  thph = (1:180/deg)*2*pi/(360/deg);
  cst = cos(thph);
  snt = sin(thph);
  cs = [-cst; cst];
  sn = [-snt; snt];
  plot((rmax - rmin)*cs,(rmax - rmin)*sn,':','color',tc,'linewidth',1);
  if isequal(op,'v') == 1
    % Dibuja la recta al ángulo de abertura
    costt = [0 0; -sin(angfprad) sin(angfprad)];
    sentt = [0 0; cos(angfprad) cos(angfprad)];
    plot((rmax - rmin)*costt,(rmax - rmin)*sentt,':','color',tc,...
    'linewidth',1);
  end;
  % Dibuja los marcadores de separación de grados en el círculo exterior
  long = (rmax - rmin)/30;  % Longitud de los marcadores
  thph = (0:36)*2*pi/72;
  cst = cos(thph);
  snt = sin(thph);
  cs = [(rmax - rmin - long)*cst;(rmax - rmin)*cst];
  sn = [(rmax - rmin - long)*snt;(rmax - rmin)*snt];
  plot(cs,sn,'-','color',tc,'linewidth',1);
  plot(-cs,-sn,'-','color',tc,'linewidth',1);
  % Introduce los grados de separación del diagrama de radiación sobre el
  % círculo exterior, sobre cada uno de los radios
  rt = 1.1*(rmax - rmin);
  thph = (0:360/deg - 1)*2*pi/(360/deg);
  cst = -cos(thph + pi/2);
  snt = sin(thph + pi/2);
  if isequal(op,'v') == 1
    deg_num = [0:deg:180 - deg 180:-deg:deg];
    text(rt*cos(angfprad + pi/2),rt*sin(angfprad + pi/2),'\theta_0',...
    'horizontalalignment','center','FontSize',font_size,'FontName',...
    font_name);
    text(-rt*cos(angfprad + pi/2),rt*sin(angfprad + pi/2),'\theta_0',...
    'horizontalalignment','center','FontSize',font_size,'FontName',...
    font_name);
  else
    deg_num = 0:deg:360 - deg;
  end
  for i = 1:max(size(thph))
    text(rt*cst(i),rt*snt(i),int2str(deg_num(i)),'horizontalalignment',...
    'center','FontSize',font_size,'FontName',font_name);
  end
  % Se configuran los límites de los ejes para que el gráfico quede en un
  % factor de escala tal que no se superponga con el título
  axis((rmax - rmin)*[-1 1 -1.1 1.1]);
  % Transforma los datos del diagrama de radiación de coordenadas
  % esféricas a coordenadas cartesianas para poder graficar
  for i = 1:length(gain)
    if gain(i) > rmin
      xx(i) = -(gain(i) - rmin)*cos(thetaphi(i) + pi/2);
      yy(i) = (gain(i) - rmin)*sin(thetaphi(i) + pi/2);
    else
      xx(i) = 0;
      yy(i) = 0;
    end
  end
  % Grafica los datos en el diagrama de radiación
  plot(xx,yy,'Color','r','LineWidth',2);
  axis('equal');
  axis('off');
  hold off;