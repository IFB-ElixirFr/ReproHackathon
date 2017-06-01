from bioblend.galaxy import GalaxyInstance

configfile: "config.yaml"


def check_hist(hist_name):
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


def get_librairy_id(library_name):
    '''
    '''
    library_id = ''
    for library in librairies:
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
librairies = gi.libraries.get_libraries()
# Get workflows
workflows = gi.workflows.get_workflows()

rule all:
    input:
        "tmp/run_differential_analysis"


rule import_data_library_data:
    '''
    Import the data in the data library into an history
    '''
    output:
        temp("tmp/import_data_library_data")
    run:
        # Create an history for the data library data
        input_hist = gi.histories.create_history(
            config["hist"]["ref_genome_prep"])["id"]
        # Get the id of the reference genome
        lib_id = get_librairy_id("Training data")
        gi.upload_dataset_from_library(input_hist, lib_id)


rule prepare_ref_genome:
    '''
    Prepare the reference genome
    '''
    input:
        "tmp/import_data_library_data"
    output:
        temp("tmp/prepare_ref_genome")
    run:
        hist = gi.histories.create_history(
            config["hist"]["ref_genome_prep"])["id"]
        datamap = dict()
        datamap["inputs"] = []
        # Retrieve the dataset to merge
        for dataset in gi.histories.show_matching_datasets(hist):
            if dataset['name'].find("chr") != -1:
                to_merge.append({'src':'hda', 'id': dataset["id"]})
        # Combine the chromosome files together
        tool_id = get_tool_id("Concatenate datasets")
        info = gi.tools.run_tool(hist, tool_id, datamap)


rule extract_sample_count_tables:
    '''
    Launch workflow to extract the count tables for each sample
    '''
    input:
        "tmp/prepare_ref_genome"
    output:
        temp("tmp/extract_sample_count_tables")
    run:
        # Get workflow id
        wf_id = get_workflow_id("sample_analysis")["id"]
        # Retrieve all the samples
        for dataset in gi.histories.show_matching_datasets(hist):
            if not dataset['name'].endswith("sra"):
                continue
            # Extract the workflow name
            sample_name = dataset['name'].split("/")[1].split(".")[0]
            # Launch the workflow
            gi.workflows.invoke_workflow(
                wf_id,
                inputs={'1': {'id': dataset['id'], 'src': 'hda'}},
                history_name=sample_name)


rule run_differential_analysis:
    '''
    Launch workflow to run the differential analysis
    '''
    input:
        "tmp/extract_sample_count_tables"
    output:
        temp("tmp/run_differential_analysis")
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
