clear all

% характеристики мотора A2212/13T
% аналог  http://www.flybrushless.com/motor/view/206
disp('Характеристика мотора');
Imin = 0.5
Imax = 12
Pmax = 150
Kv = 1000
% повністю заряджена/разряджена батарея 3s
Vmin = 3*3.7
Vmax = 3*4.2
% Експлуатаційні характеристики гвинта GWS 10x6
% http://www.flybrushless.com/prop/view/15
% Аеродинамічні характеристики гвинта GWS 10x6
% https://m-selig.ae.illinois.edu/props/volume-1/propDB-volume-1.html#GWS
D = 0.254




% Оцінка електричних властивостей мотору
% Визначення характеристики струм-потужність
% P = U*I
% При постійній напрузі характеристика має лінійний характер
% P = Kp*I + Pmiss
% I = Imax -> P = Pmax
% I = Imin -> P = Pmin
Pmin = 0;
Kp=(Pmax-Pmin)/(Imax-Imin)
Pmiss=Pmin-Kp*Imin


% Оцінка моментних властивостей мотору
% Визначення характеристики струм-момент
% Характеристики двигуна постійного струму
% T = Ki * i - моментна характеристика
% E = Ke * omega - зворотня ЕДС
% де Kе=Kш - моментна/електрична константа
% Потужність обертового руху
% P = T*omega

% Рівняння в усталеному режимі (omega = const);
% R*i = V - Ke*omega
% де R - опір обмоток
% При постійній напрузі
% P = Pmin -> omega = omega_max, I = Imin, T = Tmin
% P = Pmax -> omega = omega_min, I = Imax, T = Tmax
R = Vmax/Imax

% Оцінка електричної константи
% T = Ki * i - моментна характеристика
% Pm = T*omega - механічна потужність
% Pe = R*I^2 - електрична потужність втрат
% P = Pm+Pe = Kp*I
% Після перетворення
% Kp*I = Ki * I * omega + R*I^2
% Після скорочення
% Kp = Ki * omega + R*I
% I = Imin -> P=Pmin, T = Tmin, omega = omega_max
% I = Imax -> P=Pmax, T = Tmax, omega = omega_min
omega_max = Kv*Vmax*2*pi/60
Ki = (Kp-R*Imin)/omega_max

% Оцінка електричних затрат з урахуванням характеристик гвинта
Cd = 0.0314
rho = 1.225


figure(1)
I = linspace(0,Imax,101);
P = Kp*I+Pmiss;
T = Ki*I;
plot(I,P);
hold on;
plot(I,T);
hold off;
grid on;
xlabel("Струм, А");

