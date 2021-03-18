#!/bin/sh
#
# pbs-nag-buster.sh (v01) https://github.com/hnnweb/pve-nag-buster
#
# Removes Proxmox BS 1.x+ license nags automatically after updates
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

NAGTOKEN="data.status.toLowerCase() !== 'active'"
NAGFILE="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
SCRIPT="$(basename $0)"

# disable license nag: https://johnscs.com/remove-proxmox51-subscription-notice/

if grep -qs "$NAGTOKEN" "$NAGFILE" > /dev/null 2>&1; then
  echo "$SCRIPT: Removing Nag ..."
  sed -i.orig "s/$NAGTOKEN/data.status !== ''/g" "$NAGFILE"
  systemctl restart pveproxy.service
fi

# disable paid repo list

PAID_BASE="/etc/apt/sources.list.d/pbs-enterprise"

if [ -f "$PAID_BASE.list" ]; then
  echo "$SCRIPT: Disabling PBS paid repo list ..."
  mv -f "$PAID_BASE.list" "$PAID_BASE.disabled"
fi
