#!/bin/bash

blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/LARBS.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/LARBS.log) ;}

NAME=$(whoami)

blue Activando PulseAudio...
pulseaudio --start && blue Pulseaudio ativo...

#Instala um pacote AUR manualmente.
aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. && rm -rf $1 $1.tar.gz ;}

#aurcheck roda para cada argumento, se o argumento já não estiver instalado, ele usa o packer para o instalar, ou instala manualmente 
aurcheck() {
qm=$(pacman -Qm | awk '{print $1}')
for arg in "$@"
do
if [[ $qm = *"$arg"* ]]; then
	echo $arg já instalado.
else 
	echo $arg não instalado
	blue Instalando $arg...
	if [[ -e /usr/bin/packer ]]
	then
		(packer --noconfirm -S $arg && blue $arg agora instalado) || red Erro instalando $arg.
	else
		(aurinstall $arg && blue $arg agora instalado) || red Erro instalando $arg.
	fi

fi
done
}


blue Instalando programas do AUR...
blue \(Isso pode levar um tempo..\)

aurcheck packer i3-gaps vim-pathogen tamzen-font-git unclutter-xfixes-git urxvt-resize-font-git polybar python-pywal xfce-theme-blackbird fzf-git || red Erro na instalação dos pacotes AUR...
#Also installing i3lock, since i3-gaps was only just now installed.
sudo pacman -S --noconfirm --needed i3lock

choices=$(cat /tmp/.choices)
for choice in $choices
do
    case $choice in
    1)
		aurcheck vim-live-latex-preview
        ;;
	6)
		aurcheck transmission-remote-cli-git
		;;
	7)
		aurcheck bash-pipes cli-visualizer speedometer neofetch
		;;
    esac
done
cat << "EOF"

         ▄              ▄
        ▌▒█           ▄▀▒▌
        ▌▒▒▀▄       ▄▀▒▒▒▐
       ▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
     ▄▄▀▒▒▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
   ▄▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀██▀▒▌
  ▐▒▒▒▄▄▄▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄▒▒▌
  ▌▒▒▐▄█▀▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
 ▐▒▒▒▒▒▒▒▒▒▒▒▌██▀▒▒▒▒▒▒▒▒▀▄▌
 ▌▒▀▄██▄▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▌
 ▌▀▐▄█▄█▌▄▒▀▒▒▒▒▒▒░░░░░░▒▒▒▐
▐▒▀▐▀▐▀▒▒▄▄▒▄▒▒▒▒▒░░░░░░▒▒▒▒▌
▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒░░░░░░▒▒▒▐
 ▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒▒▒░░░░▒▒▒▒▌
 ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐
  ▀▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▒▒▌
    ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
   ▐▀▒▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
  ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▀
		  wow
EOF



browsers=$(cat /tmp/.browch)
for choice in $browsers
do
	case $choice in
        	3)
	    		pacman --noconfirm --needed -S firefox-nightly
            		;;
		4)
			aurcheck google-chrome
			;;
	esac
done

blue Baixando arquivos de configuração...
git clone https://github.com/timoteohss/dotfiles.git && rsync -va dotfiles/ /home/$NAME && rm -rf dotfiles

blue Gerando atalhos para o bash/ranger/qutebrowser...
cd /home/$NAME/
python /home/$NAME/.config/Scripts/shortcuts.py
