function[tipo_linear_fisico,tipo_deformacao,tipo_metodo_convergencia,nmax,imax,TOL,LAMBDA,DELTA_L,DELTA_L_0,DELTA_L_MAX,DELTA_L_MIN,comp_arco_variavel,Nd,zeta,plotar_deformada,plotar_trajetoria,plotar_t_d,GDL_trajetoria,Elemento_trajetoria,FE,plotcont,COORDNOS,CONEC,PROPELEM,REST,FC] = leite_4_6_trelica_espacial()

% DEFINIR O TIPO DE ANÁLISE FÍSICA:
% 1 - Análise linear sem limite de escoamento - Lei de Hooke;
% 2 - Análise não linear física - Modelo bilinear;
tipo_linear_fisico = 1;




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
tipo_metodo_convergencia = 2;




% Dados de entrada para o método incremetal-iterativo
nmax = 10;                  % Número máximo de incrementos; 
imax = 10;                  % Número máximo de iterações;
TOL = 1e-5;                % Tolerância da convergência;
LAMBDA = 0;                 % Fator de carga (SOMENTO PARA O MÉTODO DO COMP. DE ARCO);
DELTA_L = 0.01;             % Comprimento de arco inicial (SOMENTE PARA O MÉTODO DO COMP. DE ARCO);     
DELTA_L_0 = DELTA_L;        % Comprimento de arco fixo para ajuste do comprimento de cada incremento (SOMENTE PARA O MÉTODO DO COMP. DE ARCO);
DELTA_L_MAX = 1;            % Maior valor possível para o comprimento de arco;
DELTA_L_MIN = 0.01;         % Menor valor possível para o comprimento de arco; 
comp_arco_variavel = 0;     % Ajuste do comprimento de arco (1 - DELTA_L VARIÁVEL ¨¨¨¨¨ 0 -> DELTA_L FIXO);
Nd = 3;                     % Número desejado de iterações para cada ciclo (SOMENTE PARA MÉTODO DE COMPRIMENTO DE ARCO);
zeta = 0.5;                 % Fator da razão Nd/(Ni-1) (SOMENTE PARA MÉTODO DE COMPRIMENTO DE ARCO);




% Dados de entrada para saida visual
plotar_deformada = 1;       % Plotagem da treliça na configuração deformada (1 -> PLOTAR ¨¨¨¨¨ 0 -> NÃO PLOTAR);
plotar_trajetoria = 1;      % Plotagem da trajetória de equilibrio para o GDL_trajetoria (1 -> PLOTAR ¨¨¨¨¨ 0 -> NÃO PLOTAR);
plotar_t_d = 0;             % Plotagem do grafico de tensão x deformação para o Elemento_trajetoria (1 -> PLOTAR ¨¨¨¨¨ 0 -> NÃO PLOTAR);
GDL_trajetoria = 11;       % Grau de liberdade acompanhado na trajetória de equilibrio gráfica;
Elemento_trajetoria = 1;    % Elemento acompanhado na trajetoria de tensão x deformação;
FE = 50;                    % Fator de escala para plotagem da configuração deformada;
plotcont = 2;               % Número de incrementos entre cada plotagem da configuração deformada;


% GEOMETRIA

% Coordenadas dos nós - [coordX (cm), coordY (cm), coordZ (cm)]

COORDNOS = [     0.0,	  0.0,     0.0;
                75.0,     0.0,     0.0;
                 0.0,   100.0,     0.0;
                 0.0,     0.0,   100.0;];
            

                  
% Barras - Matriz de Conectividade [no inicial, nó final~]
CONEC = [1,	2;
         1, 3;
         1, 4;
         2, 3;
         4, 2;
         4, 3;];
         


% Seção transversal
A1 = 10;          % cm²
 

% Material
E1 = 10000;          % kN/cm^2
v = 0.5;


% Módulo de elasticidade após o escoamento do material
% Somente necessário para análise não linear física
H = 2000;           % kN/cm^2
Et = (H*E1)/(H+E1);


% Tensão de escoamento do material para análise não linear física
% A partir dessa tensão o material estará em regime plástico
% Somente necessário para análise não linear física
TES1 = 21;          % kN/cm²


% Barras - Propriedades
% Área da seção;
% Módulo de elasticidade elástico;
% Módulo de elasticidade plástico (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Tensão de escoamento (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Deformação associada a tensão de escoamento (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% e_p, deformação zero - a última deformação tal que a tensão seja 0 (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Contador para cálculo das tensões de escoamento -> Sempre igual a 0 (SOMENTE PARA ANÁLISE NÃO LINEAR FÍSICA);
% Coeficiente de Poisson (SOMENTE PARA MODELO COM MUDANÇA DE VOLUME);
PROPELEM = [A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;];


        
% Restrições - [NÓ, RESTX(0/1), RESTY(0/1)]
REST = [1,1,1,1;
        2,0,1,1;
        3,1,1,1;
        4,0,0,1;];

    
% Forças externas - [NÓ, FX(kN), FY(kN), FZ(kN)]
FC = [1, 20,  20, 10;
      2,  7, -10, -1;
      3, 20,  20, 10;
      4, 37,  30, -1;];

end
