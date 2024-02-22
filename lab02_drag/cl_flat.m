function CL = cl_flat(angle_of_attack)
% Функція, що повертає коефіціент підйомної сили
% Профіль - пласка пластина;
  angles=[-90 -25 -15 -10 -5 0 5 10  15 25  90];
  lift = [0 -0.05 -0.5 -0.75 -0.5 0 0.5 0.75 0.5 0.05 0];
  CL = interp1(angles,lift,angle_of_attack, "pchip");

