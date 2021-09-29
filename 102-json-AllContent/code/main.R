
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

data.snapshot <- "2021-09-23.01";

list.json <- getData(
    input.file = file.path(data.directory,data.snapshot,"Flow-Extraction_V1.json")
    );

list.data.frames <- tabularizeData(list.input = list.json);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
list.referenceID.to.elementID <- getReferenceIDToElementID(
    DF.nested = list.data.frames[['DF.nested']]
    );
DF.referenceID.to.elementID <- list.referenceID.to.elementID[['referenceID.to.elementID']];
DF.referentID.to.elementID  <- list.referenceID.to.elementID[[ 'referentID.to.elementID']];

write.csv(file = "DF-referenceID-to-elementID.csv",   x      = DF.referenceID.to.elementID);
saveRDS(  file = "DF-referenceID-to-elementID.RData", object = DF.referenceID.to.elementID);

write.csv(file = "DF-referentID-to-elementID.csv",   x      = DF.referentID.to.elementID);
saveRDS(  file = "DF-referentID-to-elementID.RData", object = DF.referentID.to.elementID);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.element.to.localization <- getElementToLocalization(
    DF.nested                   = list.data.frames[['DF.nested']],
    DF.referenceID.to.elementID = DF.referenceID.to.elementID,
    DF.localization             = list.data.frames[['DF.localization']],
    element.types               = c('datapointValue','displayTarget','gotoTarget','setTarget')
    );
write.csv(file = "DF-element-to-location.csv",   x      = DF.element.to.localization);
saveRDS(  file = "DF-element-to-location.RData", object = DF.element.to.localization);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.getListOfNodes <- getListOfNodes(
    list.input                  = list.json,
    DF.localization             = list.data.frames[['DF.localization']],
    DF.element.to.localization  = DF.element.to.localization,
    DF.referenceID.to.elementID = DF.referenceID.to.elementID,
    DF.referentID.to.elementID  = DF.referentID.to.elementID
    );

DF.nodes   <- results.getListOfNodes[[  'DF.nodes']];
list.nodes <- results.getListOfNodes[['list.nodes']];

write.csv(file = "DF-nodes.csv",     x      =   DF.nodes);
saveRDS(  file = "DF-nodes.RData",   object =   DF.nodes);
saveRDS(  file = "list-nodes.RData", object = list.nodes);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
printListOfNodes(
    list.nodes = list.nodes,
    txt.output = 'nodes.txt'
    );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

##################################################
print( warnings() );

print( getOption('repos') );

print( .libPaths() );

print( sessionInfo() );

print( format(Sys.time(),"%Y-%m-%d %T %Z") );

stop.proc.time <- proc.time();
print( stop.proc.time - start.proc.time );
