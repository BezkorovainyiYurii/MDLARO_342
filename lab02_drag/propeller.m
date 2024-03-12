function [thrust_force,drag_torque] = propeller(n_blades,length_blade,geom_blade,RPM,V_forvard,rho)
% Функція обрахунку тяги ідеалізованого гвинта
% n_blades - кількість лопатей гвинта
% legngth_blade - довжина лопаті (радіус гвинта)
% angle_blade - кут установки лопаті
% chord_blade - хорда лопаті
% RPM - швидкість обертання гвинта
% V_forvard - поступальна швидкість руху гвинта
% rho - щільність повітря

  chord_blade = @(R) length_blade*interp1(geom_blade(:,1),geom_blade(:,2),R/length_blade,'linear',0);
  angle_blade = @(R) interp1(geom_blade(:,1),geom_blade(:,3),R/length_blade,'linear',0);

  radial_velocity = @(R) RPM/60*2*pi*R;
  total_velocity = @(R) sqrt(V_forvard.^2 + radial_velocity(R).^2);
  angle_of_attack = @(R) angle_blade(R)-atan2d(V_forvard,radial_velocity(R));
  elementary_thrust = @(R) cl_flat(angle_of_attack(R)).*rho.*total_velocity(R).^2/2.*chord_blade(R);
  elementary_drag_f = @(R) cd_flat(angle_of_attack(R)).*rho.*total_velocity(R).^2/2.*chord_blade(R);
  elementary_torque = @(R) R.*elementary_drag_f(R);

  thrust_force=n_blades*integral(elementary_thrust,0,length_blade);
  drag_torque=n_blades*integral(elementary_torque,0,length_blade);

