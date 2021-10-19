#include 'protheus.ch'

User Function CopiMusAut(oModel)

    local oGridModel
    local aArea:=getarea() 

    oModel:=FWModelActive()
    oGridModel:= oModel:GetModel('ZA5DETAIL')
 
    DbSelectArea("ZA5")
    DbSetOrder(1) 

    /*A Função PadR serve para preenche todos os campos que ficaram em branco. Por exemplo, coloquei apenas 1 zero
    no campo, entretanto ele tem o tamanho de 6 caracter, essa função preenchera todos os espaços em branco com espaço para a direita.
    A Função TamSx3, serve para mostrar quando caracter tem tal campo na Tabela Sx3.
    */
    If DbSeek(xFilial('ZA5') + ZA5->ZA5_MUSICA)    

        While ZA5->(!Eof()) .and. ZA5->ZA5_FILIAL + ZA5->ZA5_ALBUM + ZA5->ZA5_MUSICA == xFilial('ZA5') + ZA5->ZA5_MUSICA

            If !(oGridModel:SeekLine({{"ZA5_INTER",ZA5->ZA5_INTER}},.F.,.F.))
                oGridModel:Addline() //Cria uma linha em branco no grid  

                oGridModel:SetValue("ZA5_INTER",ZA5->ZA5_INTER) //Preenche a linha criada no grid
            Else
                Help(NIL, NIL, "Autor já adicionado!", NIL, "Autor já adicionado na lista!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Autor já adicionado, por favor, tente novamente!"})
            EndIf
                ZA5-> (DbSkip()) 

            EndDo  

        Else
            Help(NIL, NIL, "Código invalido!", NIL, "Código inexistente", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Revise o código inserido e tente novamente!"})
 
        EndIf 
    
    RestArea(aArea)

Return   