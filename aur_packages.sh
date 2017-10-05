#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
printf "${BLUE}Changing directory to /home/$USER...\n${NC}"
cd /home/$USER

error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 ;}
#error() { dialog --title "Error!" --msgbox "We've run into a fatal-ish error. Check the LARBS.log file for more information" 10 60 && clear && exit ;}

printf "${BLUE}Installing packer as an AUR manager...\n${NC}"

aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. && rm -rf $1 $1.tar.gz ;}

qm=$(pacman -Qm | awk '{print $1}')

aurcheck() {
for arg in "$@"
do
if [[ $qm = *"$arg"* ]]; then
	echo $arg is already installed.
else
	echo $arg not installed
	printf "${BLUE}\nNow installing $arg...\n${NC}"
	aurinstall $arg && printf "${BLUE}\n$arg now installed.\n${NC}"
fi
done
}
aurcheck packer || (echo "Error installing packer." >> LARBS.log && error)

printf "${BLUE}Installing AUR programs...\n${NC}"
printf "${BLUE}(May take some time.)\n${NC}"

#Add the needed gpg key for neomutt
gpg --recv-keys 5FAF0A6EE7371805

aurcheck i3-gaps vim-pathogen neofetch i3lock tamzen-font-git neomutt unclutter-xfixes-git urxvt-resize-font-git polybar-git python-pywal xfce-theme-blackbird || (echo "Error installing AUR packages. Check your internet connections and pacman keys." >> LARBS.log)

#packer --noconfirm -S ncpamixer-git speedometer cli-visualizer

choices=$(cat choices)
for choice in $choices
do
    case $choice in
        1)
		printf "\n${BLUE}Now installing LaTeX packages...\n${NC}"
		aurcheck vim-live-latex-preview
		git clone https://github.com/lukesmithxyz/latex-templates.git && mkdir -p /home/$USER/Documents/LaTeX && rsync -va latex-templates /home/$USER/Documents/LaTeX && rm -rf latex-templates
        	;;
	6)
		printf "\n${BLUE}Now installing extra fonts...\n${NC}"
		aurcheck ttf-ancient-fonts
		;;
	7)
	    printf "\n${BLUE}Now installing transmission-remote-cli...\n${NC}"
		aurcheck transmission-remote-cli-git
		;;
    esac
done
browsers=$(cat browch)
for choice in $browsers
do
	case $choice in
		3)
			printf "\n${BLUE}Now installing Palemoon...\n${NC}"
			$ gpg --recv-keys 865E6C87C65285EC
			aurcheck palemoon-bin
			;;
		4)
			printf "\n${BLUE}Now installing Waterfox...\n${NC}"
			aurcheck waterfox-bin
			;;
	esac
done
