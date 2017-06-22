#!/usr/local/bin/bash


# GL 03/2017 Latest version
#Mount specified partition w/ sshfs on a MAC OS system
#
# NOTE: you may have to upgrade your bash to v4
# see: http://concisionandconcinnity.blogspot.fr/2009/03/upgrade-bash-to-40-in-mac-os-x.html


ME=`whoami`

function _VMmount() {
    local volume=$1
    local remote=$2
    [[ -d $1 ]] && {
        echo "Volume found try to unmount it first"
        exit 1
    }
    sudo mkdir $1
    local shortName=`basename $volume`
    cmd="sudo $sshfs $ME@$remote:// $volume -o allow_other,volname=\"$shortName\",defer_permissions,IdentityFile=~/.ssh/id_rsa"

    echo "-->$cmd"
    if $cmd; then
        echo "mount of $volume successfull"
    else
        echo "mount of $volume failed"
        echo "-->$cmd"
    fi

}

function _mount () {
    local volume=$1
    local remote=$2
    [[ -d $1 ]] && {
        echo "Volume found try to unmount it first"
        exit 1
    }
    sudo mkdir $1
    local shortName=`basename $volume`
    cmd="sudo $sshfs $ME@$remote:// $volume -o allow_other,volname=\"$shortName\",defer_permissions,IdentityFile=~/.ssh/id_rsa"
    if $cmd; then
        echo "mount of $volume successfull"
    else
        echo "mount of $volume failed"
        echo "-->$cmd"
    fi
}

function _unmount () {
    local volume=$1
    [[ -d $1 ]] || { ## IF test fails the mountpoint cant still exist w/ i/O errors
        echo "Volume not found, nothing to unmount"
        exit 0
    }
    cmd="diskutil umount $1"
    if ! $cmd; then
        echo "unmount of $volume failed"
        echo "-->$cmd"
        echo "Forcing...."
        cmd="diskutil umount force $1"
        if ! $cmd; then
            echo "Cant unmount $volume"
        else
            echo "unmount of $volume successfull"
        fi
    else
        echo "unmount of $volume successfull"
    fi
}

function usage()
{
    echo "Mount specified partition w/ sshfs on a MAC OS system"
    echo ""
    echo "sshMount.sh"
    echo -e "\t-h --help"
    echo -e "\t--mount=[REMOTE_FILE_SYSTEM_HOST, ... ], a list of ssh host to mount"
    echo -e "\t--umount=[REMOTE_FILE_SYSTEM_HOST, ... ], a list of ssh host to unmount"
    echo -e "\t -U, unmount all ssh partition"
    echo " optional:"
    echo -e "\t--force, TO DO"
    echo ""
}



while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --mount)
            toMount=$VALUE
            ;;
        --vMount)
            VM_PUBLIC_IP=$VALUE
            ;;
        --vMount)
            toUnmount="VM_PUBLIC"
            ;;
        --umount)
            toUnmount=$VALUE
            ;;
        -U)
            UNMOUNTALL='UALL'
            ;;
        --user)
            ME=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done


## sshfs executable
sshfs="/usr/local/bin/sshfs"


################################################################################
## a table of ssh host adresses and mount points (volume) on local file sytem
##
################################################################################

declare -A partitionMapper
declare -A remoteMapper
partitionMapper[arwen]="//Volumes/arwen"
remoteMapper[arwen]="arwen.ibcp.fr"

partitionMapper[arwen-dev]="//Volumes/arwen-dev"
remoteMapper[arwen-dev]="arwen-dev.ibcp.fr"

partitionMapper[migale]="//Volumes/migale"
remoteMapper[migale]="migale.jouy.inra.fr"

if ! test -z $VM_PUBLIC_IP;then
    partitionMapper[IFB_VM]="//Volumes/VM_PUBLIC"
    remoteMapper[IFB_VM]=$VM_PUBLIC_IP;
    toMount="IFB_VM"
fi

# mount arguments loop
for partition in `echo $toMount | perl -ne 'foreach $p (split(",")){ print "$p\n"}'`
    do
    #echo ${partitionMapper[$partition]}
    [[ -z "${partitionMapper[$partition]}" ]] &&  {\
        echo "sshfs partition \"$partition\" does not exist";
        exit 1;
    }
    _mount ${partitionMapper[$partition]} ${remoteMapper[$partition]}
done

#umount arguments loop
for partition in `echo $toUnmount | perl -ne 'foreach $p (split(",")){ print "$p\n"}'`
    do
    [[ -z "${partitionMapper[$partition]}" ]] &&  {
        echo "sshfs partition \"$partition\" is not registred";
        exit 1;
    }
    _unmount ${partitionMapper[$partition]}
done

# exhaustive unmount
if [ ! -z $UNMOUNTALL ];
    then
    echo "unmounting all registred ssh Volumes"
    for k in "${!partitionMapper[@]}"
        do
        [[ -d ${partitionMapper[$k]} ]] && _unmount ${partitionMapper[$k]}
    done
fi

exit


