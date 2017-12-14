#!/bin/bash
blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/SATPX.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/SATPX.log) ;}

echo "SATPX iniciado $(date)" >> /tmp/SATPX.log
chmod 777 /tmp/SATPX.log

pacman -S --noconfirm --needed dialog || (echo "Erro na inicializacaoo do script: Voce esta certo que esta rodando isso como usuario root? Voce se certificou que tem uma conexao com a internet?" && exit)

dialog --title "Bem Vindo!" --msgbox "Bem vindo ao Script do Timoteo para producao extrema!\n\nEste script ira instalar automaticamente um desktop completo no Arch Linux utilizando o i3wm, que utilizo como meu ambiente de desenvolvimento principal.\n\n-Timoteo" 10 60

dialog --no-cancel --inputbox "Primeiro, entre com o nome do seu usuario." 10 60 2> /tmp/.name

dialog --no-cancel --passwordbox "Entre com uma senha para este usuario." 10 60 2> /tmp/.pass1
dialog --no-cancel --passwordbox "Digite a senha novamente." 10 60 2> /tmp/.pass2

while [ $(cat /tmp/.pass1) != $(cat /tmp/.pass2) ]
do
	dialog --no-cancel --passwordbox "Senhas nao coencidem.\n\nEntre com a senha novamente." 10 60 2> /tmp/.pass1
	dialog --no-cancel --passwordbox "Digite a senha novamente." 10 60 2> /tmp/.pass2
done

chmod 777 /tmp/.name
NAME=$(cat /tmp/.name)
shred -u /tmp/.name
useradd -m -g wheel -s /bin/bash $NAME

echo "$NAME:$(cat /tmp/.pass1)" | chpasswd
#Senha deletada por segurança
shred -u /tmp/.pass1
shred -u /tmp/.pass2

cmd=(dialog --separate-output --checklist "Selecione pacotes adicionais para instalar com <ESPACO>" 22 76 16)
options=(1 "Pacotes LaTeX" off
         2 "Libreoffice Suite" off
         3 "GIMP" off
         4 "Blender" off
	 5 "Emacs" off
	 6 "Transmission, cliente de bittorrent" off
	 7 "Visualizadores de musica" off
	 )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $choices > /tmp/.choices

brow=(dialog --separate-output --checklist "Selecione um navegador (nenhum ou quantos preferir):" 22 76 16)
options=(1 "qutebrowser" off
         2 "Firefox" off
         3 "Firefox-nightly" off
         4 "Chrome" off
	 )
browch=$("${brow[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $browch > /tmp/.browch

dialog --title "Vamos começar!" --msgbox "O resto da instalacao sera totalmente automatizada, entao pode ir tomar um cafe e relaxar!\n\nPodera levar um tempo, dependendo da sua internet, mas quando acabar, voce tera um sistema completamente instalado e funcional!\n\nAgora aperte <OK> e o sistema comecara a instalacao!" 13 60

clear

cat << "EOF"
					  
 mmmmm                   	 	             
 #   "#  mmm    mmm   mmm   mmm   mmm   mmm   mmm  
 #mmmm" #  "#  #"  # #  "# "   # #  "# "   # #  "# 
 #      #mmm   #"""" #mmm" m"""# #mmm" m"""# #mmm" 
 #      #  "#  "#mm" #     "mm"# #  "# "mm"# #  "# 
	  		 		                
EOF
sleep 1
cat << "EOF"
			    
 mmmm			    # 
#"  "#	 mmm   mmm   mmm  mm#mm  mmm   mmm 
#mmmm#	#  "# #" "# #" "#   #   "   # #  "#
#"  "#	#mmm" #	  # #	#   #   m"""# #mmm"
#    #	#     "mmm" #	#   "mm "mm"# #  "#

EOF
sleep 1

#Prints metal gay
cat << "EOF"
                     
mm_mm               #          #   
  #    mmm  #"""m mm#mm  mmm   #    mmm   mmm 
  #   #" "# "mmm    #   "   #  #   "   # #  "#
  #   #   #    "#   #   m"""#  #   m"""# #mmm"
mm"mm #   # "mmm"   "mm "mm"#  "mm "mm"# #  "#     	

EOF
sleep .5


blue \[1\/6\] Instalando programas basicos...
pacman --noconfirm --needed -Sy \
	base-devel \
	xorg-xinit \
	xorg-server \
	compton \
	arandr \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	rxvt-unicode \
	unzip \
	unrar \
	wget \
	atool \
	ntfs-3g \
	xf86-video-intel \
 	dosfstools \
	cups \
	transset-df \
	htop || (red Erro instalado os programas basicos. Verifique sua conexao com a internet.)


blue \[2\/6\] Instalando programas principais para \(produtividade\)...
pacman --noconfirm --needed -Sy \
	calcurse \
	ranger \
	gvim \
	rofi \
	poppler \
	mupdf \
	evince \
	pandoc || (red Erro instalado os programas de produtividade. Verifique sua conexao com a internet.)


blue \[3\/6\] Instalado os programas principais para \(rede e internet\)...
pacman --noconfirm --needed -Sy \
	wireless_tools \
	network-manager-applet \
	networkmanager \
	w3m \
	offlineimap \
	msmtp \
	rsync || (red Erro instalado os programas para redes e internet. Verifique sua conexao com a internet.)


blue \[4\/6\] Instalando os programas principais para \(graficos\)...
pacman --noconfirm --needed -Sy \
	feh \
	imagemagick \
	scrot \
	libcaca || (red Erro instalado os programas para redes e internet. Verifique sua conexao com a internet.)


blue \[5\/6\] Instalando os programas principais para \(audio\)...
pacman --noconfirm --needed -Sy \
	ffmpeg \
	pulseaudio \
	pulseaudio-alsa \
	pavucontrol \
	pamixer \
	mpd \
	ncmpcpp \
	mediainfo \
	mpv || (red Erro instalado os programas para redes e internet. Verifique sua conexao com a internet.)


blue \[6\/6\] Instalando os programas principais para \(desenvolvimento\)...
pacman --noconfirm --needed -Sy \
	python-dbus \
	python-gobject \
	discount \
	git \
	r \
	highlight || (red Erro instalado os programas para redes e internet. Verifique sua conexao com a internet.)


pacman --noconfirm --needed -S fzf || (red Erro com os programas perifericos.)

for choice in $choices
do
    case $choice in
        1)
	    blue Instalando LaTeX packages...
	    pacman --noconfirm --needed -S texlive-most texlive-lang biber
            ;;
        2)
	    blue Instalando LibreOffice Suite...
	    pacman --noconfirm --needed -S libreoffice-fresh
            ;;
        3)
	    blue Instalando GIMP...
	    pacman --noconfirm --needed -S gimp
            ;;
        4)
	    blue Instalando Blender...
	    pacman --noconfirm --needed -S blender
            ;;
	5)
	    blue Instalando Emacs...
	    pacman --noconfirm --needed -S emacs
	    ;;
	6)
	    blue Instalando transmission...
 	    pacman --noconfirm --needed -S transmission-cli
	    ;;
	7)
	    blue Instalando visualizers and decoration...
    	    pacman --noconfirm --needed -S projectm-pulseaudio cmatrix asciiquarium screenfetch
	    ;;
    esac
done

for choice in $browch
do
    case $choice in
        1)
	    blue Instalando qutebrowser...
	    pacman --noconfirm --needed -S qutebrowser gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
            ;;
        2)
            blue Instalando Firefox...
	    pacman --noconfirm --needed -S firefox
            ;;
        3)
            blue Instalando Firefox...
	    pacman --noconfirm --needed -S firefox-nightly
            ;;
    esac
done

curl https://raw.githubusercontent.com/Timoteohss/SATPX/master/sudoers_tmp > /etc/sudoers

cd /tmp
blue Alterando diretorio para /tmp/...
blue Baixando a proxima parte do script \(satpx_user.sh\)...
curl https://raw.githubusercontent.com/Timoteohss/SATPX/master/satpx_user.sh > /tmp/satpx_user.sh && blue Rodando satpx_user.sh como $NAME...
sudo -u $NAME bash /tmp/satpx_user.sh || red Erro rodando satpx_user.sh...
rm -f /tmp/satpx_user.sh

blue Ligando o  Network Manager...
systemctl enable NetworkManager
systemctl start NetworkManager

blue Calado!...
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

blue Implementando arquivo sudoers temporario...
curl https://raw.githubusercontent.com/Timoteohss/SATPX/master/sudoers > /etc/sudoers 

dialog --title "Tudo pronto!" --msgbox "Parabens! Caso nao tenha tido erros no caminho, o script foi completo com sucesso e todos os programas e configuracoes devem estar no lugar.\n\nPara execurar seu ambiente visual, deslogue e logue novamente no seu novo usuario, e entao execute o comando \"startx\".\n\n-Timoteo" 12 80
clear

