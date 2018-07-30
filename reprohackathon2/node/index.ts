import utils = require('util');
import program = require('commander');
import  glob = require("glob");

import {logger, setLogLevel} from './logger';

import jobManager = require('ms-jobmanager');
import {map, forEach} from 'taskfunctional';

import fastTree = require('fast-tree-task');
import raxml = require('@glaunay/raxml-task');
import iqtree = require('@glaunay/iqtree-task');
import gotree = require('gotree-task');
 
// Execute three phylogenetic tree reconstruction softwares on a pool of genes alignments
// Using one of the software results as the gold-standard
// Compute foreach method their number of matches with the gold. 

program
  .version('0.1.0')
  .option('-i, --input [dirPath]', 'alignments folder')
  .option('-o, --ouput [filePath]', 'results fileName', "reproPhylo.out")
  .option('-v, --verbosity [logLevel]', 'Set log level', setLogLevel, 'info')
.parse(process.argv)

if (!program.input)
    throw ('Please provide and input folder of *.aln files');

let patt:string = program.input + "/*.aln";
let aliFiles:string[] = glob.sync(patt);

logger.info(`Input files(${patt})\n${aliFiles}`);



function display(d) {
    logger.info(`Chain joined OUTPUT:\n${ utils.format(d) }`);
}

jobManager.start({ "TCPip": "localhost", "port": "2323" })
.on("ready", () => {
    let myManagement = {
        'jobManager' : jobManager,
        'jobProfile' : 'dummy'
    }

    // Setting task input(s)    
// Assign each alignment file to a canonical "inputF" key
    let inputs = aliFiles.map((fName) => { return  {'inputF' : fName}; });
    logger.debug(`${utils.format(inputs)}`);
// Create the list of tasks, raxml will be gold
    let myTasks = [fastTree.Task, raxml.Task, iqtree.Task];
// Create the corresponding tuples accumulator for results
let results:[string, number][] = [ ["fast tree", 0 ], ["raxml" , 0], ["iqTree", 0] ]; 
   

// Loop over all input alignments
forEach( inputs, (i) => map(myManagement, i, myTasks) )
    .join( (allRes) => { // At completion
   
    
    // Prepare inputs for following goTree assessment stage
    // For each gene aln file we get a collection of best tree per software  
        let varTree:any[] = allRes.map((geneRes) => {
            let refTree = geneRes[1]; // We consider raxml tree as gold
        // just changing keys to be passed as input
            return geneRes.map((oneTaskRes) => { return { 'treeOne' : oneTaskRes['out'], 'treeTwo' : refTree['out'] }; });
        });
    
    // Now that goTree inputs are all set
    // Foreach gene-based collection of predicted trees  
    // map the goTree task onto the collection
    forEach( varTree, (geneCollectionTrees)=> map(myManagement, geneCollectionTrees, gotree.Task) )
    // Reduce the foreach results
    // By looping over each map results 
    // Here each results is a list of 3 goTree calls
        .reduce( (acc, geneAssessment, index)=>{
            let c_acc = acc ? acc : results;
            geneAssessment.forEach((methodScore, methodIndex)=> {
                logger.debug(`goTree output value:${utils.format(methodScore)}`);
                if (methodScore === 'tree identical 0 true ')
                    c_acc[methodIndex][1] += 1;
            });
            return c_acc;
        }).then((results) => { 
            logger.info(`Methods success counts on ${aliFiles.length} experiments:\n${utils.format(results)}`);
    });
    })
});