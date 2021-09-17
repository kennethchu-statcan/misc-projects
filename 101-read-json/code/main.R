
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
    "getGuidToElementID.R",
    "getReferenceIDToReferentID.R",
    "getReferentIDToElementID.R",
    "getListOfNodes.R",
    "getItemToElementID.R",
    "getItemToLocalization.R",
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

list.misc <- examineData(list.input = list.oidexit);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.referenceID.to.referentID <- getReferenceIDToReferentID(
    DF.nested = list.misc[['DF.nested']]
    );
write.csv(file = "DF-referenceID-to-referentID.csv",   x      = DF.referenceID.to.referentID);
saveRDS(  file = "DF-referenceID-to-referentID.RData", object = DF.referenceID.to.referentID);

DF.referentID.to.elementID <- getReferentIDToElementID(
    DF.nested = list.misc[['DF.nested']]
    );
write.csv(file = "DF-referentID-to-elementIDs.csv",   x      = DF.referentID.to.elementID);
saveRDS(  file = "DF-referentID-to-elementIDs.RData", object = DF.referentID.to.elementID);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.item.to.localization <- getItemToLocalization(
    DF.nested                    = list.misc[['DF.nested']],
    DF.referenceID.to.referentID = DF.referenceID.to.referentID,
    DF.localization              = list.misc[['DF.localization']]
    );
write.csv(file = "DF-item-to-location.csv",   x      = DF.item.to.localization);
saveRDS(  file = "DF-item-to-location.RData", object = DF.item.to.localization);

DF.item.to.elementID <- getItemToElementID(
    DF.nested                    = list.misc[['DF.nested']],
    DF.referenceID.to.referentID = DF.referenceID.to.referentID,
    DF.referentID.to.elementID   = DF.referentID.to.elementID
    );
write.csv(file = "DF-item-to-elementID.csv",   x      = DF.item.to.elementID);
saveRDS(  file = "DF-item-to-elementID.RData", object = DF.item.to.elementID);

DF.guid.to.elementID <- getGuidToElementID(
    DF.nested                  = list.misc[['DF.nested']],
    DF.referentID.to.elementID = DF.referentID.to.elementID
    );
write.csv(file = "DF-guid-to-elementID.csv",   x      = DF.guid.to.elementID);
saveRDS(  file = "DF-guid-to-elementID.RData", object = DF.guid.to.elementID);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
results.getListOfNodes <- getListOfNodes(
    list.input                 = list.oidexit,
    DF.localization            = list.misc[['DF.localization']],
    DF.item.to.localization    = DF.item.to.localization,
    DF.referentID.to.elementID = DF.referentID.to.elementID,
    DF.item.to.elementID       = DF.item.to.elementID
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
