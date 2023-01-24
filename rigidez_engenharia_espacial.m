function[Kc,Kg] = rigidez_engenharia_espacial(Ae,Ee,Le,Lf,oxf,oyf,ozf,normal)

    % Matriz de rigidez constitutiva do elemento
    Kc = (Ee*Ae/Le)*[ oxf*oxf, oxf*oyf, oxf*ozf,-oxf*oxf,-oxf*oyf,-oxf*ozf;
                      oyf*oxf, oyf*oyf, oyf*ozf,-oyf*oxf,-oyf*oyf,-oyf*ozf;
                      ozf*oxf, ozf*oyf, ozf*ozf,-ozf*oxf,-ozf*oyf,-ozf*ozf;
                     -oxf*oxf,-oxf*oyf,-oxf*ozf, oxf*oxf, oxf*oyf, oxf*ozf;
                     -oyf*oxf,-oyf*oyf,-oyf*ozf, oyf*oxf, oyf*oyf, oyf*ozf;
                     -ozf*oxf,-ozf*oyf,-ozf*ozf, ozf*oxf, ozf*oyf, ozf*ozf];

    % Matriz de rigidez geométrica do elemento
    Kg = (normal/Lf)*[1-(oxf*oxf),     -oxf*oyf,    -oxf*ozf, -1+(oxf*oxf),      oxf*oyf,     oxf*ozf;
                         -oyf*oxf,  1-(oyf*oyf),    -oyf*ozf,      oyf*oxf, -1+(oyf*oyf),     oyf*ozf;
                         -ozf*oxf,     -ozf*oyf, 1-(ozf*ozf),      ozf*oxf,      ozf*oyf,-1+(ozf*ozf);
                     -1+(oxf*oxf),      oxf*oyf,     oxf*ozf,  1-(oxf*oxf),     -oxf*oyf,    -oxf*ozf;
                          oyf*oxf, -1+(oyf*oyf),     oyf*ozf,     -oyf*oxf,  1-(oyf*oyf),    -oyf*ozf;
                          ozf*oxf,      ozf*oyf,-1+(ozf*ozf),     -ozf*oxf,     -ozf*oyf, 1-(ozf*ozf)];
                      
end