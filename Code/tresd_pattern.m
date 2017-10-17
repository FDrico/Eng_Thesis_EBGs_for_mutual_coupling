% Esta función genera los diagramas de radiación 3D de la directividad en
% veces y en dBi

function y = tresd_pattern(op,rmin,dir,theta,phi)

  font_size = 16;
  font_name = 'Times';
  D = dir;
  n = 8;  % Número de valores en la barra de colores
  DR = max(max(D));
  % Definición de colores puros usados en el colormap
  azul = [0 0 1];
  cian = [0 1 1];
  verde = [0 1 0];
  amarillo = [1 1 0];
  rojo = [1 0 0];
  ci = 15;  % Intervalos entre los colores puros del colormap
  col_colormap = [azul;cian;verde;amarillo;rojo];
  n_col_puros = length(col_colormap);
  n_colormap = n_col_puros + (n_col_puros - 1)*ci;
  htc = zeros(n_colormap,3);  % Inicialización del colormap "hot to cold"
  for i = 1:n_col_puros
    htc((i-1)*(ci+1)+1,:) = col_colormap(i,:);
  end
  for i = 1:n_col_puros - 1
    vec_aux = htc((i)*(ci+1)+1,:) - htc((i-1)*(ci+1)+1,:);
    ind = find(vec_aux);
    vec_aux(ind);
    for j = 1:ci
      htc((i-1)*(ci+1)+j+1,:) = htc((i-1)*(ci+1)+j,:);
      if vec_aux(ind) == 1
        htc((i-1)*(ci+1)+j+1,ind) = htc((i-1)*(ci+1)+j+1,ind) + 1/(ci+1);
      end
      if vec_aux(ind) == -1
        htc((i-1)*(ci+1)+j+1,ind) = htc((i-1)*(ci+1)+j+1,ind) - 1/(ci+1);
      end      
    end
  end
  if op == 1
    D_color = D;
    bar_tick = linspace(0,DR,n);
    colorbar_lim = [0 DR];
    bar_title = 'Directividad (veces)';
  else
    D = D - rmin;
    D_color = D + rmin;
    bar_tick = linspace(rmin,DR,n);
    colorbar_lim = [rmin DR];
    bar_title = 'Directividad (dBi)';
  end
  % Conversión de datos a coordenadas cartesianas
  X = D.*sin(theta).*cos(phi);
  Y = D.*sin(theta).*sin(phi);
  Z = D.*cos(theta);
  colormap(htc);  % Se asigna el colormap creado
  % Se grafican los datos, sin las líneas de los límites de las áreas
  surf(X,Y,Z,D_color,'EdgeColor','none');
  shading interp;  % Interpola los colores del colormap
  material dull;  % Altera la reflectancia. NO FUNCIONA EN OCTAVE
  camlight(90,0);  % Agrega luz. NO FUNCIONA EN OCTAVE
  lighting gouraud;  % Algoritmo de iluminación. NO FUNCIONA EN OCTAVE
  view(60,15);  % Ángulo azimutal y de elevación de la vista 3D
  for i = 1:n
    color_lab{i} = num2str(bar_tick(i),'%2.1f');
    color_lab{i}(length(color_lab{i}) - 1) = ',';
  end
  caxis(colorbar_lim);  % Define los límites de la escala de colores
  c = colorbar('FontSize',font_size,'FontName',font_name,...
  'XAxisLocation','top','Location','WestOutside');
  % Definición de límites y etiquetas de la barra de colores
  set(c,'YTick',bar_tick,'YTickLabel',color_lab,'YLim',colorbar_lim,...
  'YAxisLocation','left');
  %set(gcf,'Renderer','zbuffer');  % Para ver la colorbar en MATLAB R14
  % Dimensionamiento de la barra de colores
  cpos = get(c,'Position');
  cpos(2)= (cpos(4) - cpos(2))/2 + cpos(2);
  cpos(4) = cpos(4)/2;
  set(c,'Position',cpos);
  xlabel(c,bar_title,'FontSize',font_size,'FontName',font_name);
  % Desplazamiento del título de la barra de colores
  pos_tit_col = get(c,'XLabel');
  set(pos_tit_col,'Position',get(pos_tit_col,'Position') + [-0.3 5 0]);
  axis('equal');
  axis('off');
  rotate3d on;  % NO FUNCIONA EN OCTAVE