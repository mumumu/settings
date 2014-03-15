#
#   puppet manifest entry point
#
#   $ puppet apply --modulepath=/path/to/modules site.pp
#

import 'default'


node 'mumumu-U31F' {
    include ubuntu::desktop
    include ubuntu::user
}
