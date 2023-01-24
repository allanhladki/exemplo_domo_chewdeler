function[tipo_linear_fisico,tipo_deformacao,tipo_metodo_convergencia,nmax,imax,TOL,LAMBDA,DELTA_L,DELTA_L_0,DELTA_L_MAX,DELTA_L_MIN,comp_arco_variavel,Nd,zeta,plotar_deformada,plotar_trajetoria,plotar_t_d,GDL_trajetoria,Elemento_trajetoria,FE,plotcont,COORDNOS,CONEC,PROPELEM,REST,FC] = lacerda_5_3_trelica_espacial()

% DEFINIR O TIPO DE AN�LISE F�SICA:
% 1 - An�lise linear sem limite de escoamento - Lei de Hooke;
% 2 - An�lise n�o linear f�sica - Modelo bilinear;
tipo_linear_fisico = 2;




% DEFINIR O TIPO DE DEFORMA��O UTILIZADA:
% 1 - Deforma��o de Engenharia;
% 2 - Deforma��o de Green;
% 3 - Deforma��o Logaritmica sem mudan�a de volume;
% 4 - Deforma��o Logaritmica com mudan�a de volume - OBS: Somente utilizar dentro do limite de escoamento;
tipo_deformacao = 1;




% DEFINIR O TIPO DE M�TODO DE CONVERG�NCIA
% 1 - M�todo de Newton-Raphson;
% 2 - M�todo de Newton-Raphson Modificado;
% 3 - M�todo do Comprimento de Arco de Riks-Wempner - NRM;
tipo_metodo_convergencia = 3;


% nmax = 550 for elastic
% nmax = 700 for H = 0
% nmax = 700 for H = 250

% Dados de entrada para o m�todo incremetal-iterativo
nmax = 700;                  % N�mero m�ximo de incrementos; 
imax = 10;                  % N�mero m�ximo de itera��es;
TOL = 1e-4;                % Toler�ncia da converg�ncia;
LAMBDA = 0;                 % Fator de carga (SOMENTO PARA O M�TODO DO COMP. DE ARCO);
DELTA_L = 0.001;             % Comprimento de arco inicial (SOMENTE PARA O M�TODO DO COMP. DE ARCO);     
DELTA_L_0 = DELTA_L;        % Comprimento de arco fixo para ajuste do comprimento de cada incremento (SOMENTE PARA O M�TODO DO COMP. DE ARCO);
DELTA_L_MAX = 0.01;            % Maior valor poss�vel para o comprimento de arco;
DELTA_L_MIN = 0.001;         % Menor valor poss�vel para o comprimento de arco; 
comp_arco_variavel = 1;     % Ajuste do comprimento de arco (1 - DELTA_L VARI�VEL ����� 0 -> DELTA_L FIXO);
Nd = 3;                     % N�mero desejado de itera��es para cada ciclo (SOMENTE PARA M�TODO DE COMPRIMENTO DE ARCO);
zeta = 0.5;                 % Fator da raz�o Nd/(Ni-1) (SOMENTE PARA M�TODO DE COMPRIMENTO DE ARCO);




% Dados de entrada para saida visual
plotar_deformada = 2;       % Plotagem da treli�a na configura��o deformada (1 -> PLOTAR ����� 0 -> N�O PLOTAR);
plotar_trajetoria = 1;      % Plotagem da trajet�ria de equilibrio para o GDL_trajetoria (1 -> PLOTAR ����� 0 -> N�O PLOTAR);
plotar_t_d = 0;             % Plotagem do grafico de tens�o x deforma��o para o Elemento_trajetoria (1 -> PLOTAR ����� 0 -> N�O PLOTAR);
GDL_trajetoria = 39;       % Grau de liberdade acompanhado na trajet�ria de equilibrio gr�fica;
Elemento_trajetoria = 1;    % Elemento acompanhado na trajetoria de tens�o x deforma��o;
FE = 50;                    % Fator de escala para plotagem da configura��o deformada;
plotcont = 2;               % N�mero de incrementos entre cada plotagem da configura��o deformada;


% GEOMETRIA

% Coordenadas dos n�s - [coordX (cm), coordY (cm), coordZ (cm)]

COORDNOS = [     0.0,	  50.0,     0.0;
            -43.3013,	  25.0,     0.0;
            -43.3013,	 -25.0,     0.0;
                 0.0,	 -50.0,     0.0;
             43.3013,	 -25.0,     0.0;
             43.3013,	  25.0,     0.0;
               -12.5,  21.6506,   6.216;
               -25.0,      0.0,   6.216;
               -12.5, -21.6506,	  6.216;
                12.5, -21.6506,	  6.216;
                25.0,	   0.0,	  6.216;
                12.5,  21.6506,	  6.216;
                 0.0,	   0.0,	  8.216;];

                  
% Barras - Matriz de Conectividade [no inicial, n� final~]
CONEC = [1,	12;
         1,	7;
         2,	7;
         2,	8;
         3,	8;
         3,	9;
         4,	9;
         4,	10;
         5,	10;
         5,	11;
         6,	11;
         6,	12;
         7,	12;
         7,	8;
         8,	9;
         9,	10;
         10,11;
         11,12;
         12,13;
         7,	13;
         8,	13;
         9,	13;
         10,13;
         11,13;];


% Se��o transversal
A1 = 3.17;          % cm�
 

% Material
E1 = 300;          % kN/cm^2
v = 0.5;


% M�dulo de elasticidade ap�s o escoamento do material
% Somente necess�rio para an�lise n�o linear f�sica
H = 0;           % kN/cm^2
Et = (H*E1)/(H+E1);


% Tens�o de escoamento do material para an�lise n�o linear f�sica
% A partir dessa tens�o o material estar� em regime pl�stico
% Somente necess�rio para an�lise n�o linear f�sica
TES1 = 0.2;          % kN/cm�


% Barras - Propriedades
% �rea da se��o;
% M�dulo de elasticidade el�stico;
% M�dulo de elasticidade pl�stico (SOMENTE PARA AN�LISE N�O LINEAR F�SICA);
% Tens�o de escoamento (SOMENTE PARA AN�LISE N�O LINEAR F�SICA);
% Deforma��o associada a tens�o de escoamento (SOMENTE PARA AN�LISE N�O LINEAR F�SICA);
% e_p, deforma��o zero - a �ltima deforma��o tal que a tens�o seja 0 (SOMENTE PARA AN�LISE N�O LINEAR F�SICA);
% Contador para c�lculo das tens�es de escoamento -> Sempre igual a 0 (SOMENTE PARA AN�LISE N�O LINEAR F�SICA);
% Coeficiente de Poisson (SOMENTE PARA MODELO COM MUDAN�A DE VOLUME);
PROPELEM = [A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;
            A1,E1,Et,TES1,TES1/E1,0,0,v;];


        
% Restri��es - [N�, RESTX(0/1), RESTY(0/1)]
REST = [1,1,1,1;
        2,1,1,1;
        3,1,1,1;
        4,1,1,1;
        5,1,1,1;
        6,1,1,1;];  

    
% For�as externas - [N�, FX(kN), FY(kN), FZ(kN)]
FC = [13,0,0,-1;];

end
