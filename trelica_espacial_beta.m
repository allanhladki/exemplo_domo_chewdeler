% Programa MEF - TRELI�A PLANA N�O LINEAR

% IMPLEMENTACAO TESTE ALGORITMO FINAL - TRELI�AS PLANAS

clc
clear all %#ok<CLALL>

%% Dados iniciais

% Definir ap�s os par�metros necess�rios o nome do arquivo com as condi��es
% de entrada para an�lise;

[tipo_linear_fisico,tipo_deformacao,tipo_metodo_convergencia,nmax,imax,TOL,LAMBDA,DELTA_L,DELTA_L_0,DELTA_L_MAX,DELTA_L_MIN,comp_arco_variavel,Nd,zeta,plotar_deformada,plotar_trajetoria,plotar_t_d,GDL_trajetoria,Elemento_trajetoria,FE,plotcont,COORDNOS,CONEC,PROPELEM,REST,FC] = greco_2006_5_4_schewdelers_dome_trelica_espacial();

%% MEF - C�lculos iniciais

NNOS = size(COORDNOS,1);                % N�mero de n�s 
NBARRAS = size(PROPELEM,1);             % N�mero de barras
NNOSREST = size(REST,1);                % N�mero de n�s restritos
GDL = 3*NNOS;                           % N�mero de graus de liberdade do problema
NELEM = size(CONEC,1);                  % N�mero de elementos
ESCOAMENTO = zeros(NELEM,1);            % Matriz do escoamento - Armazena quais barras est�o escoando ou n�o
NNOSFC = size(FC,1);                    % N�mero de n�s com for�as concentradas
P = zeros(GDL,1);                       % Vetor de for�as concentradas
K = zeros(GDL,GDL);                     % Matriz de rigidez global da estrutura
u = zeros(GDL,1);                       % Vetor dos deslocamentos globais da estrutura
normal = zeros(NELEM,1);                % For�a atuando em cada elemento -> No in�cio � zero
sigma = zeros(NELEM,1);                 % Tens�o atuanda em cada elemento -> No in�cio � zero
graph1 = zeros(nmax+1,5);               % Vari�vel utilizada para gera��o de gr�fico de resultados
SIGMAANT = zeros(NELEM);                % Tens�o anterior do elemento - utilizado para verificar as deforma��es zero
fcc_i = zeros(GDL,1);                   % Vetor das cargas internas;
sigma_historia = zeros(NELEM,nmax+1);   % Vetor que armazena a historia das tens�es de cada elemento;
e_historia = zeros(NELEM,nmax+1);       % Vetor que armazena a historia das deforma��es de cada elemento;

% Alocar as FC no vetor P
for k = 1 : NNOSFC
    P(3*FC(k,1)-2) = FC(k,2);
    P(3*FC(k,1)-1) = FC(k,3);
    P(3*FC(k,1)) = FC(k,4);
end

if tipo_metodo_convergencia == 1 || tipo_metodo_convergencia == 2
    Delta_u = zeros(GDL,1);     % Vetor do incremento dos deslocamentos globais da estrutura

elseif tipo_metodo_convergencia == 3
    DELTA_U = zeros(GDL,1);             % Vetor do incremento dos deslocamentos globais da estrutura (SOMENTE PARA O M�TODO DO COMP. DE ARCO);
    DELTA_U_1 = zeros(GDL,1);           % Vetor do incremento dos deslocamentos globais relacionado ao valor do fator de carga (COMP. ARCO HIPERPLANO FIXO)
    k_o = 0;                            % Aloca��o de vari�vel para o c�lculo do CST;
    DELTA_U_ANTERIOR = zeros(GDL,1);    % Vetor do acr�scimo de deslocamentos do incremento anterior (SOMENTE PARA O M�TODO DO COMP. DE ARCO);
    fcc_i_anterior = zeros(GDL,1);      % Vetor da for�as internas do incremento anterior (SOMENTE PARA O M�TODO DO COMP. DE ARCO);
    LAMBDA_ANTERIOR = 0.0;              % Aloca��o do LAMBDA anterior (SOMENTE PARA O M�TODO DO COMP. DE ARCO);
end

% Plotar treli�a indeformada
hold on
if plotar_deformada == 1
    for k = 1 : NELEM
        noi = CONEC(k,1);
        nof = CONEC(k,2);
        xi = COORDNOS(noi,1)+FE*u(3*noi-2);
        yi = COORDNOS(noi,2)+FE*u(3*noi-1);
        zi = COORDNOS(noi,3)+FE*u(3*noi);
        xf = COORDNOS(nof,1)+FE*u(3*nof-2);
        yf = COORDNOS(nof,2)+FE*u(3*nof-1);
        zf = COORDNOS(nof,3)+FE*u(3*nof);
        figure(3);
        line([xi,xf],[yi,yf],[zi,zf],'Color','k','LineStyle','--','Marker','o','MarkerSize',6);
        title (sprintf('Configura��o deformada da estrutura - Fator de escala = %i',FE))
        xlabel ('X - m')
        ylabel ('Y - m')
        zlabel ('Z - m')
    end
end

%% Processo Incremental-Iterativo

for n = 1:nmax

    if tipo_metodo_convergencia == 1
        Pp = (n/nmax)*P;
        for i = 1:imax
            [Kcc,fcc] = matriz_de_rigidez_espacial(GDL,NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_linear_fisico,tipo_deformacao,normal,Pp,NNOSREST,REST);
            [u,ACO_F,ACO_u,Delta_u] = newton_raphson_espacial(fcc,Kcc,u,GDL,NELEM,CONEC,COORDNOS,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,sigma,normal,Pp,NNOSREST,REST);
            [PROPELEM,sigma,normal,SIGMAANT,sigma_historia,e_historia] = esforcos_internos_espacial(NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,n,sigma,normal,sigma_historia,e_historia);
            if ACO_F <= TOL && ACO_u <= TOL
                break;
            end
        end
        
        graph1(n+1,2) = (n/nmax);
        graph1(n+1,3) = u(GDL_trajetoria);
        
    elseif tipo_metodo_convergencia == 2
        Pp = (n/nmax)*P;
        [Kcc,fcc] = matriz_de_rigidez_espacial(GDL,NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_linear_fisico,tipo_deformacao,normal,Pp,NNOSREST,REST);
        for i = 1:imax
            [u,ACO_F,ACO_u,Delta_u] = newton_raphson_espacial(fcc,Kcc,u,GDL,NELEM,CONEC,COORDNOS,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,sigma,normal,Pp,NNOSREST,REST);
            
            if ACO_F <= TOL && ACO_u <= TOL
                break;
            end
        [PROPELEM,sigma,normal,SIGMAANT,sigma_historia,e_historia] = esforcos_internos_espacial(NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,n,sigma,normal,sigma_historia,e_historia);
        end
        
        graph1(n+1,2) = (n/nmax);
        graph1(n+1,3) = u(GDL_trajetoria);
        
    elseif tipo_metodo_convergencia == 3
        Pp = P;
        [Kcc,fcc] = matriz_de_rigidez_espacial(GDL,NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_linear_fisico,tipo_deformacao,normal,Pp,NNOSREST,REST);
        [LAMBDA,u,DELTA_U,DELTA_L,k_o,CST,graph1,DELTA_U_ANTERIOR,fcc_i_anterior,LAMBDA_ANTERIOR] = comprimento_de_arco_NRM_espacial(n,imax,TOL,Kcc,fcc,k_o,DELTA_L,DELTA_L_0,DELTA_L_MAX,DELTA_L_MIN,DELTA_U,LAMBDA,u,comp_arco_variavel,Nd,zeta,GDL,NELEM,CONEC,COORDNOS,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,sigma,normal,NNOSREST,REST,graph1,DELTA_U_ANTERIOR,fcc_i_anterior,LAMBDA_ANTERIOR);
        [PROPELEM,sigma,normal,SIGMAANT,sigma_historia,e_historia] = esforcos_internos_espacial(NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,n,sigma,normal,sigma_historia,e_historia);
            
        graph1(n,1) = n-1;
        graph1(n,2) = LAMBDA;
        graph1(n,3) = u(GDL_trajetoria);
        graph1(n,5) = CST;
    end 
    
    % PLOTAGEM DA TRELI�A DEFORMADA
    if plotar_deformada == 1 
    if n == nmax || mod(n,plotcont) == 0
        for k = 1 : NELEM
            noi = CONEC(k,1);
            nof = CONEC(k,2);
            xi = COORDNOS(noi,1)+FE*u(3*noi-2);
            yi = COORDNOS(noi,2)+FE*u(3*noi-1);
            zi = COORDNOS(noi,3)+FE*u(3*noi);
            xf = COORDNOS(nof,1)+FE*u(3*nof-2);
            yf = COORDNOS(nof,2)+FE*u(3*nof-1);
            zf = COORDNOS(nof,3)+FE*u(3*nof);
            figure(3);
            if n < nmax
                line([xi,xf],[yi,yf],[zi,zf],'Color','b','LineStyle','-','Marker','o','MarkerSize',4);
            elseif n == nmax
                line([xi,xf],[yi,yf],[zi,zf],'Color','r','LineStyle','-','Marker','o','MarkerSize',6);
            end
        end
    end
    end
    if mod(n,1000) == 0
        fprintf('\n Incremento n = %i,',n);
    end
end % Fim do processo incremental-iterativo

graph1(nmax+1,:) = [];

%% Sa�das 

deslocamentos = [ [1:NNOS]' , vec2mat(u,3) ];
normal = [ [1:NELEM]' , normal ];
sigma = [ [1:NELEM]' , sigma ];

if plotar_trajetoria == 1
    figure(1);
    plot(-graph1(:,3),graph1(:,2));
    grid;
    xlabel ('Deslocamento [cm]');
    ylabel ('P [kN]');
 
end

if plotar_t_d == 1
    figure(2); % Gr�fico tens�o x deforma��o
    plot(e_historia(Elemento_trajetoria,:),10*sigma_historia(Elemento_trajetoria,:));
    grid;
    title (sprintf('Curva tens�o x deforma��o para o elemento %i',Elemento_trajetoria));
    xlabel ('Deforma��o');
    ylabel ('Tens�o - MPa');
end