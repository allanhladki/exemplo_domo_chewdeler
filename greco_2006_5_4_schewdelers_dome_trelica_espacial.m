function[tipo_linear_fisico,tipo_deformacao,tipo_metodo_convergencia,nmax,imax,TOL,LAMBDA,DELTA_L,DELTA_L_0,DELTA_L_MAX,DELTA_L_MIN,comp_arco_variavel,Nd,zeta,plotar_deformada,plotar_trajetoria,plotar_t_d,GDL_trajetoria,Elemento_trajetoria,FE,plotcont,COORDNOS,CONEC,PROPELEM,REST,FC] = greco_2006_5_4_schewdelers_dome_trelica_espacial()

% DEFINIR O TIPO DE ANÁLISE FÍSICA:
% 1 - Análise linear sem limite de escoamento - Lei de Hooke;
% 2 - Análise não linear física - Modelo bilinear;
tipo_linear_fisico = 2;




% DEFINIR O TIPO DE DEFORMAÇÃO UTILIZADA:
% 1 - Deformação de Engenharia;
% 2 - Deformação de Green;
% 3 - Deformação Logaritmica sem mudança de volume;
% 4 - Deformação Logaritmica com mudança de volume - OBS: Somente utilizar dentro do limite de escoamento;
tipo_deformacao = 1;




% DEFINIR O TIPO DE MÉTODO DE CONVERGÊNCIA
% 1 - Método de Newton-Raphson;
% 2 - Método de Newton-Raphson Modificado;
% 3 - Método do Comprimento de Arco de Riks-Wempner - NRM;
tipo_metodo_convergencia = 3;


%{
MELHOR CONVERGÊNCIA - LINEAR FÍSICO
Dados de entrada para o método incremetal-iterativo
nmax = 14500;                  % Número máximo de incrementos; 
imax = 20;                  % Número máximo de iterações;
TOL = 1e-3;                % Tolerância da convergência;
LAMBDA = 0;                 % Fator de carga (SOMENTO PARA O MÉTODO DO COMP. DE ARCO);
DELTA_L = 0.1;             % Comprimento de arco inicial (SOMENTE PARA O MÉTODO DO COMP. DE ARCO);     
DELTA_L_0 = DELTA_L;        % Comprimento de arco fixo para ajuste do comprimento de cada incremento (SOMENTE PARA O MÉTODO DO COMP. DE ARCO);
DELTA_L_MAX = 0.75;            % Maior valor possível para o comprimento de arco;
DELTA_L_MIN = 0.01;         % Menor valor possível para o comprimento de arco; 
comp_arco_variavel = 1;     % Ajuste do comprimento de arco (1 - DELTA_L VARIÁVEL ¨¨¨¨¨ 0 -> DELTA_L FIXO);
Nd = 3;                     % Número desejado de iterações para cada ciclo (SOMENTE PARA MÉTODO DE COMPRIMENTO DE ARCO);
zeta = 0.5;                 % Fator da razão Nd/(Ni-1) (SOMENTE PARA MÉTODO DE COMPRIMENTO DE ARCO);
%}




% Dados de entrada para o método incremetal-iterativo
nmax = 6000;                  % Número máximo de incrementos; 
imax = 10;                  % Número máximo de iterações;
TOL = 1e-3;                % Tolerância da convergência;
LAMBDA = 0;                 % Fator de carga (SOMENTO PARA O MÉTODO DO COMP. DE ARCO);
DELTA_L = 0.25;             % Comprimento de arco inicial (SOMENTE PARA O MÉTODO DO COMP. DE ARCO);     
DELTA_L_0 = DELTA_L;        % Comprimento de arco fixo para ajuste do comprimento de cada incremento (SOMENTE PARA O MÉTODO DO COMP. DE ARCO);
DELTA_L_MAX = 1;            % Maior valor possível para o comprimento de arco;
DELTA_L_MIN = 0.01;         % Menor valor possível para o comprimento de arco; 
comp_arco_variavel = 1;     % Ajuste do comprimento de arco (1 - DELTA_L VARIÁVEL ¨¨¨¨¨ 0 -> DELTA_L FIXO);
Nd = 3;                     % Número desejado de iterações para cada ciclo (SOMENTE PARA MÉTODO DE COMPRIMENTO DE ARCO);
zeta = 0.5;                 % Fator da razão Nd/(Ni-1) (SOMENTE PARA MÉTODO DE COMPRIMENTO DE ARCO);




% Dados de entrada para saida visual
plotar_deformada = 0;       % Plotagem da treliça na configuração deformada (1 -> PLOTAR ¨¨¨¨¨ 0 -> NÃO PLOTAR);
plotar_trajetoria = 1;      % Plotagem da trajetória de equilibrio para o GDL_trajetoria (1 -> PLOTAR ¨¨¨¨¨ 0 -> NÃO PLOTAR);
plotar_t_d = 0;             % Plotagem do grafico de tensão x deformação para o Elemento_trajetoria (1 -> PLOTAR ¨¨¨¨¨ 0 -> NÃO PLOTAR);
GDL_trajetoria = 3;       % Grau de liberdade acompanhado na trajetória de equilibrio gráfica;
Elemento_trajetoria = 1;    % Elemento acompanhado na trajetoria de tensão x deformação;
FE = 1;                    % Fator de escala para plotagem da configuração deformada;
plotcont = 250;               % Número de incrementos entre cada plotagem da configuração deformada;


% GEOMETRIA

% Coordenadas dos nós - [coordX (cm), coordY (cm), coordZ (cm)]

COORDNOS = [0.0000,	    0.0000,     458.0000;
            0.0000,	  878.0000,     427.0000;
          227.2431,	  848.0829,     427.0000;
          439.0000,	  760.3703,     427.0000;
          620.8398,	  620.8398,     427.0000;
          760.3703,	  439.0000,     427.0000;
          848.0829,	  227.2431,     427.0000;
          878.0000,	    0.0000,     427.0000;
          848.0829,	 -227.2431,     427.0000;
          760.3703,	 -439.0000,     427.0000;
          620.8398,	 -620.8398,     427.0000;
          439.0000,	 -760.3703,     427.0000;
          227.2431,	 -848.0829,     427.0000;
            0.0000,	 -878.0000,     427.0000;
         -227.2431,	 -848.0829,     427.0000;
         -439.0000,	 -760.3703,     427.0000;
         -620.8398,	 -620.8398,     427.0000;
         -760.3703,	 -439.0000,     427.0000;
         -848.0829,	 -227.2431,     427.0000;
         -878.0000,	    0.0000,     427.0000;
         -848.0829,	  227.2431,     427.0000;
         -760.3703,	  439.0000,     427.0000;
         -620.8398,	  620.8398,     427.0000;
         -439.0000,	  760.3703,     427.0000;
         -227.2431,	  848.0829,     427.0000;
            0.0000,	 1641.0000,     326.0000;
          424.7221,	 1585.0843,     326.0000;
          820.5000,	 1421.1477,     326.0000;
         1160.3622,	 1160.3622,     326.0000;
         1421.1477,	  820.5000,     326.0000;
         1585.0843,	  424.7221,     326.0000;
         1641.0000,	    0.0000,     326.0000;
         1585.0843,	 -424.7221,     326.0000;
         1421.1477,	 -820.5000,     326.0000;
         1160.3622,	-1160.3622,     326.0000;
          820.5000,	-1421.1477,     326.0000;
          424.7221,	-1585.0843,     326.0000;
            0.0000,	-1641.0000,     326.0000;
         -424.7221,	-1585.0843,     326.0000;
         -820.5000,	-1421.1477,     326.0000;
        -1160.3622,	-1160.3622,     326.0000;
        -1421.1477,	 -820.5000,     326.0000;
        -1585.0843,	 -424.7221,     326.0000;
        -1641.0000,	    0.0000,     326.0000;
        -1585.0843,	  424.7221,     326.0000;
        -1421.1477,	  820.5000,     326.0000;
        -1160.3622,	 1160.3622,     326.0000;
         -820.5000,	 1421.1477,     326.0000;
         -424.7221,	 1585.0843,     326.0000;
            0.0000,	 2137.0000,     179.0000;
          553.0963,	 2064.1835,     179.0000;
         1068.5000,	 1850.6963,     179.0000;
         1511.0872,	 1511.0872,     179.0000;
         1850.6963,	 1068.5000,     179.0000;
         2064.1835,	  553.0963,     179.0000;
         2137.0000,	    0.0000,     179.0000;
         2064.1835,	 -553.0963,     179.0000;
         1850.6963,	-1068.5000,     179.0000;
         1511.0872,	-1511.0872,     179.0000;
         1068.5000,	-1850.6963,     179.0000;
          553.0963,	-2064.1835,     179.0000;
            0.0000,	-2137.0000,     179.0000;
         -553.0963,	-2064.1835,     179.0000;
        -1068.5000,	-1850.6963,     179.0000;
        -1511.0872,	-1511.0872,     179.0000;
        -1850.6963,	-1068.5000,     179.0000;
        -2064.1835,	 -553.0963,     179.0000;
        -2137.0000,	    0.0000,     179.0000;
        -2064.1835,	  553.0963,     179.0000;
        -1850.6963,	 1068.5000,     179.0000;
        -1511.0872,	 1511.0872,     179.0000;
        -1068.5000,	 1850.6963,     179.0000;
         -553.0963,	 2064.1835,     179.0000;
            0.0000,	 2290.0000,       0.0000;
          592.6956,	 2211.9701,       0.0000;
         1145.0000,	 1983.1982,       0.0000;
         1619.2745,	 1619.2745,       0.0000;
         1983.1982,	 1145.0000,       0.0000;
         2211.9701,	  592.6956,       0.0000;
         2290.0000,	    0.0000,       0.0000;
         2211.9701,	 -592.6956,       0.0000;
         1983.1982,	-1145.0000,       0.0000;
         1619.2745,	-1619.2745,       0.0000;
         1145.0000,	-1983.1982,       0.0000;
          592.6956,	-2211.9701,       0.0000;
            0.0000,	-2290.0000,       0.0000;
         -592.6956,	-2211.9701,       0.0000;
        -1145.0000,	-1983.1982,       0.0000;
        -1619.2745,	-1619.2745,       0.0000;
        -1983.1982,	-1145.0000,       0.0000;
        -2211.9701,	 -592.6956,       0.0000;
        -2290.0000,	    0.0000,       0.0000;
        -2211.9701,	  592.6956,       0.0000;
        -1983.1982,	 1145.0000,       0.0000;
        -1619.2745,	 1619.2745,       0.0000;
        -1145.0000,	 1983.1982,       0.0000;
         -592.6956,	 2211.9701,       0.0000;];         

                  
% Barras - Matriz de Conectividade [no inicial, nó final~]
CONEC = [   01, 02;
            01, 03;
            01, 04;
            01, 05;
            01, 06;
            01, 07;
            01, 08;
            01, 09;
            01, 10;
            01, 11;
            01, 12;
            01, 13;
            01, 14;
            01, 15;
            01, 16;
            01, 17;
            01, 18;
            01, 19;
            01, 20;
            01, 21;
            01, 22;
            01, 23;
            01, 24;
            01, 25;
            02, 03;
            03, 04;
            04, 05;
            05, 06;
            06, 07;
            07, 08;
            08, 09;
            09, 10;
            10, 11;
            11, 12;
            12, 13;
            13, 14;
            14, 15;
            15, 16;
            16, 17;
            17, 18;
            18, 19;
            19, 20;
            20, 21;
            21, 22;
            22, 23;
            23, 24;
            24, 25;
            25, 02; 
            02, 26;
            03, 27;
            04, 28;
            05, 29;
            06, 30;
            07, 31;
            08, 32;
            09, 33;
            10, 34;
            11, 35;
            12, 36;
            13, 37;
            14, 38;
            15, 39;
            16, 40;
            17, 41;
            18, 42;
            19, 43;
            20, 44;
            21, 45;
            22, 46;
            23, 47;
            24, 48;
            25, 49;
            02, 27;
            03, 28;
            04, 29;
            05, 30;
            06, 31;
            07, 32;
            08, 33;
            09, 34;
            10, 35;
            11, 36;
            12, 37;
            13, 38;
            14, 39;
            15, 40;
            16, 41;
            17, 42;
            18, 43;
            19, 44;
            20, 45;
            21, 46;
            22, 47;
            23, 48;
            24, 49;
            25, 26;
            26, 27;
            27, 28;
            28, 29;
            29, 30;
            30, 31;
            31, 32;
            32, 33;
            33, 34;
            34, 35;
            35, 36;
            36, 37;
            37, 38;
            38, 39;
            39, 40;
            40, 41;
            41, 42;
            42, 43;
            43, 44;
            44, 45;
            45, 46;
            46, 47;
            47, 48;
            48, 49;
            49, 26; 
            26, 50;
            27, 51;
            28, 52;
            29, 53;
            30, 54;
            31, 55;
            32, 56;
            33, 57;
            34, 58;
            35, 59;
            36, 60;
            37, 61;
            38, 62;
            39, 63;
            40, 64;
            41, 65;
            42, 66;
            43, 67;
            44, 68;
            45, 69;
            46, 70;
            47, 71;
            48, 72;
            49, 73;
            26, 51;
            27, 52;
            28, 53;
            29, 54;
            30, 55;
            31, 56;
            32, 57;
            33, 58;
            34, 59;
            35, 60;
            36, 61;
            37, 62;
            38, 63;
            39, 64;
            40, 65;
            41, 66;
            42, 67;
            43, 68;
            44, 69;
            45, 70;
            46, 71;
            47, 72;
            48, 73;
            49, 50;
            50, 51;
            51, 52;
            52, 53;
            53, 54;
            54, 55;
            55, 56;
            56, 57;
            57, 58;
            58, 59;
            59, 60;
            60, 61;
            61, 62;
            62, 63;
            63, 64;
            64, 65;
            65, 66;
            66, 67;
            67, 68;
            68, 69;
            69, 70;
            70, 71;
            71, 72;
            72, 73;
            73, 50;
            50, 74;
            51, 75;
            52, 76;
            53, 77;
            54, 78;
            55, 79;
            56, 80;
            57, 81;
            58, 82;
            59, 83;
            60, 84;
            61, 85;
            62, 86;
            63, 87;
            64, 88;
            65, 89;
            66, 90;
            67, 91;
            68, 92;
            69, 93;
            70, 94;
            71, 95;
            72, 96;
            73, 97;
            50, 75;
            51, 76;
            52, 77;
            53, 78;
            54, 79;
            55, 80;
            56, 81;
            57, 82;
            58, 83;
            59, 84;
            60, 85;
            61, 86;
            62, 87;
            63, 88;
            64, 89;
            65, 90;
            66, 91;
            67, 92;
            68, 93;
            69, 94;
            70, 95;
            71, 96;
            72, 97;
            73, 74;
            74, 75;
            75, 76;
            76, 77;
            77, 78;
            78, 79;
            79, 80;
            80, 81;
            81, 82;
            82, 83;
            83, 84;
            84, 85;
            85, 86;
            86, 87;
            87, 88;
            88, 89;
            89, 90;
            90, 91;
            91, 92;
            92, 93;
            93, 94;
            94, 95;
            95, 96;
            96, 97;
            97, 74;];
    

    
% Seção transversal
A1 = 32;          % cm²
 

% Material
E1 = 20000;          % kN/cm^2
v = 0.5;


% Módulo de elasticidade após o escoamento do material
% Somente necessário para análise não linear física
H = 5000;           % kN/cm^2
Et = (H*E1)/(H+E1);


% Tensão de escoamento do material para análise não linear física
% A partir dessa tensão o material estará em regime plástico
% Somente necessário para análise não linear física
TES1 = 2.5;          % kN/cm²


% Barras - Propriedades
% Área da seção;
% Módulo de elasticidade elástico;
% Módulo de elasticidade plástico (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Tensão de escoamento (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Deformação associada a tensão de escoamento (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% e_p, deformação zero - a última deformação tal que a tensão seja 0 (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Contador para cálculo das tensões de escoamento -> Sempre igual a 0 (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Coeficiente de Poisson (SOMENTE PARA MODELO COM MUDANÇA DE VOLUME);
[lin,~] = size(CONEC);
PROPELEM = zeros(lin,8);
PROPELEM_lin = [A1,E1,Et,TES1,TES1/E1,0,0,v];

for k = 1:lin
    for j = 1:8
        PROPELEM(k,j) = PROPELEM_lin(j);

    end
end

        
% Restrições - [NÓ, RESTX(0/1), RESTY(0/1), RESTZ(0/1)]
REST = [74, 1, 1, 1;
        75, 1, 1, 1;
        76, 1, 1, 1;
        77, 1, 1, 1;
        78, 1, 1, 1;
        79, 1, 1, 1;
        80, 1, 1, 1;
        81, 1, 1, 1;
        82, 1, 1, 1;
        83, 1, 1, 1;
        84, 1, 1, 1;
        85, 1, 1, 1;
        86, 1, 1, 1;
        87, 1, 1, 1;
        88, 1, 1, 1;
        89, 1, 1, 1;
        90, 1, 1, 1;
        91, 1, 1, 1;
        92, 1, 1, 1;
        93, 1, 1, 1;
        94, 1, 1, 1;
        95, 1, 1, 1;
        96, 1, 1, 1;
        97, 1, 1, 1;];

    
% Forças externas - [NÓ, FX(kN), FY(kN), FZ(kN)]
FC = [1, 0, 0, -1;];

end
