Vdd = 1.0;               % supply voltage (V)
CL = 1e-15;              % load capacitance per stage (F)
numStages = 5;           % per oscillator
numRO = [4, 8, 16, 32];  % configurations

% averaged frequencies
f_osc = [5.756e8, 5.389e8, 5.259e8, 5.042e8];  

% dynamic power estimation (simplified)
P = numRO * numStages .* CL .* Vdd.^2 .* f_osc;

% ---- PRINT VALUES ----
fprintf("Estimated Dynamic Power per Configuration:\n");
fprintf("ROs = %2d  -->  Power = %.4e W\n", [numRO; P]);

% ---- PLOT ----
figure;
plot(numRO, P, '-o', 'LineWidth', 1.5)
xlabel('Number of ROs')
ylabel('Estimated Power (W)')
title('Power Consumption vs Number of ROs')
grid on
