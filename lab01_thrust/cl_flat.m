function CL = cl_flat(angle_of_attack)
% Функція, що повертає коефіціент підйомної сили
% Профіль - пласка пластина;
  angles=[-90 -11 -10  10  11  90];
  lift = [0 0 -0.75  0.75  0 0];
  CL = interp1(angles,lift,angle_of_attack);

