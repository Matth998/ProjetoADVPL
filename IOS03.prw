#include 'protheus.ch'

User function  BotaoAlb()
Local cCodigo := Val(FwInputBox("Digite o codigo do album desejada!"))
Local aAutor := GetArea()
Local aZA2 := ZA8->(GetArea())
Local oModel := fwModelActive()
Local oGridModel := oModel:GetModel("ZA8DETAIL")
DbSelectArea("ZA8")
DbSetorder(1)
DbGotop()


If DbSeek(xFilial("ZA4") + cCodigo)

    While  ZA8->(!Eof()) .And.ZA4->ZA8_FILIAL + ZA4->ZA4_MUSICA ==xFilial("ZA4") + cCodigo
        If !oGridModel:SeekLine({{"ZA4_MUSICA", ZA4->ZA4_MUSICA}}, .F., .F.)
        oGridModel:AddLine()
        oGridModel:SetValue("ZA4_MUSICA", ZA4->ZA4_MUSICA)
            
        Else
        Alert("Ýlbum ja cadastrado!")  
        Endif
        ZA2->(DbSkip())
  
    EndDo
Else
 Help( ,, 'Help',, 'Codigo Invalido', 1, 0)
Endif    
RestArea(aZA2)
RestArea(aAutor)
Return