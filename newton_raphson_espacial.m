function[u,ACO_F,ACO_u,Delta_u] = newton_raphson(fcc,Kcc,u,GDL,NELEM,CONEC,COORDNOS,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,sigma,normal,Pp,NNOSREST,REST)

        [fcc_i] = forcas_internas_espacial(GDL,NELEM,CONEC,COORDNOS,u,PROPELEM,tipo_deformacao,tipo_linear_fisico,SIGMAANT,sigma,normal,Pp,NNOSREST,REST);
        Erro = fcc - fcc_i;
        Delta_u = Kcc\Erro;
        u = u + Delta_u;
        
        ACO_F = sqrt((fcc'*fcc)\Erro'*Erro);
        ACO_u = sqrt((u'*u)\Delta_u'*Delta_u);
    
end
    