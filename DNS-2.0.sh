#!/bin/bash
#
#
# automaçao DNS 
# Ruan Cesar

#variaveis#############################################################################################
pasta="/etc/bind"
arq="named.conf.default-zones"
tudo1="/etc/network/interfaces"
list=/etc/apt/sources.list
x="continuar"

#########################################################################################################

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
        echo "9. excluir"
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
                    echo "configuraçao de ip statico"
                    sleep 2
                    static
                    ;;
                2)
                    echo "configuraçao de source.list"
                    sleep 2
                    souces
                    ;;
                3)
                    if [ comand -v bind9 &>/dev/null ]; then
                        echo " o programa ja esta instalado "
                        echo "voltando para o menu"
                        sleep 2
                        menu
                    else
                        echo " instalando o DNS "
                        sleep 2
                    fi

                    #instalando o programa
                    apt-get install bind9 -y
                    sleep 4
                    ;;
                4)
                    if [ ! comand -v bind9 &>/dev/null ]; then
                        echo " o programa nao esta instalado "
                        echo "voltando para o menu"
                        sleep 2
                        menu
                    else
                        echo " desinstalando o DNS "
                        apt-get remove bind9
                        sleep 2
                    fi
                    ;;
                5)
                    echo "iniciando DNS"
                    sleep 2
                    systemctl start bind9
                    ;;
                6)
                    echo "parando DNS"
                    sleep 2
                    systemctl stop bind9
                    ;;
                7)
                    echo "pfv responda as perguntas abaixo"
                    sleep 2
                    DNS
                    ;;
                8)
                    echo "isso nao funciona ainda, perdao"
                    sleep 2
                    ;;
                9)
                    cho "isso nao funciona ainda, perdao"
                    sleep 2
                    ;;
                10)
                    echo " responda a pergunta abaixo"
                    sleep 2
                    mini
                    ;;
                11)
                    echo "saindo......"
                    sleep 2
                    exit 1
                    ;;
                *)
                    echo "opçao invalida"
                    sleep 2
                    ;;
            esac
    done
}


mini(){
    echo "qual o dominio do seu site sem o (.com/.local) e (sem www )"
    read sitecat
    echo "ok"
    sleep 2
    echo "-----------------------------------------------------------------------"
    echo "qual documento deseja ver?"
    echo ""
    echo "1. named.conf.default-zones"
    echo ""
    echo "2. db.$sitecat"
    echo ""
    echo "3. ver estatus do servidor DNS"
    read opn3
    echo "----------------------------------------------------------------------------------"
    case "$opn3" in
        1)
            cat $pasta/$arq
            sleep 2
            ;;
        2)
            cat $pasta/db.$sitecat
            sleep 2
            ;;
        3)
            systemctl status bind9
            ;;

        *)
            echo "opção invalida"
            sleep 2
            ;;
    esac
}


souces(){
        echo "------------------------------------souce-list-------------------------------"
        echo "1. debian 10"
        echo ""
        echo "2. debian 11"
        echo ""
        echo "3. debian 12 "
        echo ""
        echo "4. voltar"
        echo ""
        echo "echolha uma das opções"
        read opn2
        echo "------------------------------------------------------------------------------"
    case "$opn2" in
        1)
            echo "deb http://deb.debian.org/debian buster main contrib non-free" > $list
            echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> $list
            sleep 2
            ;;
        2)
            echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > $list
            echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> $list
            sleep 2
            ;;
        3)
            echo "deb http://deb.debian.org/debian bookworm main non-free-firmware" > $list
            echo "deb-src http://deb.debian.org/debian bookworm main non-free-firmware" >> $list
            sleep 2
            ;;
        4)
            echo "voltando para o menu"
            sleep 2
            menu
            ;;
        *)
            echo "opção invalida"
            ;;
    esac
}








#perguntas necessarias
DNS(){

    echo "qual é o dominio do seu site? (sem www ) (com .com/.local)"
    read site
    echo "qual o dominio do seu site sem o (.com/.local) e (sem www )"
    read site1
    echo "qual é o ip do servidor web?"
    read web

    #Primeiro Arquivo

    echo zone \"$site\"\ { >> $pasta/$arq
    echo "      type master;" >> $pasta/$arq
    echo        file \"$pasta/db.$site\"\; >> $pasta/$arq
    echo "};" >> $pasta/$arq

    #Segundo arquivo 

    touch $pasta/db.$site
    echo "; BIND reverse data file for empty rfc1918 zone" >> $pasta/db.$site
    echo ";" >> $pasta/db.$site
    echo "; DO NOT EDIT THIS FILE - it is used for multiple zones." >> $pasta/db.$site
    echo "; Instead, copy it, edit named.conf, and use that copy." >> $pasta/db.$site
    echo ";" >> $pasta/db.$site
    echo '$TTL	86400' >> $pasta/db.$site
    echo "@	IN	SOA	ns1.$site. root.$site. (" >> $pasta/db.$site
    echo "			      1		; Serial" >> $pasta/db.$site
    echo "			 604800		; Refresh" >> $pasta/db.$site
    echo "			  86400		; Retry" >> $pasta/db.$site
    echo "			2419200		; Expire" >> $pasta/db.$site
    echo "			  86400 )	; Negative Cache TTL" >> $pasta/db.$site
    echo ";" >> $pasta/db.$site
    echo "@	    IN	NS  ns1.$site1.local." >> $pasta/db.$site
    echo "ns1   IN  A   $web" >> $pasta/db.$site
    echo "www   IN  A   $web" >> $pasta/db.$site
    systemctl restart bind9
}


#configuraçao de ip da maquina
static(){

    echo "qual é o ip da maquina?"
    read ip
    echo "qual é a mask?"
    read mask
    echo "qual  o gateway?"
    read gateway

    echo "source /etc/network/interface.d/*" > $tudo1
    echo "auto lo" >>$tudo1
    echo "iface lo inet loopback" >>$tudo1
    echo "allow-hotplug enp0s3" >>$tudo1
    echo "iface enp0s3 inet static" >>$tudo1
    echo "address $ip" >>$tudo1
    echo "netmask $mask" >>$tudo1
    echo "gateway $gateway" >>$tudo1
    /etc/init.d/networking restart

}


