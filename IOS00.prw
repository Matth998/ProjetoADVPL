#include "protheus.ch"
#include 'FWMVCDEF.CH'

User Function IOS01_ALB()

    Local oBrowse := FWMBrowse():New()
        
        oBrowse:SetAlias("ZA3")
        oBrowse:SetDescription("Album") 
        oBrowse:SetMenuDef("IOS00")
        oBrowse:Activate()

Return

Static Function MenuDef()

Return FWMVCMenu("IOS00")

Static Function ModelDef()    

    Local oModel := MPFormModel():new("IOS00") 
    Local oStruZA3 := FWFormStruct(1, "ZA3")
    local oStruZA4 := FWFormStruct(1, "ZA4")
    local oStruZA5 := FWFormStruct(1, "ZA5")
    //local oStruConsulta := FWFormStruct(1,"ZA4")

        oModel:AddFields("MASTER",,oStruZA3) 
        oModel:SetPrimaryKey({"ZA3_ALBUM"}) 

        oModel:AddGrid("ZA4DETAIL","MASTER",oStruZA4,,{|oModel|u_CopiMusAut(oModel)}) 
        oModel:AddGrid("ZA5DETAIL","ZA4DETAIL",oStruZA5)
 
        oModel:SetRelation( "ZA4DETAIL", { { 'ZA4_FILIAL', 'xFilial( "ZA4" ) ' } , { 'ZA4_ALBUM', 'ZA3_ALBUM' } } , ZA4->( IndexKey( 1 ) ) )
        oModel:SetRelation("ZA5DETAIL", {{"ZA5_FILIAL", "FwXFilial('ZA5')"}, {"ZA5_ALBUM", "ZA3_ALBUM"}, {"ZA5_MUSICA", "ZA4_MUSICA"}}, ZA5->(IndexKey(1)))
        
        oModel:SetPrimaryKey({"ZA4_ALBUM"})
        oModel:GetModel('ZA5DETAIL'):SetOptional(.t.)  
        oModel:GetModel( 'ZA4DETAIL' ):SetUniqueLine( { "ZA4_ALBUM" , "ZA4_MUSICA"} )  
        oModel:GetModel( 'ZA5DETAIL' ):SetUniqueLine( { "ZA5_ALBUM" , "ZA5_INTER"} )  

        //Função que adiociona um grid no meu model
        //oModel:AddGrid("Consulta","MASTER",oStruConsulta)
        //Função que pega o grid que foi adicionado//SerDescription adiciona uma descrição para o model
        //oModel:GetModel('Consulta'):SetDescription('Copia musica/autores')
        //Função SetOnlyQuery está falando que não vai gravar os dados que estão no grid
        //oModel:GetModel('Consulta'):SetOnlyQuery()
        //Função SetOptional esta falando que o grid não é obrigatório ser preenchido.
        //oModel:GetModel('Consulta'):SetOptional() 

        //oModel:SetActivate({|oModel| AfterActivate(oModel)}) 

  
Return oModel

Static Function ViewDef() 

    Local oView := FWFormView():New()
    Local oStruZA3 := FWFormStruct(2, "ZA3")
    local oStruZA4 := FWFormStruct(2, "ZA4")
    local oStruZA5 := FWFormStruct(2, "ZA5")
    //local oStruConsulta := FWFormStruct(2,"ZA4") 
 
        oStruZA4:RemoveField("ZA4_ALBUM")  
        oStruZa5:RemoveField("ZA5_ALBUM") 
        //oStruZa5:RemoveField("ZA5_MUSICA")

        oView:SetModel(ModelDef())
        oView:AddField("ZA3_ALBUM", oStruZA3, "MASTER") 

        oView:AddGrid("GRID_ZA4",oStruZA4,"ZA4DETAIL")
        oView:addIncrementField("GRID_ZA4", "ZA4_MUSICA") 
        oView:EnableTitleView("GRID_ZA4", " Música do albúm")
        //oView:SetViewProperty("GRID_ZA4", "ENABLEDGRIDDETAIL", {20}) 

        oView:AddGrid("GRID_ZA5",oStruZA5,"ZA5DETAIL")
        oView:addIncrementField("GRID_ZA5", "ZA4_MUSICA") 
        oView:EnableTitleView("GRID_ZA5", "Autores da musica do album")
        //oView:SetViewProperty("GRID_ZA5", "ENABLEDGRIDDETAIL", {20})  

        //oView:AddGrid("Consulta",oStruConsulta,"Consulta")

        //oView:AddOtherObject("PANEL_SEL",{|oPanel,oOtherObject| botaoaut(oPanel,oOtherObject)})
 
        oView:CreateHorizontalBox("Album", 20)
        oView:CreateHorizontalBox("Musicas", 40) 
        oView:CreateHorizontalBox("Autores", 30)
        //oView:CreateHorizontalBox("BOX_SEL", 10)
        
        oView:SetOwnerView("ZA3_ALBUM", "Album") 
        oView:SetOwnerView("GRID_ZA4", "Musicas")
        oView:SetOwnerView("GRID_ZA5", "Autores")
        //oView:SetOwnerView("PANEL_SEL","BOX_SEL")
 

Return oView

