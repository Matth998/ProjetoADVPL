#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} Playlist
    Cria o Browse da nossa rotina da playlist 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oBrowse Recebe um Buttom, que habilitar uma tela para o cadastro
    do Premium
    @param oBrowse Recebe o FwMBrowse, que é o responsavel por criar o
    Browse no Protheus. 
    @return nil
/*/
//-------------------------------------------------------------------

Return

User Function Playlist()
Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
Local oBrowse := FWMBrowse():New() 

    If MsgYesNo('Você já possui o Premium?')

        oBrowse:SetAlias('ZA7')  
        oBrowse:SetDescription('Playlist')
        oBrowse:SetMenuDef('IOS02') 
        oBrowse:Activate()

        ElseIf MsgYesNo('Deseja ser premium')

            FWExecView('Cadastro Premium','IOS04', MODEL_OPERATION_INSERT, , { || .T. }, , ,aButtons )
 
        Else  

            oBrowse:SetAlias('ZA7')  
            oBrowse:SetDescription('Playlist')
            oBrowse:SetMenuDef('IOS02') 
            oBrowse:Activate() 
 
    EndIf
    
    
Return 

Static Function MenuDef()

Return FWMVCMenu("IOS02")

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
    Cria o menu da nossa rotina da playlist 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oModel Recebe o MPFormModel, que fornece o objeto com o modelo
    hierárquico dos campos de edição.
    @param oStruZA7 Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA7.
    @param oStruZA8 Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA8, que nos traz o grid, com as musicas da playlist
    @param oStruSel Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA0, para nos trazer os nossos autores registrados.
    @param oStruAlb Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA3, para trazer os nossos album registrados.
    Return oModel 
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
Local oModel := MPFormModel():new("IOSPLAY",/*{|| MyPreModelValid()}*/, /*{|| MyPosModelValid()}*/)
Local oStruZA7 := FWFormStruct(1, "ZA7") 
Local oStruZA8 := FWFormStruct(1, "ZA8")
local oStruSel := FWFormStruct(1, "ZA0")
local oStruAlb :=  FWFormStruct(1, "ZA3")

//U_tstdb()

    oStruSel:RemoveField("ZA0_NOTAS")
    oStruSel:RemoveField("ZA0_DTAFAL")
    oStruSel:RemoveField("ZA0_TIPO")
    oStruSel:RemoveField("ZA0_BITMAP")
    oStruSel:RemoveField("ZA0_QTDMUS")
    oStruSel:RemoveField("ZA0_OK")
    oStruSel:RemoveField("ZA0_BIO")
    oStruSel:RemoveField("ZA0_CDSYP1")
    oStruSel:RemoveField("ZA0_MMSYP1")
    oStruSel:RemoveField("ZA0_CDSYP2")
    oStruSel:RemoveField("ZA0_MMSYP2")
    oStruAlb:RemoveField("ZA3_DATA")

    oModel:AddFields("MASTER",,oStruZA7)
  
    oModel:AddGrid("ZA8DETAIL","MASTER",oStruZA8,,{|oGridModel|u_validQtde(oGridModel)},,/*{||presub()}/,/{||possub2()}/)*/)

    oStruSel:AddField("SELECT",'  ',"SELECT", 'L',1,0,,,{}, .F., FwBuildFeature(STRUCT_FEATURE_INIPAD, ".F."))
    oStruAlb:AddField("SELECT",'  ',"SELECT", 'L',1,0,,,{}, .F., FwBuildFeature(STRUCT_FEATURE_INIPAD, ".F.")) 

    //cria o grid
    oModel:AddGrid( 'BUSCA', 'MASTER', oStruSel, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:GetModel( 'BUSCA' ):SetDescription( 'Copiar músicas' )

    oModel:AddGrid( 'BUSCAALB', 'MASTER', oStruAlb, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
    oModel:GetModel( 'BUSCAALB' ):SetDescription( 'Copiar músicas' )

    //define que o grid nao deve ser gravado no banco de dados 
    oModel:GetModel('BUSCA'):SetOnlyQuery(.T.) 

    //define que o grid nao é obrigatorio
    oModel:GetModel('BUSCA'):SetOptional(.T.) 

    //define que o grid nao deve ser gravado no banco de dados 
    oModel:GetModel('BUSCAALB'):SetOnlyQuery(.T.) 

    //define que o grid nao é obrigatorio
    oModel:GetModel('BUSCAALB'):SetOptional(.T.)

    oModel:SetRelation( 'ZA8DETAIL', ;
                        { { 'ZA8_FILIAL', 'xFilial( "ZA8" )' }, ;  
                        { 'ZA8_PLAY', 'ZA7_CODIGO' } }, ; 
                        ZA8->( IndexKey( 1 ) ) )

    oModel:SetPrimaryKey({"ZA7_CODIGO"})
    //oModelGrid:GetModel("ZA8DETAIL"):SetUniqueLine('ZA8_CODIGO','ZA8_NOME') 
    oModel:SetActivate({|oModel|AfterActivate(oModel),AfterAlb(oModel)})    
    oModel:GetModel( 'ZA8DETAIL' ):SetUniqueLine( { "ZA8_NOME"} ) 
 
Return oModel 

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
    Cria o View da nossa rotina da playlist 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oView Recebe o FWFormView, fornece uma visualização grafica da
    nossa rotina.
    @param oStruZA7 Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA7.
    @param oStruZA8 Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA8, que nos traz o grid, com as musicas da playlist
    @param oStruSel Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA0, para nos trazer os nossos autores registrados.
    @param oStruAlb Recebe o FWFormStruct, ele é quem fornece as estruturas
    de metadados do dicionario de dados, ele esta pegando os dados da tabela
    ZA3, para trazer os nossos album registrados.
    Return oView
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView := FWFormView():New()
Local oStruZA7 := FWFormStruct(2, "ZA7")
Local oStruZA8 := FWFormStruct(2, "ZA8")
Local oStruct := FWFormStruct(2, "ZA2")
local oStructZA1 := FWFormStruct(2,'ZA1') 
Local oStruConsulta := FWFormStruct(2,'ZA0')
local oStruAlb := FWFormStruct(2,"ZA3")

    oStruZA8:RemoveField("ZA8_ALBUM")
    oStruZA8:RemoveField("ZA8_PLAY")
    oStruConsulta:RemoveField("ZA0_NOTAS")
    oStruConsulta:RemoveField("ZA0_DTAFAL")
    oStruConsulta:RemoveField("ZA0_TIPO")
    oStruConsulta:RemoveField("ZA0_BITMAP")
    oStruConsulta:RemoveField("ZA0_QTDMUS")
    oStruConsulta:RemoveField("ZA0_OK")
    oStruConsulta:RemoveField("ZA0_BIO")
    oStruConsulta:RemoveField("ZA0_CDSYP1")
    oStruConsulta:RemoveField("ZA0_MMSYP1")
    oStruConsulta:RemoveField("ZA0_CDSYP2")
    oStruConsulta:RemoveField("ZA0_MMSYP2")

    oStruAlb:RemoveField("ZA3_DATA")

    oView:SetModel(ModelDef())
    
    oView:AddField("FIELD_ZA7", oStruZA7, "MASTER")
    oView:EnableTitleView("FIELD_ZA7", "Playlist")

    oView:AddGrid("GRID_ZA8", oStruZA8, "ZA8DETAIL")
    oView:addIncrementField("GRID_ZA8", "ZA8_ITEM")
    oView:EnableTitleView("GRID_ZA8", "Musicas") 
   // oView:SetViewProperty( 'GRID_ZA2', "ENABLEDGRIDDETAIL", { 20 } )

    oStruConsulta:SetProperty("ZA0_CODIGO",MVC_VIEW_CANCHANGE,.F.) 
    oStruConsulta:SetProperty("ZA0_NOME",MVC_VIEW_CANCHANGE,.F.)

    oStruAlb:SetProperty("ZA3_ALBUM",MVC_VIEW_CANCHANGE,.F.) 
    oStruAlb:SetProperty("ZA3_DESCRI",MVC_VIEW_CANCHANGE,.F.)  
 
    //adiciona um campo de selecao no grid
    oStruConsulta:AddField( 'SELECT','01','SELECT','SELECT',, 'Check')
    
    oStruAlb:AddField( 'SELECT','01','SELECT','SELECT',, 'Check')
   
 
    oView:AddGrid('VIEW_BUSCA', oStruConsulta, 'BUSCA')
    oView:AddGrid('VIEW_ALB', oStruAlb, 'BUSCAALB') 

    oView:AddOtherObject("PANEL_SEL",{|oPanel,oOtherObject|BotaoCop(oPanel,oOtherObject)})
    oView:AddOtherObject("PANEL_SEL",{|oPanel,oOtherObject|BotaoAlb(oPanel,oOtherObject)}) 
 

    oView:CreateHorizontalBox("SUPERIOR", 20)
    oView:CreateHorizontalBox("INFERIOR", 40)
    oView:CreateHorizontalBox("CONSULTA", 30)
    oView:CreateHorizontalBox("BUTTOM", 5)
    oView:CreateHorizontalBox("BUTTOMESQ", 5)
    oView:CreateVerticalBox("LEFT",50,"CONSULTA")
    oView:CreateVerticalBox("RIGHT", 50,"CONSULTA") 

    oView:SetOwnerView("FIELD_ZA7", "SUPERIOR")
    oView:SetOwnerView("GRID_ZA8", "INFERIOR")
    oView:SetOwnerView('VIEW_BUSCA', 'LEFT')
    oView:SetOwnerView('VIEW_ALB', 'RIGHT')
    oView:SetOwnerView("PANEL_SEL", "BUTTOM")
    oView:SetOwnerView("PANEL_SEL", "BUTTOMESQ")
 
    oView:addUserButton('Copiar Album','', {||u_MusRepit()})
    oView:addUserButton('Total de faixas','', {|oView|u_Faixas(oView)})
    
    //SetKey( VK_F2,{ || youtube(oView) } )

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} validQtde
    Valida a Quantidade de música adicionada no Grid, caso o cliente não seja 
    premium
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oModel Recebe o modelo da ZA8, para que possa ser feita a contagem
    das musicas
    @param lRet recebe um valor logico, para validar a quantidade de musica.
    returnlRet 
    
/*/
//-------------------------------------------------------------------

User Function validQtde(oGridModel)
    Local oModel := FwModelActive()
    Local lRet := .T.

        If oModel:GetValue("MASTER","ZA7_PREM") == "0"
             
            If oGridModel:Length(.t.) > 5
            
                lRet := .F.
                
                Help( ,, 'HELP',, 'Nao permitimos mais de 5 musicas para usuarios que nao possuem PREMIUM', 1, 0)
            
            Endif

        EndIf
 
Return lRet  

//-------------------------------------------------------------------
/*/{Protheus.doc} MusRepit
    Valida se existe músicas repetidas
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param cCodigo Recebera o código da música
    @param oModel Recebe o nosso modelo da ZA7
    @param oModelGrid Recebe o Grid da ZA8
    @param aArea Recebe um GetArea para podermos dar um RestArea logo após a execução
    Return NIL

/*/
//-------------------------------------------------------------------

User function MusRepit(cCodigo,oModelGrid)

local cCodigo
local oModel
local oModelGrid     
local aArea := GetArea()

    If cCodigo == NIL

        cCodigo := FwInputBox("Digite o código da música para copiar!")
    EndIf

    If oModelGrid == NIL
        oModel := FWModelActive()
        oModelGrid := oModel:GetModel("ZA8DETAIL")
    EndIf 

    DbSelectArea("ZA4")
    DbSetOrder(1) 
    
    If DbSeek(xFilial('ZA4') + PadR(cCodigo,TamSx3('ZA4_ALBUM')[1])) 
        While ZA4->(!EOF()) .AND. ZA4->ZA4_FILIAL == xFilial("ZA4") .AND. ZA4->ZA4_ALBUM == cCodigo
            IF oModelGrid:SeekLine({{"ZA4_ALBUM",ZA4->ZA4_ALBUM},{"ZA4_MUSICA",ZA4->ZA4_MUSICA}}, .F., .F.) // Busca no grid da tela se jÃƒ ¡ existe o autor que eu quero incluir
                oModelGrid:AddLine() //cria uma linha nova em branco no grid 
                oModelGrid:SetValue('ZA8_ALBUM',ZA4->ZA4_ALBUM)
                oModelGrid:SetValue('ZA8_CODIGO',ZA4->ZA4_MUSICA) 
            EndIf
            ZA4->(DbSkip()) 

            /*If oModel:GetModel( 'ZA8DETAIL' ):SetUniqueLine( { "ZA8_NOME"} )
                Alert("musica replicada")
            Endif*/

        EndDo        
    Else
        Help( ,, 'HELP',, 'Código invalido', 1, 0)   
    EndIf 

RestArea(aArea)//restaura estado da tabela ativa
return

//-------------------------------------------------------------------
/*/{Protheus.doc} MusRepit
    Conta o total de faixas (musicas), que foi adicionada na playlist
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param nX recebe 1, para iniciar a contagem
    @param nContagem Recebe quantas faixas tem na música, inicia com 0
    @param oGrid Recebe o Grid da ZA8, para que possa ser feita a contagem
    Return nX
    
/*/
//-------------------------------------------------------------------

User function Faixas(oView)
Local nX
local nContagem := 0
Local oGrid := oView:Getmodel():getModel("ZA8DETAIL")
    DbSelectArea("ZA7")
    DbSetOrder(1) 

    For nX := 1 to oGrid:Length()
        nContagem ++
    Next 
    Help(NIL, NIL, "Total de faixas", NIL, "Voce contem o Total de " + cValtochar(nContagem) + " musicas cadastradas", 1, 0,)
Return nX

//-------------------------------------------------------------------
/*/{Protheus.doc} BotaoCop
    Cria dois botões, sendo um para selecionar todos e outro para copiar as músicas 
    de um determinado autor.
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oPanel Responsavel para criar o nosso panel dos botões
    @param oOtherObject Responsavel para receber a função de selecionar/copiar musicas.
    
    Return oPanel
    
/*/
//-------------------------------------------------------------------

Static function BotaoCop(oPanel,oOtherObject)
            TButton():New(   01,   010,   "Selecionar Todos",oPanel,{||SelGrid(oOtherObject)},   60,10,,,.F.,.T.,.F.,,.F.,,,.F.   )   
            TButton():New(   01,   080,   "Copiar Musicas",oPanel,{||CopiaMus(oOtherObject)},   80,10,,,.F.,.T.,.F.,,.F.,,,.F.   )
Return  oPanel

//-------------------------------------------------------------------
/*/{Protheus.doc} BotaoAlb
    Cria dois botões, sendo um para selecionar todos e outro para copiar as músicas
    de um determinado album. 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oPanel Responsavel para criar o nosso panel dos botões
    @param oOtherObject Responsavel para receber a função de selecionar/copiar musicas.
    
    Return oPanel
    
/*/
//-------------------------------------------------------------------

Static function BotaoAlb(oPanel,oOtherObject)
            TButton():New(   245,   350,   "Selecionar Todos",oPanel,{||SelGridA(oOtherObject)},   60,10,,,.F.,.T.,.F.,,.F.,,,.F.   )    
            TButton():New(   245,   420,   "Copiar Musicas",oPanel,{||CopiaMusAl(oOtherObject)},   80,10,,,.F.,.T.,.F.,,.F.,,,.F.   )  
Return  oPanel  

//-------------------------------------------------------------------
/*/{Protheus.doc} SelGrid
    Função que seleciona todos os artitas, quando o botão selecionar todos é clicado. 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oOtherObject Recebe o nosso grid de BUSCA, para assim ser possivel selecionar
    todas os artistas.
    @param oGrid recebe oOtherObject
    @param nX utilizado para fazer nosso contador
    @param lValue utilizado para fazer a validação se a autor está selecionado, ou não
    @param nLineBkp utilizado para fazer o backup da linha que o usuario estava.

    Return NIL
    
/*/
//-------------------------------------------------------------------

Static Function SelGrid(oOtherObject) 
   
    Local oGrid := oOtherObject:GetModel():GetModel('BUSCA')
    local  nX
    Local lValue
    local nLineBkp := oGrid:GetLine()
             
        For nX := 1 to oGrid:Length()  
                         
            oGrid:Goline(nX)
                        
            If !oGrid:isDeleted()               
                
                lValue := oGrid:GetValue('SELECT')                                    
                
                oGrid:LoadValue('SELECT',!lValue)
            Endif
            
        Next  nX
            
    oGrid:Goline(nLineBkp)            
    
    oOtherObject:oControl:Refresh('BUSCA')

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaMus
    Cria dois botões, sendo um para selecionar todos e outro para copiar as músicas
    de um determinado album. 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oOtherObject Recebe o nosso grid de BUSCAALB, para assim ser possivel selecionar
    todas os álbum.
    @param oGrid recebe oOtherObject
    @param nX utilizado para fazer nosso contador
    @param lSelected utilizado para fazer a validação se a autor está selecionado, ou não, para assim
    fazer a copia de todas as suas musicas.
    @param nLine para ver as linhas que estão selecionadas.

    Return NIL
    
/*/
//-------------------------------------------------------------------

Static Function CopiaMus(oOtherObject)

    Local oGrid := oOtherObject:GetModel():GetModel('BUSCA') 
    Local nX
    local lSelected 
    Local oGridAutores := oOtherObject:GetModel():GetModel("ZA8DETAIL") 
    Local nLine := oGridAutores:GetLine()

        For nX := 1 To oGrid:Length()                  
 
            If !oGrid:isDeleted()
     
                lSelected := oGrid:GetValue('SELECT',nX)
                                                 
                If lSelected

                    u_CopiMus(oGrid:GetValue("ZA0_CODIGO", nX), ,oGridAutores)

                Endif   
            
            Endif   
         Next nX

        oOtherObject:oControl:Refresh('BUSCA')
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaAlb
    Ativa o modelo ZA0, para mostrar os autores cadastrados.
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oStructZA0 Pega a área da tabela ZA3
    @param cMyFilial Recebe o código da nossa filial
    @param oGridConsulta recebe o modelo BUSCA

    Return NIL
    
/*/
//-------------------------------------------------------------------

Static Function AfterActivate(oModel)
    
    local oStructZA0 := ZA0->(GetArea())
    local cMyFilial   := xFilial('ZA0')
    Local oGridConsulta := oModel:GetModel("BUSCA")
       
        If oModel:GetOperation() == 3 .or. oModel:GetOperation() == 4          
        ZA0->(DbSetOrder(1))
        ZA0->(DBGoTop())
                            
            While ZA0->(!EOF())  .and. ZA0->ZA0_FILIAL == cMyFilial                            
                                                               
                If !oGridConsulta:IsEmpty()                       
                    oGridConsulta:AddLine()  
                Endif                                  
                
                oGridConsulta:LoadValue("ZA0_CODIGO",ZA0->ZA0_CODIGO)
                oGridConsulta:LoadValue("ZA0_NOME",ZA0->ZA0_NOME)  
                                         
                ZA0->(DbSkip())
            EndDo
        Endif
    RestArea(oStructZA0)


    
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaMus
    Copia as músicas que estão selecionadas. 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oOtherObject Recebe o nosso grid de BUSCA, para assim ser possivel selecionar
    todas os álbum.
    @param aArea recebe a área que está adivinha.
    @param nX utilizado para fazer nosso contador
    @param cPergunta recebe o código do autor, para fazer o while para adicionar as músicas
    desse autor.
    @param nLine para ver as linhas que o usuario está.

    Return NIL
    
/*/
//-------------------------------------------------------------------

User Function CopiMus(cPergunta,oModel, oGridModel)

Local aArea := GetArea()
Local cPergunta
local oModel

    If cPergunta == NIL

        cPergunta := FwInputBox("Codigo do autor")

    Endif

    If oGridModel == NIL

        oModel := FwModelActive()
        oGridModel:= oModel:GetModel("ZA2DETAIL")

    EndIf

    DbSelectArea('ZA2')
    DbSetOrder(2)

     If DbSeek(xFilial('ZA2') + PadR(cPergunta,TamSx3('ZA2_MUSICA')[1]))

        While ZA2->(!Eof()) .and. ZA2->ZA2_FILIAL + ZA2->ZA2_AUTOR == xFilial('ZA2')+cPergunta
        
           If !(oGridModel:SeekLine({{"ZA8_CODIGO",ZA2->ZA2_MUSICA}},.F.,.F.))
                
                If !oGridModel:IsEmpty()  
                    
                    oGridModel:AddLine()
                EndIf

                oGridModel:SetValue('ZA8_CODIGO',ZA2->ZA2_MUSICA) 
                oGridModel:SetValue("ZA8_NOME",POSICIONE("ZA1",1,xFilial("ZA1")+ZA2->ZA2_MUSICA, "ZA1_TITULO" )) 
            
            Else

               Help(NIL, NIL, "Musica ja adicionada", NIL, "Está musica ja foi adicionada!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor, revise o código, e tente novamente!"})
            EndIf
            
            DbSkip()

        EndDo
    Else

        Help(NIL, NIL, "Código invalido", NIL, "Código invalido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Código invalido, por favor, revise!"})

    EndIf

    RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaAlb
    Ativa o modelo ZA3, para mostrar os álbuns cadastrados.
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oStructZA3 Pega a área da tabela ZA3
    @param cMyFilial Recebe o código da nossa filial
    @param oGridConsulta recebe o modelo BUSCAALB

    Return NIL
    
/*/
//-------------------------------------------------------------------

Static Function AfterAlb(oModel)

    local oStructZA3 := ZA3->(GetArea()) 
    local cMyFilial   := xFilial('ZA3')
    Local oGridConsulta := oModel:GetModel("BUSCAALB")
           
        If oModel:GetOperation() == 3 .or. oModel:GetOperation() == 4      
        
        ZA3->(DbSetOrder(2))
        ZA3->(DBGoTop())
                            
         While ZA3->(!EOF())  .and. ZA3->ZA3_FILIAL == cMyFilial                            
                                                               
                If !oGridConsulta:IsEmpty()                       
                    oGridConsulta:AddLine()  
                Endif                                  
                
                oGridConsulta:LoadValue("ZA3_ALBUM",ZA3->ZA3_ALBUM)
                oGridConsulta:LoadValue("ZA3_DESCRI",ZA3->ZA3_DESCRI)  
                                         
                ZA3->(DbSkip())
            EndDo 
        
        EndIf
    
    RestArea(oStructZA3)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SelGrid
    Função que seleciona todos os artitas, quando o botão selecionar todos é clicado. 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oOtherObject Recebe o nosso grid de BUSCAALB, para assim ser possivel selecionar
    todas os álbum.
    @param oGrid recebe oOtherObject
    @param nX utilizado para fazer nosso contador
    @param lValue utilizado para fazer a validação se a autor está selecionado, ou não
    @param nLineBkp utilizado para fazer o backup da linha que o usuario estava.

    Return NIL
    
/*/
//-------------------------------------------------------------------

Static Function SelGridA(oOtherObject)

    Local oGrid := oOtherObject:GetModel():GetModel('BUSCAALB')
    local  nX
    Local lValue
    local nLineBkp := oGrid:GetLine()
             
        For nX := 1 to oGrid:Length()  
                         
            oGrid:Goline(nX)
                        
            If !oGrid:isDeleted()               
                
                lValue := oGrid:GetValue('SELECT')                                    
                
                oGrid:LoadValue('SELECT',!lValue)
            Endif
            
        Next  nX
            
    oGrid:Goline(nLineBkp)            
    
    oOtherObject:oControl:Refresh('BUSCAALB')

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaMusAl
    Copia as músicas dos albuns que estão selecionados.
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oOtherObject Recebe o nosso grid de BUSCAALB, para assim ser possivel selecionar
    todas os álbum.
    @param oGrid recebe oOtherObject
    @param nX utilizado para fazer nosso contador
    @param lSelected utilizado para fazer a validação se a autor está selecionado, ou não, para assim
    fazer a copia de todas as suas musicas.
    @param nLine para ver as linhas que estão selecionadas.

    Return NIL
    
/*/
//-------------------------------------------------------------------

Static Function CopiaMusAl(oOtherObject)

    Local oGrid := oOtherObject:GetModel():GetModel('BUSCAALB') 
    Local nX
    local lSelected 
    Local oGridAutores := oOtherObject:GetModel():GetModel("ZA8DETAIL") 
    Local nLine := oGridAutores:GetLine()

        For nX := 1 To oGrid:Length()                  
 
            If !oGrid:isDeleted()
     
                lSelected := oGrid:GetValue('SELECT',nX)
                                                 
                If lSelected

                    u_CopiaAlb(oGrid:GetValue("ZA3_ALBUM", nX), ,oGridAutores) 

                Endif   
            
            Endif   
         Next nX

        oOtherObject:oControl:Refresh('BUSCAALB') 
Return 

//-------------------------------------------------------------------
/*/{Protheus.doc} CopiaAlb
    Cria dois botões, sendo um para selecionar todos e outro para copiar as músicas
    de um determinado album. 
    @author Matheus S. Oliveira
    @since 28/11/2019
    @param oOtherObject Recebe o nosso grid de BUSCAALB, para assim ser possivel selecionar
    todas os álbum.
    @param aArea recebe a área que está adivinha.
    @param nX utilizado para fazer nosso contador
    @param cPergunta recebe o código do album, para fazer o while para adicionar as músicas
    desse album
    @param nLine para ver as linhas que estão selecionadas.

    Return NIL
    
/*/
//-------------------------------------------------------------------

User Function CopiaAlb(cPergunta,oModel, oGridModel) 

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

        While ZA4->(!Eof()) .and. ZA4->ZA4_FILIAL + ZA4->ZA4_ALBUM == xFilial('ZA4')+cPergunta
        
           If !(oGridModel:SeekLine({{"ZA8_CODIGO",ZA4->ZA4_MUSICA}},.F.,.F.))
                
                If !oGridModel:IsEmpty()  
                    
                    oGridModel:AddLine()
                EndIf

                oGridModel:SetValue('ZA8_CODIGO',ZA4->ZA4_MUSICA)  
                oGridModel:SetValue("ZA8_NOME",POSICIONE("ZA1",1,xFilial("ZA1")+ZA4->ZA4_MUSICA, "ZA1_TITULO" )) 
            
            Else

               Help(NIL, NIL, "Musica ja adicionada", NIL, "Está musica ja foi adicionada!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor, revise o código, e tente novamente!"})
            EndIf
            
            DbSkip()

        EndDo
    Else

        Help(NIL, NIL, "Código invalido", NIL, "Código invalido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Código invalido, por favor, revise!"})

    EndIf

    RestArea(aArea)

Return


