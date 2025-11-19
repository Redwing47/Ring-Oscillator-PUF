% W/L variation analysis
WL = [0.25 0.5 0.75 1.0 1.25];   % multipliers
numRO = 16;                      % assume 16 ROs fixed
numStages = 5;
I_leak_stage_base = 1e-7;        % base leakage per stage (A)

% Leakage proportional to W/L
I_leak_total = WL * numRO * numStages * I_leak_stage_base;

% ---- PRINT VALUES ----
fprintf("Leakage Current vs W/L Multiplier:\n");
fprintf("W/L = %.2f  -->  Leakage = %.4e A (%.3f µA)\n", ...
        [WL; I_leak_total; I_leak_total*1e6]);

% ---- PLOT ----
figure;
plot(WL, I_leak_total*1e6, '-o', 'LineWidth', 1.5);
xlabel('Transistor W/L Multiplier');
ylabel('Total Leakage Current (µA)');
title('Leakage Current vs W/L Ratio');
grid on;
