function c = sound_speed_air(T)
% Speed of sound in air at absolute temperature T
    R = 8.3144621; % Gas constant, J / (mol * K)
    gamma = 7 / 5; % Adiabatic index for 2-atom gases
    M = 28.98e-3; % Molar mass of air, kg / mol
    c = sqrt(gamma * R * T / M);
end

