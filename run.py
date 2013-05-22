#!/usr/bin/env python

'''
.. program:: run.py


Usage
-----

``run.py [options] log [log ...]``

.. cmdoption:: log

  The log file to be parsed and converted to base station parameters.

Options
-------

.. cmdoption:: -v, --verbose

  Give more output.

.. cmdoption:: -c, --clean

  Remove all auto-generated files.

.. cmdoption:: -u, --update

  Install and update all required packages specified in `requirements.txt`_
  file.
  Uses `pip`_.

.. cmdoption:: -d, --doc

  Generate all `Sphinx`_ documentation.

.. cmdoption:: -p VERSION, --package=VERSION


.. cmdoption:: -t, --test

  Run all unit tests. Uses `nose`_.

.. cmdoption:: -o SCRIPT, --output=SCRIPT


'''

# Import system modules
import sys
import os
import glob
from optparse import OptionParser


def imperr(e):
  print >> sys.stderr, "ImportError: %s" % e
  print >> sys.stderr, "  Resolve by running: run.py -u"


class bcolors:
  HEADER = '\033[95m'
  OKBLUE = '\033[94m'
  OKGREEN = '\033[92m'
  WARNING = '\033[93m'
  FAIL = '\033[91m'
  ENDC = '\033[0m'


def cprint(color, *args):
  print "%s%s%s" % (color, ' '.join((str(arg) for arg in args)), bcolors.ENDC)


def safe_remove(func, path):
  vprint("- Removing %s..." % path)
  try:
    func(path)
  except Exception as e:
    print >> sys.stderr, "[ERROR] Unable to remove %s" % path
    print >> sys.stderr, "%s %s" % (type(e), e)


def make_script(out, args):
  if out == sys.stdout:
    cprint(bcolors.HEADER, "{0:*^79}".format(out.name))
  else:
    cprint(bcolors.HEADER, "{0:*^79}".format("<%s>" % out.name))

  try:
    from LookupScanner import LookupScanner
    from ScriptGenerator import ScriptGenerator
  except ImportError as e:
    return imperr(e)

  for arg in args:
    print >> out, '#' * 79
    print >> out, "# BEGIN LOG ::", arg
    lookup_scanner = LookupScanner(arg)
    obj_dict = lookup_scanner.scan()

    script_gen = ScriptGenerator()

    for key, msgs in obj_dict.items():
      print >> out, "#", key, "count =", len(msgs)
      with open(str(msgs[-1]) + '.json', 'w') as fp:
        fp.write(msgs[-1].to_json())
      script_gen.msg_obj_to_script(msgs[-1], out)
    print >> out, "# END LOG :: %s\n" % arg


def make_clean():
  cprint(bcolors.HEADER, "{0:*^79}".format('CLEAN'))
  import shutil

  lunlink = os.unlink
  lrmtree = shutil.rmtree

  cprint(bcolors.OKBLUE, "Cleaning *.json...")
  json_files = glob.glob("*.json")
  if json_files:
    for f in json_files:
      safe_remove(lunlink, f)
  else:
    cprint(bcolors.OKGREEN, "+ Nothing to be done")
  vprint()

  cprint(bcolors.OKBLUE, "Cleaning documentation...")
  doc_build_dirs = glob.glob(os.path.join('doc', 'sphinx', '*', '_build'))
  if doc_build_dirs:
    for doc_build in doc_build_dirs:
      safe_remove(lrmtree, doc_build)
  else:
    cprint(bcolors.OKGREEN, "+ Nothing to be done")
  vprint()

  cprint(bcolors.OKBLUE, "Cleaning *.pyc...")
  none = True
  for root, dirs, files in os.walk('.'):
    for f in files:
      if f.endswith('.pyc'):
        none = False
        safe_remove(lunlink, os.path.join(root, f))
  if none:
    cprint(bcolors.OKGREEN, "+ Nothing to be done")
  vprint()


def make_update():
  cprint(bcolors.HEADER, "{0:*^79}".format('UPDATE'))
  import subprocess

  cmd = ['pip', 'install', '--upgrade', '-r', 'requirements.txt']
  cprint(bcolors.OKBLUE, ' '.join(cmd))
  subprocess.call(cmd)
  vprint()


def make_test():
  cprint(bcolors.HEADER, "{0:*^79}".format('TEST'))
  try:
    import nose
  except ImportError as e:
    return imperr(e)

  argv = ['nosetests']
  nose.run(argv=argv)
  vprint()


def make_doc():
  cprint(bcolors.HEADER, "{0:*^79}".format('DOC'))
  from StringIO import StringIO
  try:
    from sphinx.application import Sphinx
  except ImportError as e:
    return imperr(e)

  def make_sphinx(docbase, buildername='html'):
    docbase = os.path.abspath(docbase)
    if not os.path.isdir(docbase):
      cprint(bcolors.WARNING, "[%s] is not a valid directory" % docbase)

    cprint(bcolors.OKBLUE, "Building %s..." % docbase[:67])
    verbose_output = StringIO()
    sphinx = Sphinx(
      srcdir=os.path.join(docbase, 'source'),
      confdir=os.path.join(docbase, 'source'),
      outdir=os.path.join(docbase, '_build', 'html'),
      doctreedir=os.path.join(docbase, '_build', 'doctrees'),
      buildername='html',
      #confoverrides=None,
      status=verbose_output,
      #warning=sys.stderr,
      #freshenv=False,
      #warningiserror=False,
      #tags=None,
      #verbosity=0,
      #parallel=0
    )
    sphinx.build(
      #force_all=False,
      #filenames=None
    )
    vprint(verbose_output.getvalue())
    verbose_output.close()

  for doc_dir in glob.iglob(os.path.join('doc', 'sphinx', '*')):
    make_sphinx(doc_dir)


def make_package(version):
  """Package output of build into tarball"""
  import tarfile

  package = "%s.tar.gz" % version
  cprint(bcolors.HEADER, "{0:*^79}".format('PACKAGE'))
  cprint(bcolors.OKBLUE, "Creating %s..." % package)

  tar = tarfile.open(package, "w:gz")

  special_files = ('requirements.txt', )
  for f in special_files:
    vprint("+ Adding %s..." % f)
    tar.add(f)

  dirs = ('.', 'classes', 'LookupTableElements', 'tests')
  for d in dirs:
    for f in glob.iglob(os.path.join(d, '*.py')):
      vprint("+ Adding %s..." % f)
      tar.add(f)

  for doc in glob.iglob(os.path.join('doc', 'sphinx', '*')):
    doc_build = os.path.join(doc, '_build', 'html')
    name = os.path.join('doc', os.path.basename(doc))
    vprint("+ Adding %s ==> %s..." % (doc_build, name))
    tar.add(doc_build, arcname=name)
  tar.close()
  vprint()


if __name__ == '__main__':
  parser = OptionParser(usage="%prog [options] log [log ...]")
  parser.add_option("-v", "--verbose", dest="verbose",
                    action="store_true", default=False,
                    help="give more output")
  parser.add_option("-c", "--clean", dest="clean",
                    action="store_true", default=False,
                    help="remove all auto-generated files")
  parser.add_option("-u", "--update", dest="update",
                    action="store_true", default=False,
                    help="install and update all required packages (pip)")
  parser.add_option("-d", "--doc", dest="documentation",
                    action="store_true", default=False,
                    help="generate all documentation (Sphinx)")
  parser.add_option("-p", "--package", dest="version", metavar="VERSION",
                    help="create a tarball with name \
\"VERSION.tar.gz\"")
  parser.add_option("-t", "--test", dest="test",
                    action="store_true", default=False,
                    help="run all unit tests (nose)")
  parser.add_option("-o", "--output", dest="output", metavar="SCRIPT",
                    help="write config script to SCRIPT")

  (options, args) = parser.parse_args()
  option_count = 0

  if options.verbose:
    def vprint(*args):
      for arg in args:
        print arg,
      print
  else:
    vprint = lambda *a: None

  if options.clean:
    option_count += 1
    make_clean()

  if options.update:
    option_count += 1
    make_update()

  if options.documentation:
    option_count += 1
    make_doc()

  if options.version:
    if not options.documentation:
      make_doc()
    option_count += 1
    make_package(options.version)

  if options.test:
    option_count += 1
    make_test()

  if args:
    option_count += 1
    if options.output:
      with open(options.output, 'w') as out:
        make_script(out, args)
    else:
      make_script(sys.stdout, args)

  if not option_count:
    parser.print_help()
