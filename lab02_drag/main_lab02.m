clear all

% Характеристики гвинта Plantraco 100x80
% https://m-selig.ae.illinois.edu/props/volume-2/propDB-volume-2.html#Plantraco

% Геометричні характеристики нормовані
% https://m-selig.ae.illinois.edu/props/volume-2/data/pl_100x80_geom.txt
geom_data = load('pl_100x80_geom.txt');

% Геометричні характеристики гвинта
% Діаметр гвинта [м]
D = 0.102;
% Радіус гвинта [м]
R = D/2;
% Кількість лопатей
n_blades = 2;

% Побудова геометрії гвинта
x_surf=R*[geom_data(:,1),geom_data(:,1)];
y_surf=R*cosd(geom_data(:,3)).*[geom_data(:,2),-geom_data(:,2)]/2;
z_surf=R*sind(geom_data(:,3)).*[geom_data(:,2),-geom_data(:,2)]/2;

% Швидкість обертання [RPM] - оберти за хвилину
RPM = 12000;

% Режим польоту
J=[0:0.1:1.0];
% Швидкість польоту [м/c]
V =J*D*RPM/60;
% густина повітря [кг/м3]
rho = 1.225;

% Початкові масиви
T=zeros(size(V));
M=zeros(size(V));
P=zeros(size(V));

for i=1:length(V);
  disp(i);
  V_forvard = V(i)
  % Розрахунок характеристик гвинта
  [Tv,Mv]= propeller(n_blades,R,geom_data,RPM,V_forvard,rho)
  T(i)=Tv;
  M(i)=Mv;
  P(i)=Mv*RPM/60*2*pi;
end;

% Оцінка ефективності
eta=T./P;
eta(find(eta<0))=0;

% Зовнішній вигляд гвинта
figure(1)
surf(x_surf,y_surf,z_surf);
hold on;
surf(-x_surf,y_surf,-z_surf);
hold off;
axis equal;
view(3);
title("Propeller");

% Аеродинамічні коефіцієнти гвинта
figure(2)
alpha=[-90:1:90];
cl = cl_flat(alpha);
cd = cd_flat(alpha);
subplot(1,2,1);
plot(alpha,cl);
hold on;
plot(alpha,cd);
hold off;
grid on;
xlabel("Angle of attack");
legend("Cl","Cd");
subplot(1,2,2);
plot(cd,cl);
xlabel("C_d");
ylabel("C_l");
axis equal
title("Polar");
grid on;

% характеристики гвинта
figure(3)
subplot(2,1,1);
plot(V,T);
xlabel("V, [м/с]");
ylabel("T, [Н]");
title("Тяга гвинта");
grid on;
subplot(2,1,2);
plot(V,P);
xlabel("V, [м/с]");
ylabel("P, [Вт]");
title("Споживана потужність");
grid on;

% Ефективність гвинта
JF=[0:0.01:1.0];
figure(4)
plot(JF,interp1(J,eta,JF,"pchip"));
xlabel('J');
ylabel('\eta');
title("Коефіцієнт корисної дії");
grid on;




