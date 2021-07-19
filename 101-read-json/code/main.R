
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
    "getData.R",
    "getListOfNodes.R",
    "examineData.R",
    "node.R",
    "printListOfNodes.R"
    );

for ( code.file in code.files ) {
    source(file.path(code.directory,code.file));
    }

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
set.seed(7654321);

data.snapshot <- "2021-05-20.01";

list.oidexit <- getData(
    input.file = file.path(data.directory,data.snapshot,"OIDEXIT_OID_Exit-Prod-V4-0-0_1-0-0_spec.json")
    );

# examineData(list.input = list.oidexit);

results.getListOfNodes <- getListOfNodes(list.input = list.oidexit);

DF.nodes   <- results.getListOfNodes[[  'DF.nodes']];
list.nodes <- results.getListOfNodes[['list.nodes']];

write.csv(file = "nodes-DF.csv",     x      =   DF.nodes);
saveRDS(  file = "nodes-DF.RData",   object =   DF.nodes);
saveRDS(  file = "nodes-list.RData", object = list.nodes);

print( list.nodes[['Root']] );

print( list.nodes[['Root']]$type );

print( list.nodes[['Root']]$properties );

print( list.nodes[['Root']]$parent );

print( list.nodes[['Root']]$children );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
printListOfNodes(list.nodes = list.nodes);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

##################################################
print( warnings() );

print( getOption('repos') );

print( .libPaths() );

print( sessionInfo() );

print( format(Sys.time(),"%Y-%m-%d %T %Z") );

stop.proc.time <- proc.time();
print( stop.proc.time - start.proc.time );
