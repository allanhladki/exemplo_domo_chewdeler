function[PROPELEM,sigma,normal,SIGMAANT,sigma_historia,e_historia] = esforcos_internos_espacial(NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,n,sigma,normal,sigma_historia,e_historia)

for k = 1 : NELEM
     % Geometria da barra: comprimento, cossenos diretores
     noi = CONEC(k,1);         %Nó inicial do elemento
     nof = CONEC(k,2);         %Nó final do elemento

     %Dados iniciais
     dxi = COORDNOS(nof,1) - COORDNOS(noi,1);           % Deltax do elemento (seu comprimento na direção x);
     dyi = COORDNOS(nof,2) - COORDNOS(noi,2);           % Deltay do elemento (seu comprimento na direção y);
     dzi = COORDNOS(nof,3) - COORDNOS(noi,3);           % Deltaz do elemento (seu comprimento na direção z);    
     Le = sqrt(dxi^2 + dyi^2 + dzi^2);                  % Comprimento inicial do elemento  

     %Dados após deformação uant
     dxf = COORDNOS(nof,1) - COORDNOS(noi,1) + u(3*nof-2) - u(3*noi-2);     % Deltax do elemento (seu comprimento na direção x);
     dyf = COORDNOS(nof,2) - COORDNOS(noi,2) + u(3*nof-1) - u(3*noi-1);     % Deltay do elemento (seu comprimento na direção y);
     dzf = COORDNOS(nof,3) - COORDNOS(noi,3) + u(3*nof) - u(3*noi);         % Deltaz do elemento (seu comprimento na direção z);    
     Lf = sqrt(dxf^2 + dyf^2 + dzf^2);                                      % Comprimento final do elemento              

    % Propriedades do elemento
    Ae = PROPELEM(k,1);                         % Área do elemento
    Ee = PROPELEM(k,2);                         % Módulo de elasticidade do elemento
        
    if tipo_deformacao == 1
        eatual = (Lf-Le)/Le;                    % Deformação atual do elemento - Engenharia;
        
    elseif tipo_deformacao == 2
        eatual = (Lf^2-Le^2)/(2*Le^2);          % Deformação atual do elemento - Green;
        
    elseif tipo_deformacao == 3
        eatual = log(Lf/Le);                    % Deformação atual do elemento - Log sem mudança de volume;
        
    elseif tipo_deformacao == 4
        eatual = log(Lf/Le);                    % Deformação atual do elemento - Log com mudança de volume;
    
    end
    
        
    if tipo_linear_fisico == 2
        Eesc = PROPELEM(k,3);                   % Módulo de elasticidade após o escoamento
        Tesc = PROPELEM(k,4);                   % Tensão atual de escoamento do elemento
        e_esc = PROPELEM(k,5);                  % Deformação de escoamento do elemento
        e_p = PROPELEM(k,6);                    % Última deformação tal que a tensão é nula no elemento
        contador = PROPELEM(k,7);               % Contador para cálculo das tensões do elemento
        sigmaant = SIGMAANT(k);                 % Tensão anterior;

        [sigma(k),Tesc,e_esc,e_p,sigmaant,contador] = tensao_nlf(Tesc,e_esc,e_p,sigmaant,contador,Ee,Eesc,eatual,n);

        PROPELEM(k,4) = Tesc;
        PROPELEM(k,5) = e_esc;
        PROPELEM(k,6) = e_p;
        PROPELEM(k,7) = contador;
        SIGMAANT(k) = sigmaant;
            
    elseif tipo_linear_fisico == 1
        [sigma(k)] = tensao_hooke(eatual,Ee);
    end
        
    normal(k) = sigma(k)*Ae;
        
    sigma_historia(k,n+1) = sigma(k);
    e_historia(k,n+1) = eatual;
        
end
