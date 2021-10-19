#include "protheus.ch"
#include 'FWMVCDEF.CH'

Static Function MenuDef()

Return FWMVCMenu("IOS04")

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
    Cria o menu da nossa rotina da playlist 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oModel Recebe o MPFormModel, que fornece o objeto com o modelo
    hierárquico dos campos de edição.
    @param oStruZA9 Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA9.
    Return oModel 
/*/
//-------------------------------------------------------------------

Static Function ModelDef()    
Local oModel := MPFormModel():new("IOS04")
Local oStruZA9 := FWFormStruct(1, "ZA9")

    oModel:AddFields("MASTER",,oStruZA9) 
    oModel:SetPrimaryKey({"ZA9_CODIGO"}) 

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
    Cria o View da nossa rotina da playlist 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oView Recebe o FWFormView, fornece uma visualização grafica da
    nossa rotina.
    @param oStruZA9 Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA9.
    Return oView
/*/
//-------------------------------------------------------------------

Static Function ViewDef() 
Local oView := FWFormView():New()
Local oStruZA9 := FWFormStruct(2, "ZA9")

    oView:SetModel(ModelDef())
    oView:AddField("ZA9_CODIGO", oStruZA9, "MASTER")

Return oView 