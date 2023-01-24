function[Kc,Kg] = rigidez_green_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal)

    % Matriz de rigidez constitutiva do elemento
    Kc = (Ee*Ae*Lf^2/(Le^3))*[ oxf*oxf,  oxf*oyf,  oxf*ozf, -oxf*oxf, -oxf*oyf, -oxf*ozf;
                               oyf*oxf,  oyf*oyf,  oyf*ozf, -oyf*oxf, -oyf*oyf, -oyf*ozf;
                               ozf*oxf,  ozf*oyf,  ozf*ozf, -ozf*oxf, -ozf*oyf, -ozf*ozf;
                              -oxf*oxf, -oxf*oyf, -oxf*ozf,  oxf*oxf,  oxf*oyf,  oxf*ozf;
                              -oyf*oxf, -oyf*oyf, -oyf*ozf,  oyf*oxf,  oyf*oyf,  oyf*ozf;
                              -ozf*oxf, -ozf*oyf, -ozf*ozf,  ozf*oxf,  ozf*oyf,  ozf*ozf];

    % Matriz de rigidez geométrica do elemento
    Kg = (normal/Le)*[  1,  0,  0, -1,  0,  0;
                        0,  1,  0,  0, -1,  0;
                        0,  0,  1,  0,  0, -1;
                       -1,  0,  0   1,  0,  0;
                        0, -1,  0,  0,  1,  0;
                        0,  0, -1,  0,  0,  1;];
                      
end
