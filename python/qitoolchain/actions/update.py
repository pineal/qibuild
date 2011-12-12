## Copyright (C) 2011 Aldebaran Robotics

""" Update a toolchain from a feed.

If no toolchain is given, use the current one.
If no feed is given, use the feed used
to initialize the given toolchain

"""

import logging

import qibuild
import qitoolchain

LOGGER = logging.getLogger(__name__)


def configure_parser(parser):
    """ Configure parser for this action """
    qibuild.worktree.work_tree_parser(parser)
    parser.add_argument("name", nargs="?", metavar="NAME",
        help="Name of the toolchain. Defaults to the current toolchain")
    parser.add_argument("feed", metavar="TOOLCHAIN_FEED",
        help="Optional: path to the toolchain configuration file.\n"
             "If not given, the toolchain will be empty.\n"
             "May be a local file or an url",
        nargs="?")
    parser.add_argument("--dry-run", action="store_true",
        help="Print what would be done")

def do(args):
    """Main entry point

    """
    feed = args.feed
    tc_name = args.name
    dry_run = args.dry_run

    toc = None
    try:
        toc = qibuild.toc.toc_open(args.work_tree)
    except qibuild.toc.TocException:
        pass

    if not tc_name:
        if toc:
            tc_name = toc.active_config
        if not tc_name:
            mess  = "Could not find which toolchain to update\n"
            mess += "Please specify a toolchain name from command line\n"
            mess += "Or edit your qibuild.cfg to set a default config\n"
            raise Exception(mess)

    known_tc_names = qitoolchain.toolchain.get_tc_names()
    if not tc_name in known_tc_names:
        mess  = "No such toolchain: '%s'\n" % tc_name
        mess += "Known toolchains are: %s" % known_tc_names
        raise Exception(mess)

    if not feed:
        feed = qitoolchain.toolchain.get_tc_feed(tc_name)
        if not feed:
            mess  = "Could not find feed for toolchain %s\n" % tc_name
            mess += "Pleas check configuration or specifiy a feed on the command line\n"
            raise Exception(mess)

    toolchain = qitoolchain.Toolchain(tc_name)
    toolchain.parse_feed(feed, dry_run=dry_run)
