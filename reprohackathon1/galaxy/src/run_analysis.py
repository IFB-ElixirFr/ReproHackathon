from bioblend.galaxy import GalaxyInstance

configfile: "config.yaml"


def get_hist_id(hist_name):
    '''
    Check if an history exist and return its id if it's exist
    '''
    hist = ''
    for history in histories:
        if history["name"] == hist_name:
            hist = history['id']
    return hist


def get_tool_id(tool_name):
    '''
    Retrieve the id of a tool
    '''
    tool_id = ''
    for tool in tools:
        if tool["name"] == tool_name:
            tool_id = tool["id"]
    return tool_id


def get_library_id(library_name):
    '''
    '''
    library_id = ''
    for library in libraries:
        if library["name"] == library_name:
            library_id = library["id"]
    return library_id


def get_workflow_id(workflow_name):
    '''
    '''
    wf_id = ''
    for workflow in workflows:
        if workflow["name"] == workflow_name:
            wf_id = workflow["id"]
    return wf_id


# Connect to Galaxy and retrieve the history
gi = GalaxyInstance(config["galaxy_url"], config["api_key"])
# Get tools in the Galaxy instance
tools = gi.tools.get_tools()
# Get the data librairies in the Galaxy instance
libraries = gi.libraries.get_libraries()
lib_id = get_library_id("Training Data")
assert lib_id != ''
lib_content = gi.libraries.show_library(lib_id, contents=True)
# Get workflows
workflows = gi.workflows.get_workflows()
# Create an history for the data library data
histories = gi.histories.get_histories()


rule all:
    input:
        "tmp/run_differential_analysis"


rule prepare_ref_genome:
    '''
    Prepare the reference genome: merge the chromosome files and prepare the
    GTF file for DEXSeq
    '''
    run:
        hist = gi.histories.create_history("Reference genomes")["id"]
        assert hist != ''
        # Import the data from the data library
        for dataset in lib_content:
            if dataset['name'].find("chr") != -1:
                gi.histories.upload_dataset_from_library(hist, dataset['id'])
            if dataset['name'].find("gtf") != -1:
                gi.histories.upload_dataset_from_library(hist, dataset['id'])
        # Retrieve the dataset to merge
        datamap = dict()
        datamap["inputs"] = []
        for dataset in gi.histories.show_matching_datasets(hist):
            if dataset['name'].find("chr") != -1:
                datamap["inputs"].append({'src':'hda', 'id': dataset["id"]})
        # Combine the chromosome files together
        tool_id = get_tool_id("Concatenate datasets")
        assert tool_id != ''
        info = gi.tools.run_tool(hist, tool_id, datamap)
        # Retrieve the GTF file and prepare the input
        datamap = {
            "mode|mode_select": "prepare",
            "mode|aggregate": "yes",
            "mode|gtffile": []}
        for dataset in gi.histories.show_matching_datasets(hist):
            if dataset['name'].find("gtf") != -1:
                datamap["mode|gtffile"].append(
                    {'src':'hda', 'id': dataset["id"]})
        # Prepare the GTF for DEXSeq
        tool_id = get_tool_id("DEXSeq-Count")
        assert tool_id != ''
        info = gi.tools.run_tool(hist, tool_id, datamap)


rule download_input_data:
    '''
    Download input data
    '''
    run:
        # Download samples
        # Create the history
        sample_hist = gi.histories.create_history("Samples data")["id"]
        # Add a file with the sample ids
        sample_ids = "\n".join(config["data"]["mutated_patients"])
        sample_ids += "\n"
        sample_ids += "\n".join(config["data"]["non_mutated_patients"])
        sample_id_file = gi.tools.paste_content(sample_ids, sample_hist)
        sample_id_file_id = sample_id_file['outputs'][0]['id']
        # Get the download sample workflow id
        wf_id = get_workflow_id("download_samples")
        assert wf_id != ''
        # Get id of workflow input
        input_ids = gi.workflows.get_workflow_inputs(wf_id, "Samples")
        assert len(input_ids) == 1
        input_id = input_ids[0]
        # Configure and launch the workflow
        inputs = {
            input_id: {'id': sample_id_file_id, 'src': 'hda'}}
        gi.workflows.invoke_workflow(
            wf_id,
            inputs=inputs,
            history_id=sample_hist)


rule extract_sample_count_tables:
    '''
    Launch workflow to extract the count tables for each sample
    '''
    run:        
        # Get the reference genome dataset id
        ref_hist = gi.histories.get_hist_id("Reference genomes")
        assert ref_hist != ''
        ref_genome_id = ""
        ref_annotation_id = ""
        dexseq_annotation_id = ""
        assert ref_hist != ''
        for dataset in gi.histories.show_matching_datasets(ref_hist):
            if dataset['name'].find("Concatenate") == -1:
                ref_genome_id = dataset["id"]
            if dataset['name'].find("gtf") == -1:
                ref_annotation_id = dataset["id"]
            if dataset['name'].find("DEXSeq prepare") == -1:
                dexseq_annotation_id = dataset["id"]
        assert ref_genome_id != ""
        assert ref_annotation_id != ""
        assert dexseq_annotation_id != ""
        # Get the history
        sample_hist = gi.histories.get_hist_id("Samples")
        assert sample_hist != -1
        # Get workflow id
        wf_id = get_workflow_id("sample_analysis")["id"]
        assert wf_id != -1
        # Get the input ids inside the workflow
        input_ids = gi.workflows.get_workflow_inputs(
            wf_id,
            "Reference Genome")
        assert len(input_ids) == 1
        ref_genome_input_id = input_ids[0]
        input_ids = gi.workflows.get_workflow_inputs(
            wf_id,
            "Reference Annotation")
        assert len(input_ids) == 1
        ref_annotation_input_id = input_ids[0]
        input_ids = gi.workflows.get_workflow_inputs(
            wf_id,
            "DEXSeq prepared annotation")
        assert len(input_ids) == 1
        dexseq_input_id = input_ids[0]
        input_ids = gi.workflows.get_workflow_inputs(
            wf_id,
            "Sample")
        assert len(input_ids) == 1
        sample_input_id = input_ids[0]
        # Launch the workflow for each sample
        for dataset in gi.histories.show_matching_datasets(sample_hist):
            # Parse the dataset collection
            # Extract the sample name (name in the dataset in the collection)
            sample_name = "" 
            # Create a new history for the sample
            input_hist = gi.histories.create_history(sample_name)["id"]
            # Launch the workflow
            inputs = {
                ref_genome_input_id: {'id': ref_genome_id, 'src': 'hda'},
                ref_annotation_input_id: {
                    'id': ref_annotation_id,
                    'src': 'hda'},
                dexseq_input_id: {
                    'id': dexseq_annotation_id,
                    'src': 'hda'},
                sample_input_id: {'id': dataset['id'], 'src': 'hda'}}
            gi.workflows.invoke_workflow(
                wf_id,
                inputs=inputs,
                history_name=sample_id)            


rule run_differential_analysis:
    '''
    Launch workflow to run the differential analysis
    '''
    run:
        # Get workflow id
        wf_id = get_workflow_id("differential_analysis")["id"]
        inputs = {}
        # Retrieve the histories for every samples
        for hist in gi.histories.get_histories():
            if not hist['name'].startswith("SRR"):
                continue
            sample_name = hist['name']
            inputs.setdefault(sample_name, {})
            # Retrieve the count table in the history and add it as input for
            # the workflow
            for dataset in gi.histories.show_matching_datasets(hist["id"]):
                if not dataset['name'].find("count") != 0:
                    continue
                inputs[sample_name]['id'] = dataset['name']
                inputs[sample_name]['src'] = 'hda'
        # Launch the workflow
        gi.workflows.invoke_workflow(
            wf_id,
            inputs=inputs,
            history_name="Differential analysis")
