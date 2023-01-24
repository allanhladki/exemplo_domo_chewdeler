function[Kcc,fcc] = matriz_de_rigidez_espacial(GDL,NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_linear_fisico,tipo_deformacao,normal,Pp,NNOSREST,REST)

    K = zeros(GDL,GDL);
    
    for k = 1: +1 : NELEM  

        % Geometria da barra: comprimento, cossenos diretores
        noi = CONEC(k,1);         % Nó inicial do elemento
        nof = CONEC(k,2);         % Nó final do elemento

        % Dados iniciais
        dxi = COORDNOS(nof,1) - COORDNOS(noi,1);       % Deltax do elemento (seu comprimento na direção x);
        dyi = COORDNOS(nof,2) - COORDNOS(noi,2);       % Deltay do elemento (seu comprimento na direção y); 
        dzi = COORDNOS(nof,3) - COORDNOS(noi,3);       % Deltay do elemento (seu comprimento na direção z);
        Le = sqrt(dxi^2 + dyi^2 + dzi^2);              % Comprimento inicial do elemento 

        % Dados após deformação uant
        dxf = COORDNOS(nof,1) - COORDNOS(noi,1) + u(3*nof-2) - u(3*noi-2);       % Deltax do elemento (seu comprimento na direção x);
        dyf = COORDNOS(nof,2) - COORDNOS(noi,2) + u(3*nof-1) - u(3*noi-1);       % Deltay do elemento (seu comprimento na direção y);
        dzf = COORDNOS(nof,3) - COORDNOS(noi,3) + u(3*nof) - u(3*noi);           % Deltaz do elemento (seu comprimento na direção z);    
        Lf = sqrt(dxf^2 + dyf^2 + dzf^2);                                        % Comprimento final do elemento              

        % Pelos cossenos diretores 
        oxf = dxf/Lf;                % Cosseno do ângulo theta x do vetor;
        oyf = dyf/Lf;                % Cosseno do ângulo theta y do vetor;
        ozf = dzf/Lf;                % Cosseno do ângulo theta z do vetor;

        % Propriedades do elemento
        Ae = PROPELEM(k,1);
        Ee = PROPELEM(k,2);
        poisson = PROPELEM(k,8);

        if tipo_linear_fisico == 2 && abs(PROPELEM(k,7)) == 1
            Ee = PROPELEM(k,3);
        end
            
        if tipo_deformacao == 1
            [Kc,Kg] = rigidez_engenharia_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal(k));
        
        elseif tipo_deformacao == 2
            [Kc,Kg] = rigidez_green_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal(k));
        
        elseif tipo_deformacao == 3
            [Kc,Kg] = rigidez_log_1_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal(k));
            
        elseif tipo_deformacao == 4
            [Kc,Kg] = rigidez_log_2_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal(k),poisson);
        
        end    
          
        % Matriz de rigidez elementar 
        Ke = Kc + Kg;         

        % Assemblagem de Ke
        MATRIZ_ASSEMBLAGEM=[3*noi-2,3*noi-1,3*noi,3*nof-2,3*nof-1,3*nof];
      
        for h = 1 : 6
            for j = 1 : 6
                lin = MATRIZ_ASSEMBLAGEM(h);
                col = MATRIZ_ASSEMBLAGEM(j);
                K(lin,col) = K(lin,col) + Ke(h,j);
            end
        end
        
    end     % Fim da criação da matriz de rigidez global da estrutura
        

    % SISTEMA RESTRINGIDO - CONDIÇÕES DE CONTORNO
    Kcc = K;
    fcc = Pp;
    
    for k = 1 : NNOSREST
        no = REST(k,1);
        % Deslocamentos prescritos no vetor fcc e zerar as linhas da matriz Kcc
        for m = 2:4
            if REST(k,m) == 1
                GDLR = 3*no-(4-m);
                % Atribui o desloca. pres. na linha GDLR de fcc
                fcc(GDLR) = 0;
                % Zera a linha e a coluna GDLR de Kcc
                for h = 1 : GDL
                    Kcc(h,GDLR) = 0;
                    Kcc(GDLR,h) = 0;
                end
                % Atribui "1" ao elemento Kcc(m,m)
                Kcc(GDLR,GDLR) = 1;
            end
        end    
    end
end
