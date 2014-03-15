#
#   puppet manifest entry point
#
#   $ sudo puppet apply --modulepath=/path/to/modules --debug --verbose site.pp
#

import 'default'


node 'mumumu-U31F' {
    include ubuntu::desktop
    include ubuntu::user
}
