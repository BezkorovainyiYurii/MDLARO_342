function CD = cd_flat(angle_of_attack)
% Функція, що повертає коефіціент опору
% Профіль - пласка пластина;
  cd0=0.01;
  angles=[-90 -25 -10 0 10  25  90];
  drag = [1.26 0.5 0.1 0 0.1  0.5 1.26];
  CD = cd0+ interp1(angles,drag,angle_of_attack, "pchip");

