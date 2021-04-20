# CamPhish
Capture tomas de cámara desde la cámara frontal del teléfono objetivo o la cámara web de la PC simplemente enviando un enlace.
<!--![cheese](https://techchip.net/wp-content/uploads/2020/04/camphish.jpg)-->

# ¿Qué es CamPhish?
<p>CamPhish es una técnica para tomar fotografías de la cámara del teléfono del objetivo o de la cámara web de la PC. CamPhish aloja un sitio web falso en un servidor PHP integrado y utiliza ngrok & serveo para generar un enlace que enviaremos al objetivo, que se puede utilizar a través de Internet. El sitio web solicita permiso de la cámara y, si el objetivo lo permite, esta herramienta captura capturas de cámara del dispositivo del objetivo.</p>

## Características
<p>En esta herramienta, agregué dos plantillas de página web automáticas para el objetivo comprometido en la página web para obtener más imágenes de la cámara.</p>
<ul>
  <li>Facebook</li>
  <li>Instagram</li>
  <li>Meet</li>
  <li>Youtube</li>
  <li>Google</li>
</ul>
<p><strong>Facebook:</strong> Sencillo como ingresar la foto de perfil, nombre del usuario, foto y descripcion de la publicación</p>

## Esta herramienta probada en:
<ul>
  <li>Kali Linux</li>
  <li>Termux</li>
  <li>MacOS</li>
  <li>Ubuntu</li>
  <li>Perrot Sec OS</li>
</ul>

# Instalación y requisitos
<p>Esta herramienta requiere PHP para servidor web, SSH o serveo link. Primero ejecute el siguiente comando en su terminal</p>

```
apt-get -y install php openssh git wget
```

## Instalación (Kali Linux/Termux):

```
git clone https://github.com/techchipnet/CamPhish
cd CamPhish
bash camphish.sh
```