% Esta función es utilizada para calcular el ancho del haz principal a
% potencia media (HPBW)

function y = hpbw(plano)

  db_hpbw = 10*log10(0.5);  % dB a potencia media
  error_max = 0.001;  % Error máximo en el cálculo del HPBW (dB)
  tita = 0;  % Valor de tita inicial
  tita_int = 5;  % Intervalo de tita barrido (grados)
  tita_int = tita_int*pi/180;  % Intervalo de tita barrido (radianes)
  val_max = U(0,0);  % Valor máximo
  ang_sta = 'a';  % Inicialmente, el ángulo de barrido se incrementa
  if plano == 'e'
    phi = pi/2;
  elseif plano == 'h'
    phi = 0;
  else
    error('Debe ingresar ''e'' para Plano E o ''h'' para Plano H.');
  end
  error_act = -db_hpbw;  % Error actual
  while abs(error_act) > error_max
    % Aumentó tita y aún no se llega a 3 dB
    if (error_act > error_max) && (ang_sta == 'a')
      tita = tita + tita_int;  % Se debe seguir aumentando tita
    % Bajó tita y aún no se llega a 3 dB
    elseif (error_act < error_max) && (ang_sta == 'b')
      tita = tita - tita_int;   % Se debe seguir bajando tita
    % Aumentó tita y se pasó de 3 dB
    elseif (error_act < error_max) && (ang_sta == 'a')
      tita_int = tita_int/2;
      tita = tita - tita_int;
      ang_sta = 'b';  % Se debe bajar tita
    % Bajó tita y se pasó de 3 dB
    elseif (error_act > error_max) && (ang_sta == 'b')
      tita_int = tita_int/2;
      tita = tita - tita_int;
      ang_sta = 'a';  % Se debe aumentar tita
    end
    val_act = U(tita,phi);
    val_act = 10*log10(val_act/val_max);
    error_act = val_act - db_hpbw;
  end
  y = 2*tita*180/pi;