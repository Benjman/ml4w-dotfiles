# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------

wallpaper_folder="wallpaper"

_define_wallpaper_folder() {
    echo ":: Please enter the name of the folder to store wallpapers starting from your home directory."
    echo ":: (e.g., wallpaper or Documents/wallpaper, ...)"
    wallpaper_folder_tmp=$(gum input --value "$wallpaper_folder" --placeholder "Enter your wallpaper folder name")
    wallpaper_folder=${wallpaper_folder_tmp//[[:blank:]]/}
    if [[ $wallpaper_folder == ".ml4w-hyprland" ]] ;then
        echo ":: The folder .ml4w-hyprland is not allowed."
        _define_wallpaper_folder
    elif [ $? -eq 130 ] ;then
        echo ":: Wallpaper installation canceled."
        exit
    elif [ ! -z $wallpaper_folder ] ;then
        _confirm_wallpaper_folder
    else
        echo "ERROR: Please define a folder name"
        _define_wallpaper_folder
    fi
}

_confirm_wallpaper_folder() {
    echo ":: The wallpapers will be downloaded to ~/$wallpaper_folder"
    echo
    if gum confirm "Do you want use this folder?" ;then
        # Write wallpaper folder into settings
        touch ~/.config/ml4w/settings/wallpaper-folder.sh
        echo "$wallpaper_folder" > ~/.config/ml4w/settings/wallpaper-folder.sh
        if [ ! -d ~/$wallpaper_folder ] ;then 
            mkdir ~/$wallpaper_folder
        fi
    else
        _define_wallpaper_folder
    fi
}

echo -e "${GREEN}"
figlet -f smslant "Wallpapers"
echo -e "${NONE}"

if [ -f ~/.config/ml4w/settings/wallpaper-folder.sh ] ;then
    echo ":: An existing wallpaper folder has been detected: ~/$(cat ~/.config/ml4w/settings/wallpaper-folder.sh)"
    # Get the first non-comment line
    wallpaper_folder=$(grep -v "^[[:space:]]*#" ~/.config/ml4w/settings/wallpaper-folder.sh | head -n 1 | cut -d "=" -f 2- | sed 's|\$HOME\/||')
fi

_confirm_wallpaper_folder

cp $wallpaper_directory/* ~/$wallpaper_folder/
echo ":: Default wallpapers installed successfully."
echo
echo "You can download and install additional wallpapers from https://github.com/mylinuxforwork/wallpaper/"
echo
if gum confirm "Do you want to download the repository?" ;then
    if [ -d ~/Downloads/wallpaper ] ;then
        rm -rf ~/Downloads/wallpaper
        echo ":: ~/Downloads/wallpaper deleted"
    fi
    git clone --depth 1 https://github.com/mylinuxforwork/wallpaper.git ~/Downloads/wallpaper
    rsync -a -I --exclude-from=$install_directory/includes/excludes.txt ~/Downloads/wallpaper/. ~/$wallpaper_folder/
    echo "Wallpapers from the repository installed successfully."
elif [ $? -eq 130 ] ;then
    exit 130
else
    echo ":: Installation of wallpaper repository skipped."
fi
echo

# ------------------------------------------------------
# Copy default wallpaper files to .cache
# ------------------------------------------------------

# Cache file for holding the current wallpaper
cache_file="$HOME/.config/ml4w/cache/current_wallpaper"
rasi_file="$HOME/.config/ml4w/cache/current_wallpaper.rasi"

# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "~/$wallpaper_folder/default.jpg" > "$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
    echo "* { current-image: url(\"~/$wallpaper_folder/default.jpg\", height); }" > "$rasi_file"
fi
