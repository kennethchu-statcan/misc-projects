
require(R6);

node <- R6::R6Class(

    classname = "node",

    public = list(

        # instantiation attributes
        guid            = NULL,
        depth           = NULL,
        type            = NULL,
        properties      = NULL,
        parent          = NULL,
        children        = NULL,
        variables       = NULL,
        rows            = NULL,
        columns         = NULL,
        initLogic       = NULL,
        displayLogic    = NULL,
        enterLogic      = NULL,
        exitLogic       = NULL,
        validationLogic = NULL,
        condition.if    = NULL,
        condition.then  = NULL,
        condition.else  = NULL,

        # derived attributes

        # methods
        initialize = function(
            guid            = NULL,
            depth           = NULL,
            type            = NULL,
            properties      = NULL,
            parent          = NULL,
            children        = NULL,
            variables       = NULL,
            rows            = NULL,
            columns         = NULL,
            initLogic       = NULL,
            displayLogic    = NULL,
            enterLogic      = NULL,
            exitLogic       = NULL,
            validationLogic = NULL,
            condition.if    = NULL,
            condition.then  = NULL,
            condition.else  = NULL
            ) {
                self$guid            <- guid;
                self$depth           <- depth;
                self$type            <- type;
                self$properties      <- properties;
                self$parent          <- parent;
                self$children        <- children;
                self$variables       <- variables;
                self$rows            <- rows;
                self$columns         <- columns;
                self$initLogic       <- initLogic;
                self$displayLogic    <- displayLogic;
                self$enterLogic      <- enterLogic;
                self$exitLogic       <- exitLogic;
                self$validationLogic <- validationLogic;
                self$condition.if    <- condition.if;
                self$condition.then  <- condition.then;
                self$condition.else  <- condition.else;
                private$node.type    <- gsub(x = self$guid, pattern = "_[A-Za-z0-9]+$", replacement = "");
                private$generate_properties();
            },

        print_node = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            if (grepl(x = self$guid, pattern = "^Conditional_")) {
                private$print_node_Conditional(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^ConditionGroup_")) {
                private$print_node_ConditionGroup(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^Condition_"     )) {
                private$print_node_Condition(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^ValueGroup_"    )) {
                private$print_node_ValueGroup(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^Value_"         )) {
                private$print_node_Value(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^Comparison_"    )) {
                private$print_node_Comparison(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^Connective_"    )) {
                private$print_node_Connective(indent = indent);
            } else if (grepl(x = self$guid, pattern = "^Action_"        )) {
                private$print_node_Action(indent = indent);
            } else {
                private$print_node_Other(indent = indent);
                }
            },

        get_attribute_IDs = function() {
            vector.output <- unique(c(
                as.vector(unlist(self$children       )),
                as.vector(unlist(self$variables      )),
                as.vector(unlist(self$rows           )),
                as.vector(unlist(self$columns        )),
                as.vector(unlist(self$initLogic      )),
                as.vector(unlist(self$displayLogic   )),
                as.vector(unlist(self$enterLogic     )),
                as.vector(unlist(self$exitLogic      )),
                as.vector(unlist(self$validationLogic)),
                as.vector(unlist(self$condition.if   )),
                as.vector(unlist(self$condition.then )),
                as.vector(unlist(self$condition.else ))
                ));
            return(vector.output);
            }

        ), # public = list()

    private = list(

        node.type = NULL,

        format.referentID            =      "[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+",
        pattern.referentID.elementID = "id = [a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+ \\([a-zA-Z0-9_ \\.]+\\)",
      # pattern.referentID.elementID = "id = [a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+ \\([a-zA-Z0-9_]+\\)",
      # pattern.referentID.elementID = "(; ){,1}id = [a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+ \\([a-zA-Z0-9_ ]+\\)",
        pattern.referentID           = "id = [a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-[a-z0-9]+ ",

        properties.list   = NULL,
        properties.vector = NULL,
        properties.string = NULL,

        guid.substitute = function(properties.string = private$properties.string) {
            match.result <- gregexpr(pattern = private$pattern.referentID.elementID, text = properties.string);
            if ( as.integer(match.result) < 0 ) {
              # return( self$guid );
                return( private$node.type );
            } else {
                output.string <- substr(x = properties.string, start = match.result, stop = -1 + as.integer(match.result) + attr(match.result[[1]],"match.length"));
                output.string <- gsub(x = output.string, pattern = private$pattern.referentID, replacement = "");
                output.string <- gsub(x = output.string, pattern = "(\\(|\\))", replacement = "");
                if ( output.string == self$guid ) {
                    output.string <- private$node.type;
                } else {
                  # output.string <- paste0(self$guid,", ",output.string);
                    output.string <- paste0(private$node.type,", ",output.string);
                    }
                return(output.string);
                }
            },

        extract_substr_by_pattern = function(text = "", pattern = "") {
            match.result <- gregexpr(pattern = pattern, text = text);
            if ( as.integer(match.result) < 0 ) {
                return("");
            } else {
                output.string <- substr(x = text, start = match.result, stop = -1 + as.integer(match.result) + attr(match.result[[1]],"match.length"));
                return(output.string);
                }
            },

        generate_properties = function() {
            if ( (!is.null(self$properties)) & length(self$properties) > 0 ) {
                private$properties.list   <- list();
                private$properties.vector <- c();
                for ( i in seq(1,length(self$properties)) ) {
                    for ( temp.key in names(self$properties[[i]]) ) {
                        temp.value  <- self$properties[[i]][[temp.key]];
                        temp.string <- paste0(temp.value,collapse=", ");
                        private$properties.list[[temp.key]] <- temp.string;
                        private$properties.vector <- c(private$properties.vector,paste0(temp.key," = ",temp.string));
                        # if ( temp.key != 'id' ) {
                        #     private$properties.vector <- c(private$properties.vector,paste0(temp.key," = ",temp.string));
                        #     }
                        }
                    }
                private$properties.string <- paste0(private$properties.vector, collapse = "; ");
                }
            },

        print_node_Conditional = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            cat("\n");
            cat(paste0(rep(indent,self$depth),collapse=""));
          # cat(paste0("(",self$guid,") "));
            cat(paste0("(",private$node.type,") "));
            if ( any(grepl(self$get_attribute_IDs(), pattern = "^ConditionGroup_")) ) {
                cat("\n");
                cat(paste0(rep(indent,1+self$depth),collapse=""));
            } else {
                cat("\n");
                cat(paste0(rep(indent,1+self$depth),collapse=""), "( NO CONDITION )", sep = "");
                }
            },

        print_node_ConditionGroup = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            if ( 'negation' %in% names(private$properties.list) ) {
                if (private$properties.list[['negation']] == 'TRUE') {
                    cat("!( ");
                } else {
                    cat("( ");
                    }
                }
            },

        print_node_Condition = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            cat("(");
            },

        print_node_ValueGroup = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {},

        print_node_Action = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            cat("\n");
            cat(paste0(rep(indent,self$depth),collapse="") );
            if ( is.null(self$properties) | length(self$properties) == 0 ) {
              # cat(paste0("(",self$guid,") "));
                cat(paste0("(",private$node.type,") "));
            } else { # if ( length(self$properties) > 0 )
                temp.string <- gsub(x = private$properties.string, pattern = private$format.referentID, replacement = "");
                temp.string <- gsub(x = temp.string, pattern = "[\\(,]", replacement = "");
                if ('setTarget' %in% names(private$properties.list)) {
                    temp.string <- gsub(x = temp.string, pattern = "\\)", replacement = " <- ");
                } else if ('gotoTarget' %in% names(private$properties.list)) {
                    temp.string <- gsub(x = temp.string, pattern = "\\)", replacement = "");
                } else if ('displayTarget' %in% names(private$properties.list)) {
                    temp.string <- gsub(x = temp.string, pattern = "\\)", replacement = "");
                    }
                temp.string <- gsub(x = temp.string, pattern = " {2,}", replacement = " ");
                cat(paste0("(",private$guid.substitute(),") : ",temp.string));
                }
            },

        print_node_Value = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            if ('datapointValue' %in% names(private$properties.list)) {
                output.string <- private$properties.list[['datapointValue']];
                output.string <- gsub(x = output.string, pattern = private$format.referentID, replacement = "");
                output.string <- gsub(x = output.string, pattern = "[ \\(\\),]",              replacement = "");
                cat(output.string);
            } else if ('numberValue' %in% names(private$properties.list)) {
                output.string <- private$properties.list[['numberValue']];
                cat(output.string);
            } else if ('specialVarValue' %in% names(private$properties.list)) {
                output.string <- private$properties.list[['specialVarValue']];
                cat(output.string);
            } else if ('stringValue' %in% names(private$properties.list)) {
                output.string <- private$properties.list[['stringValue']];
                cat(output.string);
                }
            },

        print_node_Comparison = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            if ( 'value' %in% names(private$properties.list) ) {
                output.string <- private$properties.list[['value']];
                output.string <- paste0(" ",output.string," ");
                cat(output.string);
                }
            },

        print_node_Connective = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            if ( 'value' %in% names(private$properties.list) ) {
                output.string <- private$properties.list[['value']];
                output.string <- paste0(" ",output.string," ");
                cat(output.string);
                }
            },

        print_node_Other = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            cat("\n");
            cat(paste0(rep(indent,self$depth),collapse="") );
            if ( is.null(self$properties) | length(self$properties) == 0 ) {
              # cat(paste0("(",self$guid,") "));
                cat(paste0("(",private$node.type,") "));
            } else { # if ( length(self$properties) > 0 )
              # temp.string <- gsub(x = private$properties.string, pattern = paste0("[; ]{,1}",private$pattern.referentID.elementID), replacement = "");
                temp.string <- gsub(x = private$properties.string, pattern = paste0(private$pattern.referentID.elementID,"(; )*"), replacement = "");
                cat(paste0("(",private$guid.substitute(),") : ",temp.string));
                }
            }

        ) # private = list()

    );
