#!/bin/bash

red="\e[0;31m"
green="\e[0;32m"
off="\e[0m"

function banner() {
clear
echo "                                                                                               ";
echo " .########..########..######...#######..##....##....##......##..#######..##.......########	 "; 
echo " .##.....##.##.......##....##.##.....##.###...##....##..##..##.##.....##.##.......##......	 "; 
echo " .##.....##.##.......##.......##.....##.####..##....##..##..##.##.....##.##.......##......	 "; 
echo " .########..######...##.......##.....##.##.##.##....##..##..##.##.....##.##.......######..	 "; 
echo " .##...##...##.......##.......##.....##.##..####....##..##..##.##.....##.##.......##......	 "; 
echo " .##....##..##.......##....##.##.....##.##...###....##..##..##.##.....##.##.......##......	 "; 
echo " .##.....##.########..######...#######..##....##.....###..###...#######..########.##......	 ";  
echo "                                                                                               ";   
}



function linux() {
echo -e "$red [$green+$red]$off Installing Perl ...";
sudo apt-get install -y perl
echo -e "$red [$green+$red]$off Installing JSON Module ...";
cpan install JSON
  echo -e "$red [$green+$red]$off Checking directories..."
if [ -d "/usr/share/ReconWolf" ]; then
    echo -e "$red [$green+$red]$off A Directory ReconWolf Was Found! Do You Want To Replace It? [Y/n]:" ;
    read replace
    if [ "$replace" = "y" ]; then
      sudo rm -r "/usr/share/ReconWolf"
      sudo rm "/usr/share/icons/ReconWolf.png"
      sudo rm "/usr/share/applications/ReconWolf.desktop"
      sudo rm "/usr/local/bin/ReconWolf"

else
echo -e "$red [$green✘$red]$off If You Want To Install You Must Remove Previous Installations";
echo -e "$red [$green✘$red]$off Installation Failed";
        exit
    fi
fi 

echo -e "$red [$green+$red]$off Installing ...";
echo -e "$red [$green+$red]$off Creating Symbolic Link ...";
echo -e "#!/bin/bash
perl /usr/share/ReconWolf/reconwolf.pl" '${1+"$@"}' > "reconwolf";
    chmod +x "reconwolf";
    sudo mkdir "/usr/share/ReconWolf"
    sudo cp "install.sh" "/usr/share/ReconWolf"
    sudo cp "reconwolf.pl" "/usr/share/ReconWolf"
    sudo cp "config/ReconWolf.png" "/usr/share/icons"
    sudo cp "config/ReconWolf.desktop" "/usr/share/applications"
    sudo cp "reconwolf" "/usr/local/bin/"
    rm "reconwolf";

if [ -d "/usr/share/ReconWolf" ] ;
then
echo -e "$red [$green+$red]$off ReconWolf Successfully Installed And Will Start In 5s!";
echo -e "$red [$green+$red]$off You can execute ReconWolf by typing reconwolf"
sleep 5;
reconwolf
else
echo -e "$red [$green✘$red]$off ReconWolf Cannot Be Installed On Your System! Use It As Portable !";
    exit
fi 
}

if [ -d "/usr/bin/" ];then
banner
echo -e "$red [$green+$red]$off ReconWolf Will Be Installed In Your System";
linux
else
echo -e "$red [$green✘$red]$off ReconWolf Cannot Be Installed On Your System! Use It As Portable !";
    exit
fi
