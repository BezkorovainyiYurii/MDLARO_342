function thrust = propeller(n_blades,length_blade,angle_blade,chord_blade,RPM,V_forvard,rho)
% Функція обрахунку тяги ідеалізованого гвинта
% n_blades - кількість лопатей гвинта
% legngth_blade - довжина лопаті (радіус гвинта)
% angle_blade - кут установки лопаті
% chord_blade - хорда лопаті
% RPM - швидкість обертання гвинта
% V_forvard - поступальна швидкість руху гвинта
% rho - щільність повітря

  radial_velocity = @(R) RPM/60*2*pi*R;
  angle_of_attack = @(R) angle_blade-atan2d(V_forvard,radial_velocity(R));
  elementary_thrust = @(R) cl_flat(angle_of_attack(R)).*rho.*radial_velocity(R).^2/2*chord_blade;
  thrust=n_blades*integral(elementary_thrust,0,length_blade);



