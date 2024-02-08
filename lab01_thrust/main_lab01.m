% Лабораторна робота
% Дослідження властивостей гвинта

% Кількість лопатей
n_blades = 2;
% Швидкість обертання [RPM] - оберти за хвилину
RPM = 1200;
% Радіус гвинта [м]
length_blade = 0.5;
% Хорда лопаті  [м]
chord_blade = 0.05;
% Кут встановлення лопаті гвинта 1 [град]
angle_blade_1 = 5;
% Кут встановлення лопаті гвинта 2 [град]
angle_blade_2 = 45;
% Швидкість польоту [м/c]
V =[0:1:100];
% густина повітря [кг/м3]
rho = 1.225;

% Оцінка аеродинамічноно коефіцієнта підйомної сили
angles_of_attack = [-90:1:90];
lift = cl_flat(angles_of_attack);
figure(1);
plot(angles_of_attack,lift);
xlabel("Кут атаки, град");
ylabel("Коефіціент Сl");
grid on;

thrust_1=zeros(size(V));
thrust_2=zeros(size(V));

for i=1:length(V);
  disp(i);
  V_forvard = V(i);
  % Розрахунок тяги гвинта 1
  thrust_1(i) = propeller(n_blades,length_blade,angle_blade_1,chord_blade,RPM,V_forvard,rho);
  % Розрахунок тяги гвинта 2
  thrust_2(i) = propeller(n_blades,length_blade,angle_blade_2,chord_blade,RPM,V_forvard,rho);
end;

figure(2)
plot(V,thrust_1);
hold on;
plot(V,thrust_2);
hold off;
xlabel("Швидкість, [м/с]")
ylabel("Тяга, [Н]")
legend ("Тяга гвинта 1","Тяга гвинта 2");
grid on;

