%define _sourcedir %(pwd)
%define version %(cat version)

Name: qubes-thunar-actions
Version: %{version}
Release: 1%{?dist}
Url: https://www.qubes-os.org
Summary: Qubes tools in Thunar
License: Apache License 2.0
Group: Qubes

BuildArch: noarch
Requires: Thunar

%description
Implement Qubes tools in Thunar as custom actions.

%prep
rm -f %{name}-%{version}
ln -sf . %{name}-%{version}
%setup -T -D

%build

%install
mkdir -p $RPM_BUILD_ROOT/usr/lib/qubes/
cp -r %{_sourcedir}/{qvm-actions.sh,uca_qubes.xml} $RPM_BUILD_ROOT/usr/lib/qubes/

%post
if [ "$1" = 1 ]; then
  if [ -f /etc/xdg/Thunar/uca.xml ] ; then
    cp -p /etc/xdg/Thunar/uca.xml{,.bak}
    sed -i '$e cat /usr/lib/qubes/uca_qubes.xml' /etc/xdg/Thunar/uca.xml
  fi
  if [ -f /home/user/.config/Thunar/uca.xml ] ; then
    cp -p /home/user/.config/Thunar/uca.xml{,.bak}
    sed -i '$e cat /usr/lib/qubes/uca_qubes.xml' /home/user/.config/Thunar/uca.xml
  fi
fi

%postun
if [ "$1" = 0 ]; then
  if [ -f /etc/xdg/Thunar/uca.xml ] ; then
    mv /etc/xdg/Thunar/uca.xml{,.uninstall}
    mv /etc/xdg/Thunar/uca.xml{.bak,}
  fi
  if [ -f /home/user/.config/Thunar/uca.xml ] ; then
    mv /home/user/.config/Thunar/uca.xml{,.uninstall}
    mv /home/user/.config/Thunar/uca.xml{.bak,}
  fi
fi

%files
%defattr(-,root,root,-)
/usr/lib/qubes/qvm-actions.sh
/usr/lib/qubes/uca_qubes.xml

%changelog
