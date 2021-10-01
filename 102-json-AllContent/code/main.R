
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);

print( data.directory );
print( code.directory );
print( output.directory );

print( format(Sys.time(),"%Y-%m-%d %T %Z") );

start.proc.time <- proc.time();

# set working directory to output directory
setwd( output.directory );

##################################################
# source supporting R code
code.files <- c(
    "EQtree.R",
    "getData.R",
    "getElementToLocalization.R",
    "getListOfNodes.R",
    "getReferenceIDToElementID.R",
    "node.R",
    "printListOfNodes.R",
    "tabularizeData.R"
    );

for ( code.file in code.files ) {
    source(file.path(code.directory,code.file));
    }

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(7654321);

list.oidexit <- list(
    data.snapshot = "2021-05-20.01",
    file.json     = "OIDEXIT_OID_Exit-Prod-V4-0-0_1-0-0_spec.json",
    file.output   = "EQtree-oidexit.txt",
    dir.output    = "EQtree-oidexit"
    );

list.flow.extraction <- list(
    data.snapshot = "2021-09-23.01",
    file.json     = "Flow-Extraction_V1.json",
    file.output   = "EQtree-flow-extraction.txt",
    dir.output    = "EQtree-flow-extraction"
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
list.of.lists <- list(
    list.oidexit,
    list.flow.extraction
    );

for ( i in seq(1,length(list.of.lists)) ) {

    list.temp     <- list.of.lists[[i]];
    data.snapshot <- list.temp[['data.snapshot']];
    file.json     <- list.temp[['file.json'    ]];
    file.output   <- list.temp[['file.output'  ]];
    dir.output    <- list.temp[['dir.output'   ]];

    dir.output <- normalizePath(dir.output);
    if ( !dir.exists(dir.output) ) {
        dir.create(path = dir.output, recursive = TRUE);
        }

    directory.original <- normalizePath(getwd());
    setwd(dir.output);
    Sys.sleep(5);

    EQtree(
        file.json   = file.path(data.directory,data.snapshot,file.json),
        file.output = file.output
        );

    setwd(directory.original);
    Sys.sleep(5);

    }

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

##################################################
print( warnings() );

print( getOption('repos') );

print( .libPaths() );

print( sessionInfo() );

print( format(Sys.time(),"%Y-%m-%d %T %Z") );

stop.proc.time <- proc.time();
print( stop.proc.time - start.proc.time );
