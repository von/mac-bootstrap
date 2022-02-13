#!/bin/sh
#
# Bootstrap a new system.
#
# Intended for OSX and untested.
#
######################################################################

echo "Checking for XCode command-line tools..."
xcode-select --install 2>&1 | grep "already installed" > /dev/null
if test $? -ne 0 ; then
  # This will launch a GUI to install XCode CLI if needed
  echo "Exiting to allow XCode CLI installation."
  exit 2
fi
# This is my best attempt at detecting if I need to appove the license.
xcodebuild -list >& /dev/null
if test $? -eq 69 ; then
  echo "Approving XCode license"
  sudo -n xcodebuild -license accept || exit 1
fi

######################################################################

echo "Checking for homebrew..."
command -v brew >/dev/null 2>&1
if test $? -ne 0 ; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

for prefix in /usr/local /opt/homebrew ; do
  test -e ${prefix}/bin/brew && eval $(${prefix}/bin/brew shellenv)
done

brew install git
brew install myrepos

######################################################################

echo "Success."
exit 0
