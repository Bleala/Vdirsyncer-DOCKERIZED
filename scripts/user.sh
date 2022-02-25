#!/bin/sh

# Only execute if USER changed
#if [[ $USER -ne $OLD_USER ]]
#then
#    # Change Username and Groupname
#    usermod -l $USER vdirsyncer
#    groupmod -n $USER vdirsyncer
#fi

(
# Only execute if UID or GID changed
if [[ $UID -ne $OLD_UID ]] || [[ $GID -ne $OLD_GID ]]
then
    # Change permissions
    sudo /bin/sh -c "chown -R $UID:$GID /scripts"
    sudo /bin/sh -c "chown -R $UID:$GID /vdirsyncer"
    sudo /bin/sh -c "chown -R $UID:$GID /examples"
    sudo /bin/sh -c "chmod -R 777 /vdirsyncer/logs/vdirsyncer.log"
fi
)

# Start Sub Shell
#(
# Only execute if GID changed
#if [[ $GID -ne $OLD_GID ]]
#then
    # Change GID
#    groupmod -g $GID $USER
#fi
# End Sub Shell
#)

# Start Sub Shell
(

# Only execute if UID changed
    if [[ $UID -ne $OLD_UID ]]
    then
        # Change UID
        usermod -u $UID vdirsyncer
    fi
# End Sub Shell

)
