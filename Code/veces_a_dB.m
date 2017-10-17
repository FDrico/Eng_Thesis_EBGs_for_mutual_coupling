% Esta función convierte la ganancia y directividad de veces a dB

function db_vector = veces_a_dB(gain,rmin)

  for i = 1:length(gain)
    if gain(i) == 0  % Para no realizar un logaritmo de 0
      db_vector(i) = rmin;
    else
      db_vector(i) = 10*log10(gain(i));
    end
    if db_vector(i) < rmin
      db_vector(i) = rmin;
    end
  end