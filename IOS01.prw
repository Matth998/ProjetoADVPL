#include "protheus.ch"

User Function IOS01Mus()

Local oBrowse := FWMBrowse():New()
    
    oBrowse:SetAlias("ZA8")
    oBrowse:SetDescription("Musicas da playlist")
    oBrowse:SetMenuDef("IOS01")
    oBrowse:Activate() 

Return

Static Function MenuDef()

Return FWMVCMenu("IOS01")

Static Function ModelDef()  

Local oModel := MPFormModel():new("IOS01")
Local oStruZA8 := FWFormStruct(1, "ZA8")

    oModel:AddFields("MASTER",,oStruZA8)
    oModel:SetPrimaryKey({"ZA8_CODIGO"})

Return oModel

Static Function ViewDef()

Local oView := FWFormView():New()
Local oStruZA8 := FWFormStruct(2, "ZA8")

    oView:SetModel(ModelDef())
    oView:AddField("FIELD_ZA8", oStruZA8, "MASTER")
    oView:CreateHorizontalBox("BASE", 100)
    oView:SetOwnerView("FIELD_ZA8", "BASE")

Return oView
