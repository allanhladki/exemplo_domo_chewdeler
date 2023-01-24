function[Kc,Kg] = rigidez_log_1_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal)

    % Matriz de rigidez constitutiva do elemento
    Kc = (Ee*Ae*Le/(Lf^2))*[oxf*oxf,  oxf*oyf,  oxf*ozf, -oxf*oxf, -oxf*oyf, -oxf*ozf;
                            oyf*oxf,  oyf*oyf,  oyf*ozf, -oyf*oxf, -oyf*oyf, -oyf*ozf;
                            ozf*oxf,  ozf*oyf,  ozf*ozf, -ozf*oxf, -ozf*oyf, -ozf*ozf;
                           -oxf*oxf, -oxf*oyf, -oxf*ozf,  oxf*oxf,  oxf*oyf,  oxf*ozf;
                           -oyf*oxf, -oyf*oyf, -oyf*ozf,  oyf*oxf,  oyf*oyf,  oyf*ozf;
                           -ozf*oxf, -ozf*oyf, -ozf*ozf,  ozf*oxf,  ozf*oyf,  ozf*ozf];

    % Matriz de rigidez geométrica do elemento
    Kg = (normal*Le/Lf^2)*[ 1-2*oxf*oxf,   -2*oyf*oxf,   -2*ozf*oxf, -1+2*oxf*oxf,    2*oyf*oxf,    2*ozf*oxf;
                             -2*oxf*oyf,  1-2*oyf*oyf,   -2*ozf*oyf,    2*oxf*oyf, -1+2*oyf*oyf,    2*ozf*oyf;
                             -2*oxf*ozf,   -2*oyf*ozf,  1-2*ozf*ozf,    2*oxf*ozf,    2*oyf*ozf, -1+2*ozf*ozf; 
                           -1+2*oxf*oxf,    2*oyf*oxf,    2*ozf*oxf,  1-2*oxf*oxf,   -2*oyf*oxf,   -2*ozf*oxf;
                              2*oxf*oyf, -1+2*oyf*oyf,    2*ozf*oyf,   -2*oxf*oyf,  1-2*oyf*oyf,   -2*ozf*oyf;
                              2*oxf*ozf,    2*oyf*ozf, -1+2*ozf*ozf,   -2*oxf*ozf,   -2*oyf*ozf,  1-2*ozf*ozf;];
                      
end