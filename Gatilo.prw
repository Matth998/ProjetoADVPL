#include 'protheus.ch'

User Function GatiloGe()

    local cGenero := ""

        Do Case
            
            Case ZA1->ZA1_GENERO == "R"

            cGenero := "Rock"

            Case ZA1->ZA1_GENERO == "B"

                cGenero := "Blues"
             
            Case ZA1->ZA1_GENERO == "C"

                cGenero := "Classico"
            
            Case ZA1->ZA1_GENERO == "G"

                cGenero := "Reggae"

            Case ZA1->ZA1_GENERO == "E"

                cGenero := "Eletron"

            Case ZA1->ZA1_GENERO == "O"

                cGenero := "cOuntry"

            Case ZA1->ZA1_GENERO == "L"

                cGenero := "Latin"

            Case ZA1->ZA1_GENERO == "S"

                cGenero := "Samba"

        EndCase

Return cGenero