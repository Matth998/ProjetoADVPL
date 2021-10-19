#include 'protheus.ch'

User Function CopiMusAut(oModel)

    local oGridModel
    local aArea:=getarea() 

    oModel:=FWModelActive()
    oGridModel:= oModel:GetModel('ZA5DETAIL')
 
    DbSelectArea("ZA5")
    DbSetOrder(1) 

    /*A Fun��o PadR serve para preenche todos os campos que ficaram em branco. Por exemplo, coloquei apenas 1 zero
    no campo, entretanto ele tem o tamanho de 6 caracter, essa fun��o preenchera todos os espa�os em branco com espa�o para a direita.
    A Fun��o TamSx3, serve para mostrar quando caracter tem tal campo na Tabela Sx3.
    */
    If DbSeek(xFilial('ZA5') + ZA5->ZA5_MUSICA)    

        While ZA5->(!Eof()) .and. ZA5->ZA5_FILIAL + ZA5->ZA5_ALBUM + ZA5->ZA5_MUSICA == xFilial('ZA5') + ZA5->ZA5_MUSICA

            If !(oGridModel:SeekLine({{"ZA5_INTER",ZA5->ZA5_INTER}},.F.,.F.))
                oGridModel:Addline() //Cria uma linha em branco no grid  

                oGridModel:SetValue("ZA5_INTER",ZA5->ZA5_INTER) //Preenche a linha criada no grid
            Else
                Help(NIL, NIL, "Autor j� adicionado!", NIL, "Autor j� adicionado na lista!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Autor j� adicionado, por favor, tente novamente!"})
            EndIf
                ZA5-> (DbSkip()) 

            EndDo  

        Else
            Help(NIL, NIL, "C�digo invalido!", NIL, "C�digo inexistente", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Revise o c�digo inserido e tente novamente!"})
 
        EndIf 
    
    RestArea(aArea)

Return   