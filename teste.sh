#!/bin/bash
#
#
# automaçao DNS 
# Ruan Cesar
#CVC

# variaveis

x="continuar"
shopt -s -o nounset


# verificando privilegios
if sudo -n true 2>/dev/null; then
    echo "O usuário tem privilégios sudo."
    sleep 2
    menu
else
    echo " pfv tenha permiçao sudo para executar esse script"
    echo "saindo..... "
    sleep 3
    exit 1
fi


menu(){
    while true
    do
        echo "------------------------------------menu-------------------------------"
        echo "1. configuraçao do ip statico"
        echo ""
        echo "2. configurar souces.list"
        echo ""
        echo "3. instalar "
        echo ""
        echo "4. desinstalar"
        echo ""
        echo "5. iniciar"
        echo ""
        echo "6. parar"
        echo ""
        echo "7. criar "
        echo ""
        echo "8. editar"
        echo ""
        echo "9 excluir"
        echo ""
        echo "10. informaçoes"
        echo ""
        echo "11. sair"
        echo ""
        echo "selecione a opção"
        read opn
        echo "------------------------------------------------------------------------"
            case "$opn" in
                1)
                    echo "palmeiras nao tem mundial"
                    ;;
                2)
                    echo "mortadelo"
                    ;;
                3)
                    echo "teste"
                    ;;
                4)
                    echo "teste"
                    ;;
                5)
                    echo "teste"
                    ;;
                6)
                    echo "teste"
                    ;;
                7)
                    echo "teste"
                    ;;
                8)
                    echo "teste"
                    ;;
                9)
                    echo "teste"
                    ;;
                10)
                    echo "teste"
                    ;;
                11)
                    echo "teste"
                    ;;
                *)
                    echo "opçao invalida"
                    ;;
            esac
    done
}

menu