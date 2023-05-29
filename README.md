# dbt examples
Repository shows different use cases for dbt tool

## Environment
* Originally I tried to use the image `xemuliam/dbt` but it turned out it is a few months old and contains only dbt 1.3.
* Therefore I cloned repository https://github.com/dbt-labs/dbt-core which contains latest dbt code and also Dockerfile to build image.
* For usage in this repository I copied their Dockerfile and used it in my main Makefile.
*

### Notes

usage: dbt [-h] [--version] [-r RECORD_TIMING_INFO] [-d] [--log-format {text,json,default}] [--no-write-json] [--use-colors | --no-use-colors] [--printer-width PRINTER_WIDTH]
           [--warn-error] [--no-version-check] [--partial-parse | --no-partial-parse] [--use-experimental-parser] [--no-static-parser] [--profiles-dir PROFILES_DIR]
           [--no-anonymous-usage-stats] [-x] [--event-buffer-size EVENT_BUFFER_SIZE] [-q] [--no-print] [--cache-selected-only | --no-cache-selected-only]
           {docs,source,init,clean,debug,deps,list,ls,build,snapshot,run,compile,parse,test,seed,run-operation} ...

An ELT tool for managing your SQL transformations and data models. For more documentation on these commands, visit: docs.getdbt.com

options:
  -h, --help            show this help message and exit
  --version             Show version information
  -r RECORD_TIMING_INFO, --record-timing-info RECORD_TIMING_INFO
                        When this option is passed, dbt will output low-level timing stats to the specified file. Example: `--record-timing-info output.profile`
  -d, --debug           Display debug logging during dbt execution. Useful for debugging and making bug reports.
  --log-format {text,json,default}
                        Specify the log format, overriding the command's default.
  --no-write-json       If set, skip writing the manifest and run_results.json files to disk
  --use-colors          Colorize the output DBT prints to the terminal. Output is colorized by default and may also be set in a profile or at the command line. Mutually exclusive
                        with --no-use-colors
  --no-use-colors       Do not colorize the output DBT prints to the terminal. Output is colorized by default and may also be set in a profile or at the command line. Mutually
                        exclusive with --use-colors
  --printer-width PRINTER_WIDTH
                        Sets the width of terminal output
  --warn-error          If dbt would normally warn, instead raise an exception. Examples include --models that selects nothing, deprecations, configurations with no associated
                        models, invalid test configurations, and missing sources/refs in tests.
  --no-version-check    If set, skip ensuring dbt's version matches the one specified in the dbt_project.yml file ('require-dbt-version')
  --partial-parse       Allow for partial parsing by looking for and writing to a pickle file in the target directory. This overrides the user configuration file.
  --no-partial-parse    Disallow partial parsing. This overrides the user configuration file.
  --use-experimental-parser
                        Enables experimental parsing features.
  --no-static-parser    Disables the static parser.
  --profiles-dir PROFILES_DIR
                        Which directory to look in for the profiles.yml file. If not set, dbt will look in the current working directory first, then HOME/.dbt/
  --no-anonymous-usage-stats
                        Do not send anonymous usage stat to dbt Labs
  -x, --fail-fast       Stop execution upon a first failure.
  --event-buffer-size EVENT_BUFFER_SIZE
                        Sets the max number of events to buffer in EVENT_HISTORY
  -q, --quiet           Suppress all non-error logging to stdout. Does not affect {{ print() }} macro calls.
  --no-print            Suppress all {{ print() }} macro calls.
  --cache-selected-only
                        Pre cache database objects relevant to selected resource only.
  --no-cache-selected-only
                        Pre cache all database objects related to the project.

Available sub-commands:
  {docs,source,init,clean,debug,deps,list,ls,build,snapshot,run,compile,parse,test,seed,run-operation}
    docs                Generate or serve the documentation website for your project.
    source              Manage your project's sources
    init                Initialize a new DBT project.
    clean               Delete all folders in the clean-targets list (usually the dbt_packages and target directories.)
    debug               Show some helpful information about dbt for debugging. Not to be confused with the --debug option which increases verbosity.
    deps                Pull the most recent version of the dependencies listed in packages.yml
    list (ls)           List the resources in your project
    build               Run all Seeds, Models, Snapshots, and tests in DAG order
    snapshot            Execute snapshots defined in your project
    run                 Compile SQL and execute against the current target database.
    compile             Generates executable SQL from source, model, test, and analysis files. Compiled SQL files are written to the target/ directory.
    parse               Parses the project and provides information on performance
    test                Runs tests on data in deployed models. Run this after `dbt run`
    seed                Load data from csv files into your data warehouse.
    run-operation       Run the named macro with any supplied arguments.

Specify one of these sub-commands and you can find more help from there.
