clear all

% характеристики мотора A2212/13T
% аналог  http://www.flybrushless.com/motor/view/206
disp('Характеристики мотора');
Imin = 0.5
Imax = 12
Pmax = 150
Kv = 1000
% повністю заряджена/разряджена батарея 3s
Umin = 3*3.7
Umax = 3*4.2
% Експлуатаційні характеристики гвинта GWS 10x6
% http://www.flybrushless.com/prop/view/15
% Аеродинамічні характеристики гвинта GWS 10x6
% https://m-selig.ae.illinois.edu/props/volume-1/propDB-volume-1.html#GWS
% https://m-selig.ae.illinois.edu/props/volume-1/data/gwsdd_10x6_jb0713_4008.txt
disp('Характеристики гвинта');
% Діаметр
D = 0.254
Kprop =[
0.144   0.0859   0.0378   0.327
0.179   0.0816   0.0381   0.384
0.217   0.0753   0.0373   0.437
0.254   0.0685   0.0359   0.485
0.287   0.0617   0.0340   0.521
0.326   0.0553   0.0321   0.561
0.357   0.0501   0.0305   0.588
0.397   0.0428   0.0280   0.608
0.433   0.0366   0.0257   0.616
0.469   0.0302   0.0234   0.605
0.510   0.0229   0.0206   0.568
0.546   0.0168   0.0182   0.505
0.577   0.0112   0.0158   0.407
0.611   0.0048   0.0131   0.224
0.651   -0.0029   0.0095   -0.195
0.685   -0.0097   0.0065   -1.030
];
J0=Kprop(:,1);
Ct=Kprop(:,2);
Cp=Kprop(:,3);



% Оцінка електричних властивостей мотору
% Визначення характеристики струм-потужність
% P = U*I
% При постійній напрузі характеристика має лінійний характер
% P = Kp*I + Pmiss
% I = Imax -> P = Pmax
% I = Imin -> P = Pmin
Pmin = 0;
Kp=(Pmax-Pmin)/(Imax-Imin)
Pmmin=Pmin-Kp*Imin
Pmmax=Pmax-Kp*Imax
Kmiss=(Pmmax-Pmmin)/(Imax-Imin)



% Оцінка моментних властивостей мотору
% Визначення характеристики струм-момент
% Характеристики двигуна постійного струму
% Q = Ki * i - моментна характеристика
% E = Ke * omega - зворотня ЕДС
% де Kе=Kш - моментна/електрична константа
% Потужність обертового руху
% P = Q*omega

% Рівняння в усталеному режимі (omega = const);
% R*i = V - Ke*omega
% де R - опір обмоток
% При постійній напрузі U = const
% P = Pmin -> omega = omega_max, I = Imin, Q = Qmin
% P = Pmax -> omega = omega_min, I = Imax, Q = Qmax
R = Umax/Imax

% Оцінка електричної константи
% Q = Ki * i - моментна характеристика
% Pm = Q*omega - механічна потужність
% Pe = R*I^2 - електрична потужність втрат
% P = Pm+Pe = Kp*I
% Після перетворення
% Kp*I = Ki * I * omega + R*I^2
% Після скорочення
% Kp = Ki * omega + R*I
% I = Imin -> P=Pmin, Q = Qmin, omega = omega_max
% I = Imax -> P=Pmax, Q = Qmax, omega = omega_min
omega_max = Kv*Umax*2*pi/60
Ki = (Kp-R*Imin)/omega_max

% Діаграма характеристик двигуна по струму
figure(1)
I = linspace(0,Imax,101);
P = Kp*I+Kmiss*I;
Q = Ki*I;
[hax, h1, h2]=plotyy(I,P,I,Q);
grid on;
xlabel("Струм, А");
ylabel(hax(1),"Потужність");
ylabel(hax(2),"Момент");
title("Пускові характеристики двигуна ПС");

% Діаграма характеристик двигуна по обертам
figure(2)
% Перетворення системи рівнянь з допущення постійного струму та обертів
% R*i = V - Ke*omega ->  i = (V-Ke*omega) / R
omega=linspace(0,omega_max,101);
Ke=Ki;
% Розрахунок струмів для зарядженого акумулятора
I_full = (Umax-Ke*omega)/R;
Q_full = Ki*I_full;
Pm_full = Q_full.*omega;
Pe_full = R*I_full.^2;
% Розрахунок струмів для розрядженого акумулятора
I_empty = (Umin-Ke*omega)/R;
Q_empty = Ki*I_empty;
Pm_empty = Q_empty.*omega;
Pe_empty = R*I_empty.^2;

subplot(2,1,1)
plot(omega,I_full);
hold on;
plot(omega,I_empty);
hold off;
grid on;
subplot(2,1,2)

[hax, h1, h2]=plotyy(60*omega/(2*pi),Pe_full,60*omega/(2*pi),Pm_full);
hold on;
[~, h3, h4]=plotyy(60*omega/(2*pi),Pe_empty,60*omega/(2*pi),Pm_empty);
hold off;
xlabel('Оберти, RPM');
ylabel(hax(1),'Електрична потужність, Вт');
ylabel(hax(2),'Механічна потужність, Вт');
title('Характеристики потужності двигуна ПС');
grid on;



% Оцінка електричних затрат з урахуванням характеристик гвинта
% Коефіціент лобового спротиву RC моделі
Cd = 0.0314
% Густина повітря
rho = 1.225

% Максимальна кількість оборотів двигуна
n_max=omega_max/(2*pi);
% Перерахунок режиму гвинта на швидкість польота
V = J0*n_max*D

% Обрахунко сили лобового опору RC моделі літака
Drag = Cd*rho*V.^2/2;
% Обрахунок тяги гвинта
Thrust = Ct.*rho*n_max^2*D^4;

figure(3)
plot(V,Drag,'DisplayName','Лобовий опір');
hold on;
plot(V,Thrust,'DisplayName','Тяга гвинта');
hold off;
xlabel('Швидкість м/с');
ylabel('Сила');
title('Співвідношення сили тяги гвинта та лобового опору (постійні обороти)');
legend();
grid on;

% Обрахунок кривих потужностей двигуна та гвинта

% Формування сітки значень
% VV - швидкість м/с
% oom - оберти рад/с
% Cpp - коефіціент споживаної потужності гвинта
[VV, oom] = meshgrid (V, omega);
[Cpp, ~] = meshgrid (Cp, omega);

% Розрахунок кривої потужності двигуна
I_full = (Umax-Ke*oom)/R;
Q_full = Ki*I_full;
Engine_Power_full = Q_full.*oom;

% Розрахунок кривої споживаної потужності гвинта
nn=oom/(2*pi); % перерахунок обертів рад/с на 1/с
Propeller_Power = Cpp.*rho.*nn.^3*D^5;

figure(4)
mesh(VV,nn,Engine_Power_full,'edgecolor',[0,1,0]);
hold on;
mesh(VV,nn,Propeller_Power,'edgecolor',[1,0,0]);
hold off;
xlabel('Швидкість, м/с');
ylabel('Оберти, 1/с');
title('Співвідношення потужностей мотора (зелений) та споживаної гвинтом (червоний)');


% Обрахунок кривих сили лобового опору та тяги гвинта

% Формування сітки значень
% VV - швидкість м/с
% oom - оберти рад/с
% Ctt - коефіціент тяги гвинта
[Ctt, ~] = meshgrid (Ct, omega);

% Розрахунок кривої сили лобового опору
RC_Drag = Cd*rho*VV.^2/2;
% Розрахунок кривої сили тяги гвинта
Propeller_Thrust = Ctt.*rho.*nn.^2*D^4;

figure(5)
mesh(VV,nn,RC_Drag,'edgecolor',[1,0,0]);
hold on;
mesh(VV,nn,Propeller_Thrust,'edgecolor',[0,1,0]);
hold off;
grid on;
xlabel("Швидкість, м/с");
ylabel("Оберти, 1/с");
title('Співвідношення сили тяги гвинта (зелений) та лобового опору RC моделі (червноний)');
view(3);

% Визначення балансувального значення швидкості польоту RC моделі
figure(6)
% Баланс по потужності мотор-гвинт
[Edge_power,~]=contour(VV,nn, Engine_Power_full-Propeller_Power, [0 0]);
% Баланс по тязі  тяга гвинта - опір
Edge_thrust=contour(VV,nn, Propeller_Thrust-RC_Drag, [0 0]);

plot(Edge_power(1,2:end),Edge_power(2,2:end),'DisplayName','Мотор-гвинт');
hold on;
plot(Edge_thrust(1,2:end),Edge_thrust(2,2:end),'DisplayName','Тяга-опір');
hold off;
grid on;
xlabel("Швидкість, м/с");
ylabel("Оберти, 1/с");
legend()
