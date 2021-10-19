#include 'protheus.ch'

Static function BotaoAlb(oPanel,oOtherObject)
  �  �  �  �TButton():New(  �01,  �210,  �"Selecionar Todos",oPanel,{||SelGrid(oOtherObject)},  �60,10,,,.F.,.T.,.F.,,.F.,,,.F.  �)  �
  �  �  �  �TButton():New(  �01,  �280,  �"Copiar Musicas",oPanel,{||CopiaMus(oOtherObject)},  �80,10,,,.F.,.T.,.F.,,.F.,,,.F.  �)
Return  oPanel

User Function CopiAlb(cPergunta,oModel, oGridModel)

Local aArea := GetArea()
Local cPergunta
local oModel

    If cPergunta == NIL
 
        cPergunta := FwInputBox("Codigo do album")

    Endif

    If oGridModel == NIL

        oModel := FwModelActive()
        oGridModel:= oModel:GetModel("ZA4DETAIL")

    EndIf

    DbSelectArea('ZA4')
    DbSetOrder(1)

     If DbSeek(xFilial('ZA4') + PadR(cPergunta,TamSx3('ZA4_MUSICA')[1]))

        While ZA2->(!Eof()) .and. ZA4->ZA4_FILIAL + ZA4->ZA4_ALBUM == xFilial('ZA2')+cPergunta
        
           If !(oGridModel:SeekLine({{"ZA8_CODIGO",ZA4->ZA4_MUSICA}},.F.,.F.))
                
                If !oGridModel:IsEmpty()  
                    
                    oGridModel:AddLine()
                EndIf

                oGridModel:SetValue('ZA8_CODIGO',ZA4->ZA4_MUSICA) 
                oGridModel:SetValue("ZA8_NOME",POSICIONE("ZA1",1,xFilial("ZA1")+ZA4->ZA4_MUSICA, "ZA1_TITULO" )) 
            
            Else

               Help(NIL, NIL, "Musica ja adicionada", NIL, "Est� musica ja foi adicionada!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor, revise o c�digo, e tente novamente!"})
            EndIf
            
            DbSkip()

        EndDo
    Else

        Help(NIL, NIL, "C�digo invalido", NIL, "C�digo invalido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"C�digo invalido, por favor, revise!"})

    EndIf

    RestArea(aArea)

Return