
require(R6);

node <- R6::R6Class(

    classname = "node",

    public = list(

        # instantiation attributes
        guid           = NULL,
        depth          = NULL,
        type           = NULL,
        properties     = NULL,
        parent         = NULL,
        children       = NULL,
        rows           = NULL,
        columns        = NULL,
        displayLogic   = NULL,
        enterLogic     = NULL,
        condition.if   = NULL,
        condition.then = NULL,

        # derived attributes

        # methods
        initialize = function(
            guid           = NULL,
            depth          = NULL,
            type           = NULL,
            properties     = NULL,
            parent         = NULL,
            children       = NULL,
            rows           = NULL,
            columns        = NULL,
            displayLogic   = NULL,
            enterLogic     = NULL,
            condition.if   = NULL,
            condition.then = NULL
            ) {
                self$guid           <- guid;
                self$depth          <- depth;
                self$type           <- type;
                self$properties     <- properties;
                self$parent         <- parent;
                self$children       <- children;
                self$rows           <- rows;
                self$columns        <- columns;
                self$displayLogic   <- displayLogic;
                self$enterLogic     <- enterLogic;
                self$condition.if   <- condition.if;
                self$condition.then <- condition.then;
            },

        print_node = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            cat("\n");
            cat(paste0(rep(indent,self$depth),collapse="") );
            if ( is.null(self$properties) | length(self$properties) == 0 ) {
                cat(paste0("(",self$guid,") "));
            } else { # if ( length(self$properties) > 0 )
                properties.vector <- c();
                for ( i in seq(1,length(self$properties)) ) {
                    for ( temp.key in names(self$properties[[i]]) ) {
                        temp.value        <- self$properties[[i]][[temp.key]]
                        temp.string       <- paste0(temp.key," = ",paste0(temp.value,collapse=", "));
                        properties.vector <- c(properties.vector,temp.string);
                        }
                    }
                # cat(paste0("(",self$guid,") "));
                properties.string <- paste0(properties.vector, collapse = "; ");
                cat(paste0("(",private$guid.substitute(properties.string = properties.string),") "));
                cat(": ");
                properties.string <- gsub(x = properties.string, pattern = paste0(private$pattern.referentID.elementID,"[; ]{,2}"), replacement = "");
                cat(properties.string);
                }
            },

        get_offspring_IDs = function() {
            vector.output <- unique(c(
                as.vector(unlist(self$children      )),
                as.vector(unlist(self$rows          )),
                as.vector(unlist(self$columns       )),
                as.vector(unlist(self$displayLogic  )),
                as.vector(unlist(self$enterLogic    )),
                as.vector(unlist(self$condition.if  )),
                as.vector(unlist(self$condition.then))
                ));
            return(vector.output);
            }

        ), # public = list()

    private = list(

        pattern.referentID.elementID = "id = [a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+ \\([a-zA-Z0-9_]+\\)",
        pattern.referentID           = "id = [a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+ ",

        guid.substitute = function(properties.string = "") {
            match.result <- gregexpr(pattern = private$pattern.referentID.elementID, text = properties.string);
            if ( as.integer(match.result) < 0 ) {
                return( self$guid )
            } else {
                output.string <- substr(x = properties.string, start = match.result, stop = -1 + as.integer(match.result) + attr(match.result[[1]],"match.length"));
                output.string <- gsub(x = output.string, pattern = private$pattern.referentID, replacement = "");
                output.string <- gsub(x = output.string, pattern = "(\\(|\\))", replacement = "");
                if ( output.string != self$guid ) {
                    output.string <- paste0(self$guid,", ",output.string);
                    }
                return(output.string);
                }
            }

        ) # private = list()

    );
